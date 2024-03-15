using AttachmentService;
using AttachmentService.Command;
using AttachmentService.Result;
using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Graph;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Adjustments.Command;
using PSI.Modules.Backends.Adjustments.Repository;
using PSI.Modules.Backends.Constants;
using PSI.Modules.Backends.Masters.Repository.CustomerMaster;
using PSI.Modules.Backends.Masters.Repository.GlobalConfigMaster;
using PSI.Modules.Backends.Masters.Repository.MaterialMaster;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using static PSI.Modules.Backends.Constants.Contants;

namespace PSI.Modules.Backends.Adjustments.CommandHandler
{
    public class AdjustmentImportHandler : IRequestHandler<AdjustmentEntryUploadCommand, Result>
    {
        private readonly IGlobalConfigRepository _globalConfigRepository;
        private readonly IMaterialRepository _materialReopsitory;
        private readonly ICustomerRepository _customerRepository;
        private readonly IAttachmentService _attachmentService;
        private readonly IAdjustmentEntryRepository _adjustmentEntryRepository;
        private readonly PSIDbContext _context;
        public AdjustmentImportHandler(IGlobalConfigRepository globalConfigRepository,
            IAttachmentService attachmentService,
            IMaterialRepository materialReopsitory,
            ICustomerRepository customerRepository,
            IAdjustmentEntryRepository adjustmentEntry)
        {
            _globalConfigRepository = globalConfigRepository;
            _materialReopsitory = materialReopsitory;
            _customerRepository = customerRepository;
            _attachmentService = attachmentService;
            _context = new PSIDbContext();
            _adjustmentEntryRepository = adjustmentEntry;
        }
        public async Task<Result> Handle(AdjustmentEntryUploadCommand request, CancellationToken cancellationToken)
        {
            try
            {
                var psiDateData = _globalConfigRepository.GetAll().FirstOrDefault(c => c.ConfigKey == Contants.global_config_psi_year_key);
                if (psiDateData == null)
                {

                    var result = new List<SP_INSERT_ADJUSTMENT>(){
                        new SP_INSERT_ADJUSTMENT{
                           ResponseCode = "107",
                        ResponseMessage = $"PSI Year is not available in the configuration."
                        }
                    };
                    return Result.SuccessWith<List<SP_INSERT_ADJUSTMENT>>(result);

                }

                FileCommand fileCommand = new FileCommand
                {
                    File = request?.AdjustmentEntryDetails.File,
                    FileTypeId = request.AdjustmentEntryDetails.FileTypeId,
                    FolderPath = request.AdjustmentEntryDetails.FolderPath,
                };

                var uploadedResult = await _attachmentService.UploadFiles(fileCommand, request.SessionData, true);
                if (uploadedResult == null)
                {
                    var result = new List<SP_INSERT_ADJUSTMENT>(){
                        new SP_INSERT_ADJUSTMENT{
                            ResponseCode = "500",
                            ResponseMessage = "Error while uploading Adjustment Entries file in blob",
                        }
                    };
                    return Result.SuccessWith<List<SP_INSERT_ADJUSTMENT>>(result);
                }
                //Get Account code

                var adjustmentEntryData = ReadExcelFile(request, uploadedResult, Contants.Adjustment_upload_sheetname);
                if (adjustmentEntryData == null)
                {
                    var result = new List<SP_INSERT_ADJUSTMENT>(){
                        new SP_INSERT_ADJUSTMENT{
                            ResponseCode = "500",
                            ResponseMessage = "Error while uploading Adjustment Entries file in blob",
                        }
                    };
                    return Result.SuccessWith<List<SP_INSERT_ADJUSTMENT>>(result);
                }
                if (adjustmentEntryData.ResponseList.Count > 0)
                {
                    return Result.SuccessWith<List<SP_INSERT_ADJUSTMENT>>(adjustmentEntryData.ResponseList);
                }

                //Need to do changes after disussion
                // bool isValidMonth = ValidateMonth(adjustmentEntryData, psiDateData);


                return PrepareAndSavAdjustmentEntry(adjustmentEntryData, request, uploadedResult);

            }
            catch (Exception ex)
            {

                Log.Error($"Error in uploading/reading file with Message - {ex.Message}. StackTrace - {ex.StackTrace}");
                var result = new List<SP_INSERT_ADJUSTMENT>(){
                        new SP_INSERT_ADJUSTMENT{
                            ResponseCode = "500",
                            ResponseMessage = Contants.ERROR_MSG,
                        }
                    };
                return Result.SuccessWith<List<SP_INSERT_ADJUSTMENT>>(result);
            }

        }

