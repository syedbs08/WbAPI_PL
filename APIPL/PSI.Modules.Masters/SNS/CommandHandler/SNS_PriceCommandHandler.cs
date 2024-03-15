using AttachmentService;
using AttachmentService.Command;
using AttachmentService.Result;
using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using NPOI.HSSF.UserModel;
using NPOI.SS.Formula.Functions;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Constants;
using PSI.Modules.Backends.Helpers;
using PSI.Modules.Backends.SNS.Command;
using System.Data;
using static PSI.Modules.Backends.Constants.Contants;

namespace PSI.Modules.Backends.SNS.CommandHandler
{
    public class SSNPriceCommandHandler : IRequestHandler<SNS_PriceCommand, Result>
    {
        private readonly IAttachmentService _attachmentService;
        private readonly PSIDbContext _context;
        public SSNPriceCommandHandler(IAttachmentService attachmentService)
        {
            _attachmentService = attachmentService;
            _context = new PSIDbContext();
        }
        public async Task<Result> Handle(SNS_PriceCommand request, CancellationToken cancellationToken)
        {
            FileCommand fileCommand = new FileCommand
            {
                File = request.SSN_Price.File,
                FileTypeId = request.SSN_Price.FileTypeId,
                FolderPath = request.SSN_Price.FolderPath,
            };
            var uploadedResult = await _attachmentService.UploadFiles(fileCommand, request.SessionData, true);
            if (uploadedResult == null)
            {
                return ReturnErrorResponse("500", "Error while uploading snc price in blob.");
            }
            var sncPriceData = ReadExcelFile(request.SSN_Price, uploadedResult);

            if (sncPriceData == null)
            {
                return ReturnErrorResponse("500", "Error while reading sns price uploaded file.");
            }
            if (sncPriceData.ResponseList != null && sncPriceData.ResponseList.Count() > 0)
            {
                return Result.SuccessWith<List<SP_InsertSNCPrices>>(sncPriceData.ResponseList);
            }
            return PrepareAndSaveSNSStockPrice(sncPriceData, request, uploadedResult);

        }
        private Result ReturnErrorResponse(string errorCode, string errorMessage)
        {
            var result = new List<SP_InsertSNCPrices>(){
                new SP_InsertSNCPrices{
                    ResponseCode = errorCode,
                }
            };
            return Result.SuccessWith<List<SP_InsertSNCPrices>>(result);
        }
        private bool IsEmptyRow(IRow row)
        {
            for (int cellIndex = row.FirstCellNum; cellIndex < row.LastCellNum; cellIndex++)
            {
                ICell cell = row.GetCell(cellIndex);
                if (cell != null && cell.CellType != CellType.Blank)
                {
                    return false;
                }
            }

            return true;
        }
        private SNSPricingData ReadExcelFile(SNS_Price command, FileUploadResult fileData)
        {
            var file = command.File;
            string fileName = Guid.NewGuid() + Path.GetExtension(file.FileName);
            var snsPriceData = new SNSPricingData();
            snsPriceData.ResponseList = new List<SP_InsertSNCPrices>();
            try
            {
                if (file != null)
                {

                    var ssnPriceDataExcelHeaders = new List<SNSPriceDataExcelHeader>();
                    var fileExt = Path.GetExtension(file.FileName);
                    MemoryStream fs = new MemoryStream(fileData.FileBytes);
                    IWorkbook workbook = null;
                    ISheet currentWorksheet;
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
                        foreach (var sheet in workbook)
                        {

                            // Iterate over each sheet in the workbook
                            for (int sheetIndex = 0; sheetIndex < workbook.NumberOfSheets; sheetIndex++)
                            {

                                // Create a list to store the rows to be removed
                                var rowsToRemove = new System.Collections.Generic.List<IRow>();

                                // Iterate over each row in the sheet in reverse order
                                for (int rowIndex = sheet.LastRowNum; rowIndex >= 0; rowIndex--)
                                {
                                    IRow row = sheet.GetRow(rowIndex);

                                    // Check if the row is null or empty (all cells are null or empty)
                                    if (row == null || IsEmptyRow(row))
                                    {
                                        // Add the row to the list of rows to be removed
                                        rowsToRemove.Add(row);
                                    }
                                }

                                // Remove the empty rows
                                foreach (var row in rowsToRemove)
                                {
                                    sheet.RemoveRow(row);
                                }
                            }

                            currentWorksheet = sheet;
                            var lastRowIndexToRead = currentWorksheet.LastRowNum;
                            int uploadFlagIndex = 0, typeColumnIndex = 0, rowToReadFrom = 0, adl1ColumnIndex = 0, adl2ColumnIndex = 0, adl3ColumnIndex = 0;

                            var headerRow = currentWorksheet.GetRow(rowToReadFrom);
                            int headerRowCellCount = headerRow.LastCellNum;

                            //Read Header Row
                            GetMarkedIndexFromHeaderRow(headerRowCellCount, headerRow, ssnPriceDataExcelHeaders, out uploadFlagIndex); //Read Body Content
                            for (int rowIndex = rowToReadFrom + 1; rowIndex <= lastRowIndexToRead; rowIndex++)
                            {
                                var currentRow = currentWorksheet.GetRow(rowIndex);
                                int currentRowCellCount = currentRow.LastCellNum;
                                
                                var ssnsalesDataExcelRow = new SALESRows();
                                var fobDataExcelRow = new FOBRows();


                                for (int colIndex = 0; colIndex <= currentRowCellCount; colIndex++)
                                {
                                    ICell cell = currentRow.GetCell(colIndex);
                                    if (cell != null)
                                    {
                                        string cellValue = Helper.GetCellValue(cell);
                                        if (ModeOfTypeEnum.S.ToString().ToLower() == command.StockPriceType.ToLower().ToString())
                                        {
                                            if (currentWorksheet.SheetName.ToLower() == CommandEnum.SnsPriceSheetName.SALES.ToString().ToLower())
                                            {

                                                PopulateData(colIndex, cellValue, ssnsalesDataExcelRow);
                                            }
                                        }
                                        if (ModeOfTypeEnum.FOB.ToString().ToLower() == command.StockPriceType.ToLower().ToString())
                                        {
                                            if (currentWorksheet.SheetName.ToLower() == CommandEnum.SnsPriceSheetName.FOB.ToString().ToLower())
                                            {
                                                FOBPopulateData(colIndex, cellValue, fobDataExcelRow);
                                            }
                                        }

                                    }

                                }
                              
                                if (ModeOfTypeEnum.S.ToString().ToLower() == command.StockPriceType.ToLower().ToString())
                                {
                                    if (currentWorksheet.SheetName.ToLower() == "SALES".ToLower())
                                    {

                                        if (ssnsalesDataExcelRow.Cust_Code == null || ssnsalesDataExcelRow.Cust_Code.Trim() == "")
                                        {
                                            snsPriceData.ResponseList.Add(new SP_InsertSNCPrices
                                            {
                                                ResponseCode = "107",
                                                ResponseMessage = $"RowNo: {rowIndex}   CustomerCode is empty"
                                            });

                                        }
                                        if (ssnsalesDataExcelRow.Sales_Org == null || ssnsalesDataExcelRow.Sales_Org.Trim() == "")
                                        {
                                            snsPriceData.ResponseList.Add(new SP_InsertSNCPrices
                                            {
                                                ResponseCode = "107",
                                                ResponseMessage = $"RowNo: {rowIndex}   Sales Organization is empty"
                                            });

                                        }
                                        if (ssnsalesDataExcelRow.Ship_Mode == null || ssnsalesDataExcelRow.Ship_Mode.Trim() == "")
                                        {
                                            snsPriceData.ResponseList.Add(new SP_InsertSNCPrices
                                            {
                                                ResponseCode = "107",
                                                ResponseMessage = $"RowNo: {rowIndex}   Ship Mode is empty"
                                            });
                                        }
                                        if (ssnsalesDataExcelRow.MaterailCode == null || ssnsalesDataExcelRow.MaterailCode.Trim() == "")
                                        {
                                            snsPriceData.ResponseList.Add(new SP_InsertSNCPrices
                                            {
                                                ResponseCode = "107",
                                                ResponseMessage = $"RowNo: {rowIndex}   Materail Code is empty"
                                            });

                                        }
                                        var currentmonth = _context.GlobalConfig.Where(x => x.ConfigKey == "Current_Month").Select(x=>x.ConfigValue).FirstOrDefault();
                                        DateTime? currentDateTime = Helper.GetDateFromMonthYear(currentmonth);
                                       var a= ssnsalesDataExcelRow.From_Dt.Date;
                                        var b = currentDateTime.Value.Date;
                                       
                                       
                                        if (ssnsalesDataExcelRow.From_Dt.Date.AddDays(1) <= currentDateTime.Value.Date)
                                        {
                                            snsPriceData.ResponseList.Add(new SP_InsertSNCPrices
                                            {
                                                ResponseCode = "107",
                                                ResponseMessage = $"RowNo: {rowIndex}   From date should be greater than or equal to current date"
                                            });
                                        }
                                        if (ssnsalesDataExcelRow.To_Dt.Date.AddDays(1) <= currentDateTime.Value.Date)
                                        {
                                            snsPriceData.ResponseList.Add(new SP_InsertSNCPrices
                                            {
                                                ResponseCode = "107",
                                                ResponseMessage = $"RowNo: {rowIndex}   To date should be greater than or equal to current date"
                                            });
                                        }
                                        if (ssnsalesDataExcelRow.Curr == null || ssnsalesDataExcelRow.Curr.Trim() == "")
                                        {
                                            snsPriceData.ResponseList.Add(new SP_InsertSNCPrices
                                            {
                                                ResponseCode = "107",
                                                ResponseMessage = $"RowNo: {rowIndex}   Currency Code is empty"
                                            });
                                        }
                                        snsPriceData.SALESRows.Add(ssnsalesDataExcelRow);
                                    }
                                }

                                // check ur code its not going inside
                                if (ModeOfTypeEnum.FOB.ToString().ToLower() == command.StockPriceType.ToLower().ToString())
                                {
                                    if (currentWorksheet.SheetName.ToLower() == "FOB".ToLower())
                                    {
                                        if (fobDataExcelRow.MaterailCode == null || fobDataExcelRow.MaterailCode.Trim() == "")
                                    {
                                        snsPriceData.ResponseList.Add(new SP_InsertSNCPrices
                                        {
                                            ResponseCode = "107",
                                            ResponseMessage = $"RowNo: {rowIndex}   Material Code is empty"
                                        });

                                    }
                                    if (fobDataExcelRow.Curr == null || fobDataExcelRow.Curr.Trim() == "")
                                    {
                                        snsPriceData.ResponseList.Add(new SP_InsertSNCPrices
                                        {
                                            ResponseCode = "107",
                                            ResponseMessage = $"RowNo: {rowIndex}   Currency Code is empty"
                                        });
                                    }
                                    if (fobDataExcelRow.From_Dt.Date <= DateTime.Now.Date)
                                    {
                                        snsPriceData.ResponseList.Add(new SP_InsertSNCPrices
                                        {
                                            ResponseCode = "107",
                                            ResponseMessage = $"RowNo: {rowIndex}   From date should be greater than or equal to current date"
                                        });
                                    }
                                    if (fobDataExcelRow.To_Dt.Date <= DateTime.Now.Date)
                                    {
                                        snsPriceData.ResponseList.Add(new SP_InsertSNCPrices
                                        {
                                            ResponseCode = "107",
                                            ResponseMessage = $"RowNo: {rowIndex}   To date should be greater than or equal to current date"
                                        });
                                    }
                                   
                                        snsPriceData.FOBRows.Add(fobDataExcelRow);
                                    }
                                }

                            }
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                Core.BaseUtility.Utility.Log.Error($"Execption occured while adding SNS Sale ReadExcelFile ", ex);               
                throw ex;
            }
            return snsPriceData;

        }
        private void GetMarkedIndexFromHeaderRow(int headerRowCellCount, IRow headerRow, List<SNSPriceDataExcelHeader> ssnPriceDataExcelHeaders,
           out int uploadFlagIndex)
        {
            uploadFlagIndex = 0;

            for (int colIndex = 0; colIndex <= headerRowCellCount; colIndex++)
            {
                ICell cell = headerRow.GetCell(colIndex);
                if (cell != null)
                {

                    switch (cell.ToString())
                    {

                        case nameof(CommandEnum.SnsSalesPriceExelHeaderEnum.SALES_ORG):
                            uploadFlagIndex = colIndex;
                            break;
                        case nameof(CommandEnum.SnsSalesPriceExelHeaderEnum.DIST_CHNL):
                            uploadFlagIndex = colIndex;
                            break;
                        case nameof(CommandEnum.SnsSalesPriceExelHeaderEnum.CUST_CODE):
                            uploadFlagIndex = colIndex;
                            break;
                        case nameof(CommandEnum.SnsSalesPriceExelHeaderEnum.SHIP_MODE):
                            uploadFlagIndex = colIndex;
                            break;
                        case nameof(CommandEnum.SnsSalesPriceExelHeaderEnum.INCO_TERM):
                            uploadFlagIndex = colIndex;
                            break;

                        case nameof(CommandEnum.SnsSalesPriceExelHeaderEnum.TERMID):
                            uploadFlagIndex = colIndex;
                            break;
                        case nameof(CommandEnum.SnsSalesPriceExelHeaderEnum.MATERIALCODE):
                            uploadFlagIndex = colIndex;
                            break;
                        case nameof(CommandEnum.SnsSalesPriceExelHeaderEnum.From_DT):
                            uploadFlagIndex = colIndex;
                            break;
                        case nameof(CommandEnum.SnsSalesPriceExelHeaderEnum.To_DT):
                            uploadFlagIndex = colIndex;
                            break;
                        case nameof(CommandEnum.SnsSalesPriceExelHeaderEnum.Price):
                            uploadFlagIndex = colIndex;
                            break;
                        case nameof(CommandEnum.SnsSalesPriceExelHeaderEnum.Price_UNIT):
                            uploadFlagIndex = colIndex;
                            break;
                        case nameof(CommandEnum.SnsSalesPriceExelHeaderEnum.CURR):
                            uploadFlagIndex = colIndex;
                            break;
                        case nameof(CommandEnum.SnsSalesPriceExelHeaderEnum.UOM):
                            uploadFlagIndex = colIndex;
                            break;
                        case nameof(CommandEnum.SnsSalesPriceExelHeaderEnum.Plant):
                            uploadFlagIndex = colIndex;
                            break;

                        case nameof(CommandEnum.SnsSalesPriceExelHeaderEnum.VENDOR):
                            uploadFlagIndex = colIndex;
                            break;
                        case nameof(CommandEnum.SnsSalesPriceExelHeaderEnum.PORT):
                            uploadFlagIndex = colIndex;
                            break;

                    }
                    if (uploadFlagIndex == 0)
                    {
                        ssnPriceDataExcelHeaders.Add(new SNSPriceDataExcelHeader { Index = colIndex, Name = cell.ToString() });
                    }
                    else
                    {
                        break;
                    }
                }
            }
        }

        private void PopulateData(int colIndex, string cellValue, SALESRows snsDataExcelRow)
        {

            switch (colIndex)
            {
                case 0:
                    snsDataExcelRow.Sales_Org = cellValue;
                    break;
                case 1:
                    snsDataExcelRow.Dist_Chnl = cellValue;
                    break;
                case 2:
                    snsDataExcelRow.Cust_Code = cellValue;
                    break;
                case 3:
                    snsDataExcelRow.Ship_Mode = cellValue;
                    break;
                case 4:
                    snsDataExcelRow.Inco_Term = cellValue;
                    break;
                case 5:
                    snsDataExcelRow.Termid = cellValue;
                    break;
                case 6:
                    snsDataExcelRow.MaterailCode = cellValue;
                    break;
                case 7:
                    snsDataExcelRow.From_Dt = DateTime.ParseExact(cellValue, "dd/MM/yyyy", null);
                    break;
                case 8:
                    snsDataExcelRow.To_Dt = DateTime.ParseExact(cellValue, "dd/MM/yyyy", null);
                    break;
                case 9:
                    if (cellValue != null && cellValue != "")
                    {
                        snsDataExcelRow.Price = Convert.ToDouble(cellValue);
                    }
                    break;
                case 10:
                    snsDataExcelRow.Price_Unit = cellValue;
                    break;
                case 11:
                    snsDataExcelRow.Curr = cellValue;
                    break;
                case 12:
                    snsDataExcelRow.Uom = cellValue;
                    break;
            }
        }
        private void FOBPopulateData(int colIndex, string cellValue, FOBRows fOBRow)
        {

            switch (colIndex)
            {
                case 0:
                    if (cellValue != null && cellValue != "")
                    {
                        fOBRow.Plant = Convert.ToInt32(cellValue);
                    }

                    break;
                case 1:
                    if (cellValue != null && cellValue != "")
                    {
                        fOBRow.Vendor = Convert.ToInt32(cellValue);
                    }
                    break;
                case 2:
                    fOBRow.Cust_Code = cellValue;
                    break;
                case 3:
                    fOBRow.Inco_Term = cellValue;
                    break;
                case 4:
                    fOBRow.TermId = cellValue;
                    break;
                case 5:
                    fOBRow.MaterailCode = cellValue;
                    break;
                case 6:
                    fOBRow.From_Dt = DateTime.ParseExact(cellValue, "dd/MM/yyyy", null);
                    break;
                case 7:
                    fOBRow.To_Dt = DateTime.ParseExact(cellValue, "dd/MM/yyyy", null);
                    break;
                case 8:
                    if (cellValue != null && cellValue != "")
                    {
                        fOBRow.Price = Convert.ToDouble(cellValue);
                    }
                    break;
                case 9:
                    if (cellValue != null && cellValue != "")
                    {
                        fOBRow.Price_Unit = Convert.ToInt16(cellValue);
                    }
                    break;
                case 10:
                    fOBRow.Curr = cellValue;
                    break;
                case 11:
                    fOBRow.Uom = cellValue;
                    break;
                case 12:
                    fOBRow.Port = cellValue;
                    break;
            }
        }

        //SNSPricingData
        public Result PrepareAndSaveSNSStockPrice(SNSPricingData sNSPricingData, SNS_PriceCommand priceCommand, FileUploadResult uploadedResult)
        {

            if (sNSPricingData == null && (sNSPricingData.SALESRows.Count == 0 && sNSPricingData.FOBRows.Count == 0))
            {
                return ReturnErrorResponse("500", "No Valid Data To Process.");
            }
            var dtSalesPrice = new DataTable();
            if (sNSPricingData != null && sNSPricingData.SALESRows.Count > 0)
            {
                dtSalesPrice.Columns.Add(new DataColumn("RowIndex", typeof(int)));
                dtSalesPrice.Columns.Add(new DataColumn("Sales_Org", typeof(string)));
                dtSalesPrice.Columns.Add(new DataColumn("Dist_Chnl", typeof(string)));
                dtSalesPrice.Columns.Add(new DataColumn("Cust_Code", typeof(string)));
                dtSalesPrice.Columns.Add(new DataColumn("Ship_Mode", typeof(string)));
                dtSalesPrice.Columns.Add(new DataColumn("Inco_Term", typeof(string)));
                dtSalesPrice.Columns.Add(new DataColumn("Termid", typeof(string)));
                dtSalesPrice.Columns.Add(new DataColumn("MaterailCode", typeof(string)));
                dtSalesPrice.Columns.Add(new DataColumn("From_Dt", typeof(DateTime)));
                dtSalesPrice.Columns.Add(new DataColumn("To_Dt", typeof(DateTime)));
                dtSalesPrice.Columns.Add(new DataColumn("Price", typeof(string)));
                dtSalesPrice.Columns.Add(new DataColumn("Price_Unit", typeof(string)));
                dtSalesPrice.Columns.Add(new DataColumn("Curr", typeof(string)));
                dtSalesPrice.Columns.Add(new DataColumn("Uom", typeof(string)));
                dtSalesPrice.Columns.Add(new DataColumn("ModeTypeOf", typeof(string)));
                //Set row index
                int index = 1;
                foreach (var row in sNSPricingData.SALESRows)
                {
                    row.RowIndex = index;
                    dtSalesPrice.Rows.Add(
                        row.RowIndex,
                        row.Sales_Org,
                        row.Dist_Chnl,
                        row.Cust_Code,
                        row.Ship_Mode,
                        row.Inco_Term,
                        row.Termid,
                        row.MaterailCode,
                        row.From_Dt,
                        row.To_Dt,
                        row.Price,
                        row.Price_Unit,
                        row.Curr,
                        row.Uom,
                        priceCommand.SSN_Price.StockPriceType
                        );
                    index++;
                }
            }
            var dtFOBPrice = new DataTable();

            if (sNSPricingData != null && sNSPricingData.FOBRows.Count > 0)
            {
                dtFOBPrice.Columns.Add(new DataColumn("RowIndex", typeof(int)));
                dtFOBPrice.Columns.Add(new DataColumn("Plant", typeof(string)));
                dtFOBPrice.Columns.Add(new DataColumn("Vendor", typeof(string)));
                dtFOBPrice.Columns.Add(new DataColumn("Cust_Code", typeof(string)));
                dtFOBPrice.Columns.Add(new DataColumn("Inco_Term", typeof(string)));
                dtFOBPrice.Columns.Add(new DataColumn("Termid", typeof(string)));
                dtFOBPrice.Columns.Add(new DataColumn("MaterailCode", typeof(string)));
                dtFOBPrice.Columns.Add(new DataColumn("From_Dt", typeof(DateTime)));
                dtFOBPrice.Columns.Add(new DataColumn("To_Dt", typeof(DateTime)));
                dtFOBPrice.Columns.Add(new DataColumn("Price", typeof(string)));
                dtFOBPrice.Columns.Add(new DataColumn("Price_Unit", typeof(string)));
                dtFOBPrice.Columns.Add(new DataColumn("Curr", typeof(string)));
                dtFOBPrice.Columns.Add(new DataColumn("Uom", typeof(string)));
                dtFOBPrice.Columns.Add(new DataColumn("Port", typeof(string)));
                dtFOBPrice.Columns.Add(new DataColumn("ModeTypeOf", typeof(string)));
                int index1 = 1;
                foreach (var row in sNSPricingData.FOBRows)
                {
                    row.RowIndex = index1;
                    dtFOBPrice.Rows.Add(
                        row.RowIndex,
                        row.Plant,
                        row.Vendor,
                        row.Cust_Code,
                        row.Inco_Term,
                        row.TermId,
                        row.MaterailCode,
                        row.From_Dt,
                        row.To_Dt,
                        row.Price,
                        row.Price_Unit,
                        row.Curr,
                        row.Uom,
                        row.Port,
                        priceCommand.SSN_Price.StockPriceType
                        );
                    index1++;
                }
            }
            return SaveSNSStockPrice(priceCommand, dtSalesPrice, dtFOBPrice, sNSPricingData.ResponseList, priceCommand, uploadedResult.Id);
        }
        private Result SaveSNSStockPrice(SNS_PriceCommand command, DataTable dtSNSPrice, DataTable dtSNSFOB, List<SP_InsertSNCPrices> responseList,
            SNS_PriceCommand modeTypeCode,int attachmentId)
        {

            try
            {
                var userId = new SqlParameter("@UserId", SqlDbType.VarChar);
                userId.Value = command.SessionData.Email;

                if (ModeOfTypeEnum.S.ToString().ToLower() == modeTypeCode.SSN_Price.StockPriceType.ToLower().ToString())
                {
                    var attachmentIdParam = new SqlParameter("@AttachmentId", SqlDbType.Int);
                    attachmentIdParam.Value = attachmentId;
                    var ssnSaleStockEntry = new SqlParameter("@SNSSalePrice", SqlDbType.Structured);
                    ssnSaleStockEntry.Value = dtSNSPrice;
                    ssnSaleStockEntry.TypeName = "dbo.SNS_Sales_Price";
                    var param = new SqlParameter[] {
                    userId,
                    ssnSaleStockEntry,
                    attachmentIdParam
                    };
                    var result = _context.USP_InsertSNSPrices.FromSqlRaw("dbo.USP_InsertSNSPrice @SNSSalePrice, @UserId,@AttachmentId", param).AsNoTracking().ToList();
                    if (result != null && result.ToList().Any())
                    {
                        // var spResult = result.Where(s => s.ResponseCode == "200").ToList();
                        responseList.AddRange(result.Select(s => new SP_InsertSNCPrices
                        {
                            ResponseCode = s.ResponseCode,
                            ResponseMessage = s.ResponseMessage,
                        }));

                        if (responseList.Any())
                        {
                            Task.Run(() => _attachmentService.ActivateFile(attachmentId));
                            return Result.SuccessWith<List<SP_InsertSNCPrices>>(responseList);
                        }
                        else
                        {
                            var errorResult = new List<SP_InsertSNCPrices>(){
                                new SP_InsertSNCPrices{
                                    ResponseCode = "500",
                                    ResponseMessage = Contants.ERROR_MSG,
                                }
                            };
                            return Result.SuccessWith<List<SP_InsertSNCPrices>>(errorResult);
                        }
                    }
                    else
                    {
                        return ReturnErrorResponse("500", Contants.ERROR_MSG);
                    }
                }
                else if (ModeOfTypeEnum.FOB.ToString().ToLower() == modeTypeCode.SSN_Price.StockPriceType.ToLower().ToString())
                {
                    var ssnFOBStockEntry = new SqlParameter("@SNSFOB", SqlDbType.Structured);
                    ssnFOBStockEntry.Value = dtSNSFOB;
                    ssnFOBStockEntry.TypeName = "dbo.SNS_FOB_Price";
                    var param = new SqlParameter[] {
                    userId,
                     ssnFOBStockEntry
                    };
                    var result = _context.USP_InsertSNSPrices.FromSqlRaw("dbo.USP_InsertSNSFOBPrice @SNSFOB, @UserId", param).AsNoTracking().ToList();
                    if (result != null && result.ToList().Any())
                    {


                        responseList.AddRange(result.Select(s => new SP_InsertSNCPrices
                        {
                            ResponseCode = s.ResponseCode,
                            ResponseMessage = s.ResponseMessage,
                        }));
                        var spResult = responseList.Where(s => s.ResponseCode != "200").ToList();

                        if (responseList.Any())
                        {
                            Task.Run(() => _attachmentService.ActivateFile(attachmentId));
                            return Result.SuccessWith<List<SP_InsertSNCPrices>>(responseList);
                        }
                        else
                        {
                            var successRespone = responseList.Where(r => r.ResponseCode == "200").ToList();
                            if (successRespone.Count() > 0)
                            {
                                Task.Run(() => _attachmentService.ActivateFile(attachmentId));
                                return Result.SuccessWith<List<SP_InsertSNCPrices>>(successRespone);
                            }
                            else
                            {
                                var errorResult = new List<SP_InsertSNCPrices>(){
                                new SP_InsertSNCPrices{
                                    ResponseCode = "500",
                                    ResponseMessage = Contants.ERROR_MSG,
                                }
                            };
                                return Result.SuccessWith<List<SP_InsertSNCPrices>>(errorResult);
                            }
                        }
                    }
                    else
                    {
                        return ReturnErrorResponse("500", Contants.ERROR_MSG);
                    }
                }

                return ReturnErrorResponse("500", Contants.ERROR_MSG);
            }


            catch (Exception ex)
            {
                Core.BaseUtility.Utility.Log.Error($"Execption occured while adding SNS Sale Stock Price", ex.Message);
                return Result.Failure("Problem in adding SNS Sale Stock Price ,try later");
            }
        }
    }
}
