using AttachmentService;
using Core.BaseUtility.Utility;
using MediatR;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.DirectSales.Command;
using AttachmentService.Command;
using AttachmentService.Result;
using NPOI.SS.UserModel;
using NPOI.HSSF.UserModel;
using NPOI.XSSF.UserModel;
using PSI.Modules.Backends.Constants;
using PSI.Modules.Backends.Helpers;
using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace PSI.Modules.Backends.DirectSales.CommandHandler
{
    public class SSDForecastUploadHandler : IRequestHandler<SSDForecastUploadCommand, Result>
    {
        private readonly IAttachmentService _attachmentService;
        private readonly PSIDbContext _context;

        public SSDForecastUploadHandler(IAttachmentService attachmentService)
        {
            _attachmentService = attachmentService;
            _context = new PSIDbContext();
        }

        /// <summary>
        /// Handle SSD Forecast Uploaded File
        /// </summary>
        /// <param name="request"></param>
        /// <param name="cancellationToken"></param>
        /// <returns></returns>
        public async Task<Result> Handle(SSDForecastUploadCommand request, CancellationToken cancellationToken)
        {
            try
            {
                FileCommand fileCommand = new FileCommand
                {
                    File = request.SSDForecastUpload.File,
                    FileTypeId = request.SSDForecastUpload.FileTypeId,
                    FolderPath = request.SSDForecastUpload.FolderPath,
                };
                var uploadedResult = await _attachmentService.UploadFiles(fileCommand, request.SessionData, true);
                if (uploadedResult == null)
                {
                    return ReturnErrorResponse("500", "Error while uploading SSD Forecast in blob.");
                }

                var ssdEntryData = ReadExcelFile(request.SSDForecastUpload, uploadedResult);

                return PrepareAndSaveSSDForecast(ssdEntryData, request, uploadedResult);
            }
            catch (Exception ex)
            {
                Log.Error($"Error in uploading/reading SSD Forecast file with Message - {ex.Message}. StackTrace - {ex.StackTrace}");
                if (ex.Message== "Can't upload file storage account")
                {
                    return ReturnErrorResponse("500", "Oops, Can't upload file storage account. Please try again later.");
                }
                else
                {
                    return ReturnErrorResponse("500", Contants.ERROR_MSG);
                }
                
               
            }

        }

        private Result ReturnErrorResponse(string errorCode, string errorMessage)
        {
            var result = new List<SP_Insert_SSD_Entries>(){
                new SP_Insert_SSD_Entries{
                    RowNo = 0,
                    ResponseCode = errorCode,
                    ResponseMessage = errorMessage,
                }
            };
            return Result.SuccessWith<List<SP_Insert_SSD_Entries>>(result);
        }

        private SSDEntryData ReadExcelFile(SSDForecastUpload command, FileUploadResult fileData)
        {
            string fileName;
            var file = command.File;
            fileName = Guid.NewGuid() + Path.GetExtension(file.FileName);
            var ssdEntryData = new SSDEntryData();
            try
            {
                if (file != null)
                {
                    var fileExt = Path.GetExtension(file.FileName);
                    MemoryStream fs = new MemoryStream(fileData.FileBytes);
                    //var fs = file.OpenReadStream();
                    IWorkbook workbook = null;
                    ISheet currentWorksheet;
                    var sheetNames = new List<string>();
                    if (fileExt == ".xls")
                    {
                        workbook = new HSSFWorkbook(fs);
                    }
                    else
                    {
                        workbook = new XSSFWorkbook(fs);
                    }
                    if (workbook != null)
                    {
                        currentWorksheet = workbook.GetSheetAt(0);
                        var lastRowIndexToRead = currentWorksheet.LastRowNum;
                        int rowToReadFrom = 1, uploadFlagIndex = 0;
                        var headerMonthRow = currentWorksheet.GetRow(rowToReadFrom);
                        int headerMonthRowCellCount = headerMonthRow.LastCellNum;
                        var monthList = new List<int>();
                        for (int colIndex = 0; colIndex <= headerMonthRowCellCount; colIndex++)
                        {
                            if (monthList.Count() == 12)
                            {
                                break;
                            }
                            ICell cell = headerMonthRow.GetCell(colIndex);
                            if (cell != null && cell.CellType == CellType.Numeric && DateUtil.IsCellDateFormatted(cell))
                            {
                                DateTime cellValue = cell.DateCellValue;
                                monthList.Add(Convert.ToInt32(Helper.GetMonthYearFromDate(cellValue)));
                            }
                        }

                        var headerForecastRow = currentWorksheet.GetRow(rowToReadFrom + 1);
                        int headerForeCastRowCellCount = headerForecastRow.LastCellNum;
                        var forecastColIndexList = new List<int>();
                        bool isQuarterColSkipped = false;
                        for (int colIndex = 0; colIndex <= headerForeCastRowCellCount; colIndex++)
                        {
                            ICell cell = headerForecastRow.GetCell(colIndex);
                            string cellValue = Helper.GetCellValue(cell);
                            if (cellValue == "F'cast")
                            {
                                if (forecastColIndexList.Count() == 12)
                                {
                                    break;
                                }

                                if (forecastColIndexList.Count() == 0 ||
                                forecastColIndexList.Count() % 3 != 0 ||
                                (forecastColIndexList.Count() % 3 == 0 && isQuarterColSkipped))
                                {
                                    forecastColIndexList.Add(colIndex);
                                    isQuarterColSkipped = false;
                                }
                                else
                                {
                                    isQuarterColSkipped = true;
                                }
                            }
                        }
                        int lastForeCastColIndex = forecastColIndexList.Last();
                        for (int rowIndex = rowToReadFrom + 2; rowIndex <= lastRowIndexToRead; rowIndex++)
                        {

                            var currentRow = currentWorksheet.GetRow(rowIndex);
                            if (currentRow != null)
                            {
                                var uploadFlagCell = currentRow.GetCell(uploadFlagIndex);
                                bool skipThisRow = false;
                                if (uploadFlagCell == null || (uploadFlagCell != null && uploadFlagCell.ToString() != Contants.DirectSale_UploadFlag)) skipThisRow = true;
                                int currentRowCellCount = currentRow.LastCellNum;
                                if (!skipThisRow)
                                {
                                    var entryRow = new SSDEntryRow()
                                    {
                                        RowIndex = rowIndex,
                                    };
                                    for (int colIndex = 0; colIndex <= currentRowCellCount; colIndex++)
                                    {
                                        ICell cell = currentRow.GetCell(colIndex);
                                        string cellValue = Helper.GetCellValue(cell);
                                        if (colIndex == 0 || colIndex == 1 || colIndex == 2)
                                        {
                                            PopulateEntryRowData(entryRow, colIndex, rowIndex, cellValue);
                                        }
                                        int forecastColIndex = forecastColIndexList.IndexOf(colIndex);
                                        if (colIndex <= lastForeCastColIndex && forecastColIndex >= 0)
                                        {
                                            var qtyPriceInfo = new SSDQtyPriceInfo()
                                            {
                                                RowIndex = rowIndex,
                                                ColIndex = colIndex,
                                                MonthYear = monthList[forecastColIndex],
                                                Qty = 0,
                                                Price = 0
                                            };
                                            if (!string.IsNullOrEmpty(cellValue))
                                            {
                                                decimal priceValue = 0;
                                                var isValid = decimal.TryParse(cellValue, out priceValue);
                                                if (isValid && priceValue > 0)
                                                {
                                                    qtyPriceInfo.Price = priceValue;
                                                    qtyPriceInfo.Qty = 1000; // default value
                                                }
                                            }
                                            ssdEntryData.SSDQtyPriceInfos.Add(qtyPriceInfo);
                                        }
                                    }

                                    ssdEntryData.SSDEntryRows.Add(entryRow);
                                }
                            }

                        }
                    }
                }
                return ssdEntryData;
            }
            catch (Exception)
            {
                throw;
            }
        }

        /// <summary>
        /// Populate SSD Entry RowData
        /// </summary>
        /// <param name="entryRow"></param>
        /// <param name="colIndex"></param>
        /// <param name="rowIndex"></param>
        /// <param name="cellValue"></param>
        /// <returns></returns>
        private void PopulateEntryRowData(SSDEntryRow entryRow, int colIndex, int rowIndex, string cellValue)
        {
            switch (colIndex)
            {
                case 0:
                    entryRow.UploadFlag = cellValue;
                    break;
                case 1:
                    entryRow.CustomerCode = cellValue;
                    break;
                case 2:
                    entryRow.MaterialCode = cellValue;
                    break;
            }
        }

        /// <summary>
        /// Prepare Data And Save SSD Forecast
        /// </summary>
        /// <param name="ssdEntryData"></param>
        /// <param name="command"></param>
        /// <param name="uploadedResult"></param>
        /// <returns></returns>
        private Result PrepareAndSaveSSDForecast(SSDEntryData ssdEntryData, SSDForecastUploadCommand command, FileUploadResult uploadedResult)
        {
            try
            {
                if (ssdEntryData != null && ssdEntryData.SSDEntryRows.Count > 0)
                {

                    var dtSSDQtyPriceInfos = new DataTable();
                    dtSSDQtyPriceInfos.Columns.Add(new DataColumn("RowNo", typeof(int)));
                    dtSSDQtyPriceInfos.Columns.Add(new DataColumn("RowIndex", typeof(int)));
                    dtSSDQtyPriceInfos.Columns.Add(new DataColumn("MonthYear", typeof(int)));
                    dtSSDQtyPriceInfos.Columns.Add(new DataColumn("Qty", typeof(int)));
                    dtSSDQtyPriceInfos.Columns.Add(new DataColumn("Price", typeof(decimal)));
                    dtSSDQtyPriceInfos.Columns.Add(new DataColumn("ModeofTypeId", typeof(int)));
                    dtSSDQtyPriceInfos.Columns.Add(new DataColumn("CustomerCode", typeof(string)));
                    dtSSDQtyPriceInfos.Columns.Add(new DataColumn("MaterialCode", typeof(string)));
                    dtSSDQtyPriceInfos.Columns.Add(new DataColumn("MaterialId", typeof(int)));
                    dtSSDQtyPriceInfos.Columns.Add(new DataColumn("CustomerId", typeof(int)));

                    List<string> li = new List<string>();

                    var modeoftype = _context.ModeofType.Where(x => x.ModeofTypeCode == "O" || x.ModeofTypeCode == "P"
                    || x.ModeofTypeCode == "S" || x.ModeofTypeCode == "I" || x.ModeofTypeCode == "MPO"
                    || x.ModeofTypeCode == "ADJ").ToList();
                  
                    foreach (var row in ssdEntryData.SSDQtyPriceInfos)
                    {
                        var data = ssdEntryData.SSDEntryRows.Where(x => x.RowIndex == row.RowIndex).FirstOrDefault();
                        foreach (var mode in modeoftype)
                        {
                            if (mode.ModeofTypeCode == "O")
                            {
                                dtSSDQtyPriceInfos.Rows.Add(
                            null,
                            row.RowIndex,
                            row.MonthYear,
                            row.Qty,
                            row.Price,
                            mode.ModeofTypeId,
                            data.CustomerCode,
                            data.MaterialCode,
                            null,
                            null
                            );
                            }
                            else
                            {
                                dtSSDQtyPriceInfos.Rows.Add(
                                                                null,
                                           row.RowIndex,
                      row.MonthYear,
                     0,
                      0,
                      mode.ModeofTypeId,
                        data.CustomerCode,
                            data.MaterialCode,
                            null,
                            null
                      );
                            }

                        }
                    }

                    return SaveSSDForecast(command, uploadedResult, dtSSDQtyPriceInfos, ssdEntryData.ResponseList);
                }
                else
                {
                    return ReturnErrorResponse("500", "No Valid Data To Process.");
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        /// <summary>
        /// Save the SSD Forecast to DB
        /// </summary>
        /// <param name="command"></param>
        /// <param name="uploadedResult"></param>
        /// <param name="dtSSDEntries"></param>
        /// <param name="dtSSDQtyPriceInfos"></param>
        /// <param name="responseList"></param>
        /// <returns></returns>
        private Result SaveSSDForecast(SSDForecastUploadCommand command, FileUploadResult uploadedResult,  DataTable dtSSDQtyPriceInfos, List<SP_Insert_SSD_Entries> responseList)
        {
            try
            {


                var qtyPriceInfo = new SqlParameter("@tvpSSDQtyPrices", SqlDbType.Structured);
                qtyPriceInfo.Value = dtSSDQtyPriceInfos;
                qtyPriceInfo.TypeName = "dbo.TVP_SSD_ENTRY_QTY_PRICES";
               
                var userId = new SqlParameter("@userId", SqlDbType.NVarChar, 100);
                userId.Value = command.SessionData.ADUserId ?? string.Empty;

                var attachmentId = new SqlParameter("@attachmentId", SqlDbType.Int);
                attachmentId.Value = uploadedResult != null ? uploadedResult.Id : 0;

                var param = new SqlParameter[] {
                   
                    qtyPriceInfo,
                    userId,
                    attachmentId
                    };

                var result = _context.SP_Insert_SSD_Entries.FromSqlRaw("dbo.SP_Insert_SSD_Entries  @tvpSSDQtyPrices, @userId, @attachmentId", param).AsNoTracking().ToList();

                if (result != null && result.ToList().Any())
                {
                    var spResult = result.ToList().Where(r => r.ResponseCode != "200");
                    responseList.AddRange(spResult);
                    if (responseList.Any())
                    {
                        responseList = responseList.OrderBy(c => c.RowNo).ToList();
                        return Result.SuccessWith<List<SP_Insert_SSD_Entries>>(responseList);
                    }
                    else
                    {
                        var successRespone = result.Where(r => r.ResponseCode == "200").ToList();
                        if (successRespone.Count() > 0)
                        {
                            Task.Run(() => _attachmentService.ActivateFile(uploadedResult.Id));
                            return Result.SuccessWith<List<SP_Insert_SSD_Entries>>(successRespone);
                        }
                        else
                        {
                            return ReturnErrorResponse("500", Contants.ERROR_MSG);
                        }
                    }
                }
                else
                {
                    return ReturnErrorResponse("500", Contants.ERROR_MSG);
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

    }
}