        private AdjustmentEntryData ReadExcelFile(AdjustmentEntryUploadCommand command, FileUploadResult fileData, string sheetName)
        {
            string fileName;
            var file = command.AdjustmentEntryDetails.File;
            fileName = Guid.NewGuid() + Path.GetExtension(file.FileName);
            var adjustmentsheetData = new AdjustmentEntryData();
            try
            {
                if (file != null)
                {

                    var fileExt = Path.GetExtension(file.FileName);
                    MemoryStream fs = new MemoryStream(fileData.FileBytes);
                    IWorkbook workbook = null;
                    var sheetNames = new List<string>();
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

                        for (int i = 0; i < workbook.NumberOfSheets; i++)
                        {
                            string name = workbook.GetSheetName(i).Trim().Replace(" ", "").ToUpper();

                            if (!string.IsNullOrEmpty(name))
                            {
                                sheetNames.Add(name);
                            }
                        }
                        var expectedSheetIndex = sheetNames.FindIndex(c => c == sheetName);
                        //Make changes for all sheet
                        if (expectedSheetIndex != -1)
                        {

                            currentWorksheet = workbook.GetSheetAt(expectedSheetIndex);
                            adjustmentsheetData = GetSheetData(currentWorksheet, fileData.Id, command.SessionData, command.AdjustmentEntryDetails);
                        }
                        else
                        {
                            adjustmentsheetData.ResponseList.Add(new SP_INSERT_ADJUSTMENT()
                            {
                                ResponseCode = "107",
                                ResponseMessage = "Invalid sheet name: Sheet name should be ADJ"
                            });

                        }
                    }
                }
            }
            catch (Exception ex)
            {

                throw;

            }

            return adjustmentsheetData;
        }

        public AdjustmentEntryData GetSheetData(ISheet excelSheet, int AttachmentID, SessionData sessionData, AdjustmentEntryDetails adjustmenEntryDetails)
        {
            AdjustmentEntryData objadjustmentEntryData = new AdjustmentEntryData();
            List<AdjustmentEntryQty> lstEntryQty = new List<AdjustmentEntryQty>();
            List<AdjustmentEntryPrice> lstEntryPrice = new List<AdjustmentEntryPrice>();
            List<AdjustmentData> lstAdjustmentData = new List<AdjustmentData>();
            try
            {

                var lastRowIndexToRead = excelSheet.LastRowNum;

                #region Validate Header
                //Validate Sheet column Header
                int firstHeaderRowIndex = 0;
                int lastHeaderRowIndex = 3;

                string[] headerRow = new string[3];
                bool flagHeader = true;

                var currentHeaderRow = excelSheet.GetRow(firstHeaderRowIndex);
                ICell cellCusomerCode = currentHeaderRow.GetCell(0);
                var cellCusomerHeader = GetCellValue(cellCusomerCode);
                headerRow[0] = Convert.ToString(cellCusomerHeader);

                ICell cellHeaderType = currentHeaderRow.GetCell(1);
                var cellCustTypeHeader = GetCellValue(cellHeaderType);
                headerRow[1] = Convert.ToString(cellCustTypeHeader);

                ICell cellMaterialIDHeader = currentHeaderRow.GetCell(2);
                var cellMaterialIDHeaer = GetCellValue(cellMaterialIDHeader);
                headerRow[2] = Convert.ToString(cellMaterialIDHeaer);

                if (Convert.ToString(headerRow[0]) != Contants.Adjustment_Header_Customer)
                {
                    flagHeader = false;
                    objadjustmentEntryData.ResponseList.Add(new SP_INSERT_ADJUSTMENT
                    {
                        ResponseCode = "111",
                        ResponseMessage = $"RowNo: {firstHeaderRowIndex + 1} : Cell:0.  Invalid column name. It should be CustomerCode"
                    });
                }
                if (Convert.ToString(headerRow[1]) != Contants.Adjustment_Header_Type)
                {
                    flagHeader = false;
                    objadjustmentEntryData.ResponseList.Add(new SP_INSERT_ADJUSTMENT
                    {
                        ResponseCode = "111",
                        ResponseMessage = $"RowNo: {firstHeaderRowIndex + 1}  : Cell:1.  Invalid column name. It should be TYPE"
                    });
                }
                if (Convert.ToString(headerRow[2]) != Contants.Adjustment_Header_MaterialCode)
                {
                    flagHeader = false;
                    objadjustmentEntryData.ResponseList.Add(new SP_INSERT_ADJUSTMENT
                    {
                        ResponseCode = "111",
                        ResponseMessage = $"RowNo: {firstHeaderRowIndex + 1}  : Cell:2.  Invalid column name. It should be Model No."
                    });
                }

                //Validate Qty Header
                int startQtyCell = 3;
                int lastQtyCell = 20;
                int TotalQtyColum = 0;
                int startPriceCell = 3;
                int endPriceCell = 20;
                int TotalPriceColumn = 0;
                var currentQtyPriceHeaderRow = excelSheet.GetRow(firstHeaderRowIndex);
                //Qty Header
                for (int qtyHeader = startQtyCell; qtyHeader <= lastQtyCell; qtyHeader++)
                {
                    ICell cellQty = currentHeaderRow.GetCell(qtyHeader);
                    var cellQtyHeader = GetCellValue(cellQty);

                    string[] arrQty = cellQtyHeader.Split('-');
                    if (arrQty.Length == 3)
                    {

                        string monthYeaResult = ConvertQtyMonthName(arrQty[0], arrQty[1]);
                        if (string.IsNullOrEmpty(monthYeaResult))
                        {
                            flagHeader = false;
                            //Month is not a proper format
                            objadjustmentEntryData.ResponseList.Add(new SP_INSERT_ADJUSTMENT
                            {
                                ResponseCode = "107",
                                ResponseMessage = $"RowNo: {firstHeaderRowIndex + 1} and CellNo :{qtyHeader}  Month and Year is not valid"
                            });

                        }
                        else if (arrQty[2].ToLower() != "f")
                        {
                            flagHeader = false;
                            objadjustmentEntryData.ResponseList.Add(new SP_INSERT_ADJUSTMENT
                            {
                                ResponseCode = "107",
                                ResponseMessage = $"RowNo: {firstHeaderRowIndex + 1} and CellNo :{qtyHeader}  Month is not valid"
                            });
                        }
                        else
                        {
                            TotalQtyColum = TotalQtyColum + 1;
                        }
                    }
                    else
                    {
                        flagHeader = false;
                        objadjustmentEntryData.ResponseList.Add(new SP_INSERT_ADJUSTMENT
                        {
                            ResponseCode = "107",
                            ResponseMessage = $"RowNo: {firstHeaderRowIndex + 1} and CellNo :{qtyHeader}  Month is not valid"
                        });

                    }
                }

                // Retrun if colum less or max (14+1)
                if (TotalQtyColum > Contants.Adjustment_Qty_Price_column_match || TotalQtyColum < Contants.Adjustment_Qty_Price_column_match)
                {
                    flagHeader = false;
                    objadjustmentEntryData.ResponseList.Add(new SP_INSERT_ADJUSTMENT
                    {
                        ResponseCode = "107",
                        ResponseMessage = $"Qty colum is more/less as expected"
                    });

                }
                #endregion


                if (flagHeader)
                {
                    int firstRowIndex = 1;
                    int priceQtyRowHeaderRow = 0;
                    for (int row = firstRowIndex; row <= lastRowIndexToRead; row++)
                    {
                        if (excelSheet.GetRow(row) != null) //null is when the row only contains empty cells 
                        {
                            var currentRow = excelSheet.GetRow(row);
                            ICell cellCusomerID = currentRow.GetCell(0);
                            var cellCusomerIDalue = GetCellValue(cellCusomerID);
                            ICell cellType = currentRow.GetCell(1);
                            var cellTypeValue = GetCellValue(cellType);
                            ICell cellMaterialID = currentRow.GetCell(2);
                            var cellMaterialIDVaue = GetCellValue(cellMaterialID);



                            if (string.IsNullOrEmpty(cellCusomerIDalue))
                            {
                                objadjustmentEntryData.ResponseList.Add(new SP_INSERT_ADJUSTMENT
                                {
                                    ResponseCode = "107",
                                    ResponseMessage = $"RowNo: {row + 1}   CustomerCode is empty"
                                });

                            }
                            if (string.IsNullOrEmpty(cellTypeValue))
                            {
                                objadjustmentEntryData.ResponseList.Add(new SP_INSERT_ADJUSTMENT
                                {
                                    ResponseCode = "107",
                                    ResponseMessage = $"RowNo: {row + 1}   Type is empty"
                                });

                            }
                            if (string.IsNullOrEmpty(cellMaterialIDVaue))
                            {
                                objadjustmentEntryData.ResponseList.Add(new SP_INSERT_ADJUSTMENT
                                {
                                    ResponseCode = "107",
                                    ResponseMessage = $"RowNo: {row + 1}   MaterialCode is empty"
                                });

                            }

                            if ((!string.IsNullOrEmpty(cellCusomerIDalue)) && (!string.IsNullOrEmpty(cellMaterialIDVaue)) && (!string.IsNullOrEmpty(cellTypeValue)))
                            {
                                var ExcellstAdjustmentData = lstAdjustmentData.Where(x => x.MaterialCode == cellMaterialIDVaue && x.CustomerCode == cellCusomerIDalue && x.Type == cellTypeValue).FirstOrDefault();
                                if (ExcellstAdjustmentData != null)
                                {
                                    objadjustmentEntryData.ResponseList.Add(new SP_INSERT_ADJUSTMENT
                                    {
                                        ResponseCode = "107",
                                        ResponseMessage = $"RowNo: {row + 1}   Duplicate entry found in excel"
                                    });
                                }
                                var ExcellstAdjustmentDataCheck = lstAdjustmentData.Where(x => x.MaterialCode == cellMaterialIDVaue && x.CustomerCode == cellCusomerIDalue).LastOrDefault();
                                priceQtyRowHeaderRow = 0;
                                var PrevRow = excelSheet.GetRow(priceQtyRowHeaderRow);
                                if (ExcellstAdjustmentDataCheck == null)
                                {
                                    lstAdjustmentData.Add(new AdjustmentData()
                                    {
                                        CustomerCode = cellCusomerIDalue,
                                        Type = cellTypeValue,
                                        MaterialCode = cellMaterialIDVaue,
                                        AttachmentID = AttachmentID,
                                        RowNum = row + 1
                                    });
                                    if (cellTypeValue == "QTY")
                                    {
                                        for (int i = startQtyCell; i <= lastQtyCell; i++)
                                        {
                                            AdjustmentEntryQty ObjsNSEntryQty = new AdjustmentEntryQty();


                                            ICell cellMonthly = PrevRow.GetCell(i);
                                            var cellMonthlyDalue = GetCellValue(cellMonthly);
                                            string[] monthQty = cellMonthlyDalue.Split("-");
                                            string monthYeaResult = monthQty.Length > 1 ? ConvertQtyMonthName(monthQty[0], monthQty[1]) : null;

                                            ICell cellMonthlyValue = currentRow.GetCell(i);
                                            var cellMonthlyQty = GetCellValue(cellMonthlyValue);
                                            int Qty = 0;
                                            if (!string.IsNullOrEmpty(cellMonthlyQty))
                                            {
                                                lstEntryQty.Add(new AdjustmentEntryQty()
                                                {
                                                    MonthYear = monthYeaResult,
                                                    Qty = cellMonthlyQty,
                                                    RowNum = row + 1

                                                });
                                            }
                                            else
                                            {
                                                lstEntryQty.Add(new AdjustmentEntryQty()
                                                {
                                                    MonthYear = monthYeaResult,
                                                    Qty = "0",
                                                    RowNum = row + 1

                                                });

                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    if (cellTypeValue == "VAL")
                                    {
                                        for (int j = startPriceCell; j <= endPriceCell; j++)
                                        {
                                            AdjustmentEntryPrice objAdjustmentEntryPrice = new AdjustmentEntryPrice();
                                            ICell cellMonthly = PrevRow.GetCell(j);
                                            var cellMonthlyDalue = GetCellValue(cellMonthly);
                                            string[] monthPrice = cellMonthlyDalue.Split("-");
                                            string monthYeaResult = monthPrice.Length > 1 ? ConvertQtyMonthName(monthPrice[0], monthPrice[1]) : null;
                                            ICell cellMonthlyValue = currentRow.GetCell(j);
                                            var cellMonthlyPrice = GetCellValue(cellMonthlyValue);
                                            if (!string.IsNullOrEmpty(cellMonthlyPrice))
                                            {
                                                lstEntryPrice.Add(new AdjustmentEntryPrice()
                                                {
                                                    MonthYear = monthYeaResult,
                                                    Price = cellMonthlyPrice,
                                                    RowNum = row 

                                                });
                                            }
                                            else
                                            {
                                                lstEntryPrice.Add(new AdjustmentEntryPrice()
                                                {
                                                    MonthYear = monthYeaResult,
                                                    Price = "0",
                                                    RowNum = row 

                                                });
                                            }
                                        }

                                    }
                                }
                            }
                        }
                    }
                    objadjustmentEntryData.AdjustmentData = lstAdjustmentData;
                    objadjustmentEntryData.AdjustmentEntryQty = lstEntryQty;
                    objadjustmentEntryData.AdjustmentEntryPrice = lstEntryPrice;
                }
            }
            catch(Exception ex)
            {
                throw;
            }

            return objadjustmentEntryData;
        }

        /// <summary>
        /// Convert Date format as per PSI Dates formats
        /// </summary>
        /// <param name="monthName"></param>
        /// <returns></returns>
        private string ConvertQtyMonthName(string monthName, string yearName)
        {
            string result = "";

            if (!string.IsNullOrEmpty(monthName) && !string.IsNullOrEmpty(yearName))
            {
                //var rx = new Regex(@"[A-z]{3}\s\d{4}", RegexOptions.IgnoreCase);

                //if (rx.IsMatch(monthName))
                //{
                var yr = "20" + yearName;
                DateTime dt;
                bool isValidDate = DateTime.TryParseExact("01" + monthName + yr, "ddMMMyyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt);
                if (isValidDate)
                {
                    result = dt.ToString("yyyyMM");
                }
                //}
            }
            return result;
        }

        private string GetCellValue(ICell cell)
        {
            string value = string.Empty;
            if (cell != null)
            {
                dynamic cellValue;
                switch (cell.CellType)
                {
                    case CellType.Numeric:
                        cellValue = cell.NumericCellValue;
                        value = cellValue != null ? cellValue.ToString() : "";
                        break;
                    case CellType.String:
                        cellValue = cell.StringCellValue;
                        value = cellValue != null ? cellValue.ToString() : "";
                        break;
                    case CellType.Boolean:
                        cellValue = cell.BooleanCellValue;
                        value = cellValue != null ? cellValue.ToString() : "";
                        break;
                    //in case if the cell has any formula , then we need to get its result
                    case CellType.Formula:
                        {
                            var cellFormularReturnType = cell.CachedFormulaResultType;
                            switch (cellFormularReturnType)
                            {
                                case CellType.Numeric:
                                    cellValue = cell.NumericCellValue;
                                    value = cellValue != null ? cellValue.ToString() : "0";
                                    break;
                                case CellType.Boolean:
                                    cellValue = cell.BooleanCellValue;
                                    value = cellValue != null ? cellValue.ToString() : "false";
                                    break;
                                default:
                                    cellValue = cell.StringCellValue;
                                    value = cellValue != null ? cellValue.ToString() : "";
                                    break;
                            }
                        }
                        break;
                    default:
                        value = cell != null ? cell.ToString() : "";
                        break;
                }
            }
            return value;

        }


        private Result PrepareAndSavAdjustmentEntry(AdjustmentEntryData adjustmentEntryData, AdjustmentEntryUploadCommand command, FileUploadResult uploadedResult)
        {
            try
            {
                if (adjustmentEntryData != null)
                {
                    var dtAdjustmentDate = new DataTable();
                    dtAdjustmentDate.Columns.Add(new DataColumn("CustomerCode", typeof(string)));
                    dtAdjustmentDate.Columns.Add(new DataColumn("MaterialCode", typeof(string)));
                    dtAdjustmentDate.Columns.Add(new DataColumn("AttachmentID", typeof(int)));
                    dtAdjustmentDate.Columns.Add(new DataColumn("RowNum", typeof(int)));

                    var dtAdjustmentQtyInfo = new DataTable();
                    dtAdjustmentQtyInfo.Columns.Add(new DataColumn("RowNum", typeof(int)));
                    dtAdjustmentQtyInfo.Columns.Add(new DataColumn("MonthYear", typeof(string)));
                    dtAdjustmentQtyInfo.Columns.Add(new DataColumn("Qty", typeof(string)));

                    var dtAdjustmentPriceInfo = new DataTable();
                    dtAdjustmentPriceInfo.Columns.Add(new DataColumn("RowNum", typeof(int)));
                    dtAdjustmentPriceInfo.Columns.Add(new DataColumn("MonthYear", typeof(string)));
                    dtAdjustmentPriceInfo.Columns.Add(new DataColumn("Price", typeof(string)));

                    foreach (var row in adjustmentEntryData.AdjustmentData)
                    {
                        dtAdjustmentDate.Rows.Add(
                            row.CustomerCode,
                            row.MaterialCode,
                               row.AttachmentID,
                            row.RowNum
                           );
                    }
                    foreach (var row in adjustmentEntryData.AdjustmentEntryQty)
                    {
                        dtAdjustmentQtyInfo.Rows.Add(row.RowNum, row.MonthYear, row.Qty);
                    }
                    foreach (var row in adjustmentEntryData.AdjustmentEntryPrice)
                    {
                        dtAdjustmentPriceInfo.Rows.Add(row.RowNum, row.MonthYear, row.Price);
                    }
                    bool isSupeAdmin = command.SessionData.Roles.Contains(Contants.ADMIN_ROLE);
                    return SaveAdjustment(command, uploadedResult, dtAdjustmentDate, dtAdjustmentQtyInfo, dtAdjustmentPriceInfo, adjustmentEntryData.ResponseList, isSupeAdmin);
                }
                else
                {
                    var result = new List<SP_InsertSalesEntries>(){
                        new SP_InsertSalesEntries{
                            ResponseCode = "500",
                            ResponseMessage = "No Valid Data To Process",
                        }
                    };
                    return Result.SuccessWith<List<SP_InsertSalesEntries>>(result);
                }
            }
            catch (Exception)
            {
                throw;
            }
        }


        /// <summary>
        /// Save the Direct Sales Excel information to DB
        /// </summary>
        /// <param name="command"></param>
        /// <param name="uploadedResult"></param>
        /// <param name="dtSalesEntries"></param>
        /// <param name="dtSalesQtyInfos"></param>
        /// <param name="dtSalesPriceInfos"></param>
        /// <returns></returns>
        private Result SaveAdjustment(AdjustmentEntryUploadCommand command, FileUploadResult uploadedResult, DataTable dtadjustmentEntry, DataTable dtadjustmentEntryQtyInfo, DataTable dtadjustmentEntryPriceInfo, List<SP_INSERT_ADJUSTMENT> responseList,bool isAdmin)
        {
            try
            {

                var adjustmentEntry = new SqlParameter("@tvpAdjustmentEntries", SqlDbType.Structured);
                adjustmentEntry.Value = dtadjustmentEntry;
                adjustmentEntry.TypeName = "dbo.TVP_Adjustment_ENTRIES";

                var qtyInfo = new SqlParameter("@tvpAdjustmentQuantities", SqlDbType.Structured);
                qtyInfo.Value = dtadjustmentEntryQtyInfo;
                qtyInfo.TypeName = "dbo.TVP_Adjustment_QTY_INFO";

                var priceInfo = new SqlParameter("@tvpAdjustmentPrice", SqlDbType.Structured);
                priceInfo.Value = dtadjustmentEntryPriceInfo;
                priceInfo.TypeName = "dbo.TVP_Adjustment_PRICE_INFO";

                var userId = new SqlParameter("@userId", SqlDbType.NVarChar, 100);
                userId.Value = command.SessionData.ADUserId ?? string.Empty;

                var isAdminParam = new SqlParameter("@IsAdmin", SqlDbType.Bit);
                isAdminParam.Value = isAdmin;

                var param = new SqlParameter[] {
                    //customerId,
                    adjustmentEntry,
                    qtyInfo,
                    priceInfo,
                    userId,
                    isAdminParam
                    };

                var result = _context.SP_INSERT_ADJUSTMENT.FromSqlRaw("dbo.SP_INSERT_ADJUSTMENT @tvpAdjustmentEntries, @tvpAdjustmentPrice, @tvpAdjustmentQuantities, @userId,@IsAdmin", param).AsNoTracking().ToList();
                if (result != null && result.ToList().Any())
                {
                    var spResult = result.ToList().Where(r => r.ResponseCode != "200");
                    responseList.AddRange(spResult);
                    if (responseList.Any())
                    {
                        return Result.SuccessWith<List<SP_INSERT_ADJUSTMENT>>(responseList);
                    }
                    else
                    {
                        var successRespone = result.Where(r => r.ResponseCode == "200").ToList();
                        if (successRespone.Count() > 0)
                        {
                            Task.Run(() => _attachmentService.ActivateFile(uploadedResult.Id));
                            return Result.SuccessWith<List<SP_INSERT_ADJUSTMENT>>(successRespone);
                        }
                        else
                        {
                            var errorResult = new List<SP_INSERT_ADJUSTMENT>(){
                                new SP_INSERT_ADJUSTMENT{
                                    ResponseCode = "500",
                                    ResponseMessage = Contants.ERROR_MSG,
                                }
                            };
                            return Result.SuccessWith<List<SP_INSERT_ADJUSTMENT>>(errorResult);
                        }
                    }
                }
                else
                {
                    var errorResult = new List<SP_INSERT_ADJUSTMENT>(){
                        new SP_INSERT_ADJUSTMENT{
                            ResponseCode = "500",
                            ResponseMessage = Contants.ERROR_MSG,
                        }
                    };
                    return Result.SuccessWith<List<SP_INSERT_ADJUSTMENT>>(errorResult);
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        private bool IsNumber(string number)
        {
            bool flag = false;
            Regex nonNumericRegex = new Regex(@"\D");
            if (nonNumericRegex.IsMatch(number))
            {
                //Contains non numeric characters.
                flag = true;
            }
            return flag;

        }

        private bool ValidateMonth(AdjustmentEntryData adjustmentEntryData, GlobalConfig psiDateData)
        {
            //int  lst = adjustmentEntryData.SNSEntryQty.First().RowNum;

            var startMonthYear = GetDateFromMonthYear(psiDateData.ConfigValue + "01");
            if (!startMonthYear.HasValue)
            {

                adjustmentEntryData.ResponseList.Add(new SP_INSERT_ADJUSTMENT
                {
                    ResponseCode = "111",
                    ResponseMessage = "PSI Year is not valid"
                });
            }

            //foreach (var item in adjustmentEntryData.SNSEntryQty.Where(c => c.RowNum== firstRowIndex))
            //{
            //    var dateMonthYear = GetDateFromMonthYear(Convert.ToString(item.MonthYear));
            //    if (dateMonthYear != null)
            //    {
            //        string PSIYear = dateMonthYear.Value.Year.ToString();
            //        if (PSIYear != psiDateData.ConfigValue)
            //        {
            //            adjustmentEntryData.ResponseList.Add(new SP_INSERT_ADJUSTMENT
            //            {

            //                ResponseCode = "111",
            //                ResponseMessage = $"RowNo: {item.RowNum + 1}     {item.MonthYear} Month is not valid PSI Year for Qty."

            //            });

            //        }


            //    }
            //    else
            //    {

            //        adjustmentEntryData.ResponseList.Add(new SP_INSERT_ADJUSTMENT
            //        {

            //            ResponseCode = "111",
            //            ResponseMessage = $"RowNo: {item.RowNum + 1}     {item.MonthYear} Month is not valid for Qty"

            //        });
            //    }
            //    monthCount++;
            //}

            //monthCount = 0;
            //foreach (var item in adjustmentEntryData.SNSEntryPrice.Where(c => c.RowNum == firstRowIndex))
            //{
            //    var dateMonthYear = GetDateFromMonthYear(Convert.ToString(item.MonthYear));
            //    if (dateMonthYear != null)
            //    {
            //        string PSIYear = dateMonthYear.Value.Year.ToString();
            //        if (PSIYear != psiDateData.ConfigValue)
            //        {
            //            adjustmentEntryData.ResponseList.Add(new SP_INSERT_ADJUSTMENT
            //            {

            //                ResponseCode = "111",
            //                ResponseMessage = $"RowNo: {item.RowNum + 1}     {item.MonthYear} Month is not valid PSI Year for Price."

            //            });

            //        }
            //    }
            //    else
            //    {

            //        adjustmentEntryData.ResponseList.Add(new SP_INSERT_ADJUSTMENT
            //        {

            //            ResponseCode = "111",
            //            ResponseMessage = $"RowNo: {item.RowNum + 1}     {item.MonthYear} Month is not valid for Price"

            //        });
            //    }
            //    monthCount++;
            //}

            return true;
        }

        /// <summary>
        /// Get Date From MonthYear
        /// </summary>
        /// <param name="dateValue"></param>
        /// <returns></returns>
        private DateTime? GetDateFromMonthYear(string dateValue)
        {
            DateTime dt;
            if (!string.IsNullOrEmpty(dateValue))
            {
                Regex rgMonth = new Regex(@"^\d{6}$");
                if (rgMonth.IsMatch(dateValue))
                {
                    var isValid = DateTime.TryParseExact(dateValue + "01", "yyyyMMdd", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt);
                    if (isValid)
                    {
                        return dt;
                    }
                }
            }
            return null;
        }

        /// <summary>
        /// Get MonthYear From Date
        /// </summary>
        /// <param name="dateValue"></param>
        /// <returns></returns>
        private string GetMonthYearFromDate(DateTime dateValue)
        {
            return dateValue.ToString("yyyyMM");
        }
    }
}

