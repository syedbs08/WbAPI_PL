using AttachmentService;
using AttachmentService.Command;
using AttachmentService.Result;
using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Constants;
using PSI.Modules.Backends.Masters.Repository.AccountMaster;
using PSI.Modules.Backends.Masters.Repository.CustomerMaster;
using PSI.Modules.Backends.Masters.Repository.GlobalConfigMaster;
using PSI.Modules.Backends.Masters.Repository.MaterialMaster;
using PSI.Modules.Backends.Masters.Repository.ProductCategoryMaster;
using PSI.Modules.Backends.COG.Command;
using PSI.Modules.Backends.COG.Repository;
using System.Data;
using System.Globalization;
using System.Text.RegularExpressions;
using static PSI.Modules.Backends.Constants.Contants;
using NPOI.SS.Formula.Functions;
using SQLitePCL;
using Microsoft.AspNetCore.Components.Web;
using System;
using System.Collections.Generic;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Graph;
using System.Net;

namespace PSI.Modules.Backends.COG.CommandHandler
{
    public class COGImportHandler : IRequestHandler<COGEntryUploadCommand, Result>
    {
        private readonly PSIDbContext _context;
        private readonly IAttachmentService _attachmentService;
        private readonly IGlobalConfigRepository _globalConfigRepository;


        public COGImportHandler(IAttachmentService attachmentService,
            IGlobalConfigRepository globalConfigRepository)
        {
            _attachmentService = attachmentService;
            _globalConfigRepository = globalConfigRepository;
            _context = new PSIDbContext();
        }

        public async Task<Result> Handle(COGEntryUploadCommand request, CancellationToken cancellationToken)
        {
            try
            {
                var psiDateData = _globalConfigRepository.GetAll().FirstOrDefault(c => c.ConfigKey == Contants.global_config_psi_year_key);
                if (psiDateData == null)
                {
                    var result = new List<SP_InsertCOGEntryDetails>(){
                        new SP_InsertCOGEntryDetails{
                           ResponseCode = "107",
                           ResponseMessage = $"PSI Year is not available in the configuration."
                        }
                    };
                    return Result.SuccessWith<List<SP_InsertCOGEntryDetails>>(result);
                }

                FileCommand fileCommand = new FileCommand
                {
                    File = request?.COGEntryDetails.File,
                    FileTypeId = request.COGEntryDetails.FileTypeId,
                    FolderPath = request.COGEntryDetails.FolderPath,
                };

                var uploadedResult = await _attachmentService.UploadFiles(fileCommand, request.SessionData, true);
                if (uploadedResult == null)
                {
                    var result = new List<SP_InsertCOGEntryDetails>(){
                        new SP_InsertCOGEntryDetails{
                            ResponseCode = "500",
                            ResponseMessage = "Error while uploading COG Entries file in blob",
                        }
                    };
                    return Result.SuccessWith<List<SP_InsertCOGEntryDetails>>(result);
                }
                string sheetName = Contants.COG_Sheet_Name;
                var COGEntryData = ReadExcelFile(request, uploadedResult, sheetName);
                if (COGEntryData == null)
                {
                    var result = new List<SP_InsertCOGEntryDetails>(){
                        new SP_InsertCOGEntryDetails{
                            ResponseCode = "500",
                            ResponseMessage = "Error while uploading COG Entries file in blob",
                        }
                    };
                    return Result.SuccessWith<List<SP_InsertCOGEntryDetails>>(result);
                }
                if (COGEntryData.ResponseList.Count > 0)
                {
                    return Result.SuccessWith<List<SP_InsertCOGEntryDetails>>(COGEntryData.ResponseList);
                }
                COGEntryData.AttachmentID = uploadedResult.Id;
                COGEntryData.SaleTypeId = request.COGEntryDetails.SaleTypeId;
                COGEntryData.SaleSubType = request.COGEntryDetails.SaleSubType;
                return PrepareAndSaveCOGEntry(COGEntryData, request);
            }
            catch (Exception ex)
            {

                Core.BaseUtility.Utility.Log.Error($"Error in uploading/reading file with Message - {ex.Message}. StackTrace - {ex.StackTrace}");
                var result = new List<SP_InsertCOGEntryDetails>(){
                        new SP_InsertCOGEntryDetails{
                            ResponseCode = "500",
                            ResponseMessage = Contants.ERROR_MSG,
                        }
                    };
                return Result.SuccessWith<List<SP_InsertCOGEntryDetails>>(result);
            }

        }

        #region Excel Read

        private COGEntryData ReadExcelFile(COGEntryUploadCommand command, FileUploadResult fileData, string sheetName)
        {
            string fileName;
            var file = command.COGEntryDetails.File;
            fileName = Guid.NewGuid() + Path.GetExtension(file.FileName);
            var COGDheetData = new COGEntryData();
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
                            COGDheetData = GetSheetData(currentWorksheet, command.SessionData, command.COGEntryDetails);
                            COGDheetData.AttachmentID = fileData.Id;
                        }
                        else
                        {
                            COGDheetData.ResponseList.Add(new SP_InsertCOGEntryDetails()
                            {
                                ResponseCode = "107",
                                ResponseMessage = "Invalid sheet name: Sheet name should be FOB"
                            });
                        }
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }

            return COGDheetData;
        }

        public COGEntryData GetSheetData(ISheet excelSheet, SessionData sessionData, COGEntryDetails cogEntryDetails)
        {
            COGEntryData objCOGEntryData = new COGEntryData();
            List<COGEntryPrice> lstEntryPrice = new List<COGEntryPrice>();
            List<COGData> lstCOGData = new List<COGData>();
            try
            {
                int custInfoHeaderRowIndex = 0;
                int priceInfoHeaderRowIndex = 1;
                int priceInfoStartColIndex = Contants.COG_PriceInfo_Start_ColIndex;
                int priceInfoEndColIndex = Contants.COG_PriceInfo_End_ColIndex;
                bool isHeaderValid = true;
                ValidateCustInfoHeaderRow(excelSheet, custInfoHeaderRowIndex, ref isHeaderValid, ref objCOGEntryData);
                ValidatePriceHeaderRow(excelSheet, priceInfoHeaderRowIndex, ref isHeaderValid, ref objCOGEntryData);

                if (isHeaderValid)
                {
                    int firstRowIndex = Contants.COG_First_DataRow_Index;
                    var PriceInfoHeaderRow = excelSheet.GetRow(priceInfoHeaderRowIndex);
                    for (int rowIndex = firstRowIndex; rowIndex <= excelSheet.LastRowNum; rowIndex++)
                    {
                        var currentRow = excelSheet.GetRow(rowIndex);

                        if (currentRow != null) //null is when the row only contains empty cells 
                        {
                            //all cells are empty, so is a 'blank row'
                            if (currentRow.Cells.All(d => d.CellType == CellType.Blank)) continue;

                            var cellCusomerIDValue = GetCellValue(currentRow.GetCell(0));
                            var cellCustNameValue = GetCellValue(currentRow.GetCell(1));
                            var cellMaterialIDVaue = GetCellValue(currentRow.GetCell(2));

                            ValidateEmptyCellValue(cellCusomerIDValue, "CustomerCode", rowIndex, ref objCOGEntryData);
                            ValidateEmptyCellValue(cellCustNameValue, "CustomerName", rowIndex, ref objCOGEntryData);
                            ValidateEmptyCellValue(cellMaterialIDVaue, "ModelNo", rowIndex, ref objCOGEntryData);

                            if ((!string.IsNullOrEmpty(cellCusomerIDValue)) && (!string.IsNullOrEmpty(cellCustNameValue)) && (!string.IsNullOrEmpty(cellMaterialIDVaue)))
                            {
                                var recordExists = lstCOGData.Any(x => x.MaterialCode == cellMaterialIDVaue && x.CustomerCode == cellCusomerIDValue);
                                if (recordExists)
                                {
                                    objCOGEntryData.ResponseList.Add(new SP_InsertCOGEntryDetails
                                    {
                                        ResponseCode = "107",
                                        ResponseMessage = $"RowNo: {rowIndex + 1} Duplicate entry found in excel"
                                    });
                                }
                                lstCOGData.Add(new COGData()
                                {
                                    CustomerCode = cellCusomerIDValue,
                                    CustomerName = cellCustNameValue,
                                    MaterialCode = cellMaterialIDVaue,

                                    RowNum = rowIndex + 1
                                });
                            }

                            for (int j = priceInfoStartColIndex; j <= priceInfoEndColIndex; j++)
                            {
                                COGEntryPrice objCOGEntryPrice = new COGEntryPrice();
                                string[] dateValue = GetCellValue(PriceInfoHeaderRow.GetCell(j)).Split("-");
                                string monthYearResult = ConvertToPSIDate(dateValue[0], dateValue[1]);
                                string chargeType = dateValue[2];

                                var cellMonthlyPrice = GetCellValue(currentRow.GetCell(j));
                                if (!string.IsNullOrEmpty(cellMonthlyPrice))
                                {
                                    decimal priceValue = 0;
                                    var isValid = Decimal.TryParse(cellMonthlyPrice, out priceValue);
                                    if (!isValid)
                                    {
                                        objCOGEntryData.ResponseList.Add(new SP_InsertCOGEntryDetails
                                        {
                                            ResponseCode = "107",
                                            ResponseMessage = $"RowNo: {rowIndex + 1} and CellNo :{j} has invalid character. It should be decimal or numeric"
                                        });
                                    }
                                    else
                                    {
                                        if (Convert.ToDecimal(cellMonthlyPrice) < 0)
                                        {
                                            objCOGEntryData.ResponseList.Add(new SP_InsertCOGEntryDetails
                                            {
                                                ResponseCode = "108",
                                                ResponseMessage = $"RowNo: {rowIndex + 1} and CellNo :{j}  has negative value"
                                            });
                                        }
                                        else
                                        {

                                            lstEntryPrice.Add(new COGEntryPrice()
                                            {
                                                MonthYear = Convert.ToInt32(monthYearResult),
                                                Price = Convert.ToDecimal(cellMonthlyPrice),
                                                RowNum = rowIndex + 1,
                                                ChargeType = chargeType,
                                                Qty = 1
                                            });
                                        }
                                    }
                                }
                                else
                                {
                                    lstEntryPrice.Add(new COGEntryPrice()
                                    {
                                        MonthYear = Convert.ToInt32(monthYearResult),
                                        Price = 0,
                                        Qty = 0,
                                        ChargeType = chargeType,
                                        RowNum = rowIndex + 1
                                    });
                                }
                            }
                        }
                    }
                    objCOGEntryData.COGData = lstCOGData;
                    objCOGEntryData.COGEntryPrice = lstEntryPrice;
                }
            }
            catch
            {
                throw;
            }
            return objCOGEntryData;
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

        #endregion Excel Read

        #region Validations
        void ValidateEmptyCellValue(string? cellVal, string colName, int rowIndex, ref COGEntryData objCOGEntryData)
        {
            if (string.IsNullOrEmpty(cellVal))
            {
                objCOGEntryData.ResponseList.Add(new SP_InsertCOGEntryDetails
                {
                    ResponseCode = "107",
                    ResponseMessage = $"RowNo: {rowIndex + 1} {colName} is empty"
                });
            }
        }

        void ValidatePriceHeaderRow(ISheet excelSheet, int rowIndex, ref bool isHeaderValid, ref COGEntryData objCOGEntryData)
        {
            bool isValid = true;
            int totalPriceColumn = 0;
            int startPriceCellNum = 3;
            int endPriceCellNum = 56;
            var row = excelSheet.GetRow(rowIndex);
            for (int cellNum = startPriceCellNum; cellNum <= endPriceCellNum; cellNum++)
            {
                var cellDateHeader = GetCellValue(row.GetCell(cellNum));
                string[] headerCellValues = cellDateHeader.Split('-');
                if (headerCellValues.Length == 3)
                {
                    string monthYearValue = ConvertToPSIDate(headerCellValues[0], headerCellValues[1]);
                    if (string.IsNullOrEmpty(monthYearValue))
                    {
                        isValid = false;
                        objCOGEntryData.ResponseList.Add(new SP_InsertCOGEntryDetails
                        {
                            ResponseCode = "107",
                            ResponseMessage = $"RowNo: {rowIndex + 1} and CellNo :{cellNum} Date Format is invalid"
                        });
                    }
                    else if (!headerCellValues[2].ToLower().Equals(GetExpectedChargeType(cellNum)))
                    {
                        isValid = false;
                        objCOGEntryData.ResponseList.Add(new SP_InsertCOGEntryDetails
                        {
                            ResponseCode = "107",
                            ResponseMessage = $"RowNo: {rowIndex + 1} and CellNo :{cellNum} Charge Type is invalid"
                        });
                    }
                    else
                    {
                        totalPriceColumn++;
                    }
                }
                else
                {
                    isValid = false;
                    objCOGEntryData.ResponseList.Add(new SP_InsertCOGEntryDetails
                    {
                        ResponseCode = "107",
                        ResponseMessage = $"RowNo: {rowIndex + 1} and CellNo :{cellNum} Month Value is invalid"
                    });
                }
            }
            if (totalPriceColumn != Contants.COG_Price_column_match)
            {
                isValid = false;
                objCOGEntryData.ResponseList.Add(new SP_InsertCOGEntryDetails
                {
                    ResponseCode = "107",
                    ResponseMessage = $"Price column is more/less as expected"
                });
            }
            if (isHeaderValid)
            {
                isHeaderValid = isValid;
            }
        }


        void ValidateCustInfoHeaderRow(ISheet excelSheet, int rowIndex, ref bool isHeaderValid, ref COGEntryData objCOGEntryData)
        {
            bool isValid = true;
            var row = excelSheet.GetRow(rowIndex);
            string[] headerRow = new string[3];
            headerRow[0] = GetCellValue(row.GetCell(0));
            headerRow[1] = GetCellValue(row.GetCell(1));
            headerRow[2] = GetCellValue(row.GetCell(2));

            if (Convert.ToString(headerRow[0]) != Contants.COG_Header_Customer)
            {
                isValid = false;
                objCOGEntryData.ResponseList.Add(new SP_InsertCOGEntryDetails
                {
                    ResponseCode = "111",
                    ResponseMessage = $"RowNo: {rowIndex + 1} : Cell:0.  Invalid column name. It should be Customer"
                });
            }
            if (Convert.ToString(headerRow[1]) != Contants.COG_Header_CustomerName)
            {
                isValid = false;
                objCOGEntryData.ResponseList.Add(new SP_InsertCOGEntryDetails
                {
                    ResponseCode = "111",
                    ResponseMessage = $"RowNo: {rowIndex + 1}  : Cell:1.  Invalid column name. It should be Customer Name"
                });
            }
            if (Convert.ToString(headerRow[2]) != Contants.COG_Header_MaterialCode)
            {
                isValid = false;
                objCOGEntryData.ResponseList.Add(new SP_InsertCOGEntryDetails
                {
                    ResponseCode = "111",
                    ResponseMessage = $"RowNo: {rowIndex + 1}  : Cell:2.  Invalid column name. It should be Material Code"
                });
            }
            if (isHeaderValid)
            {
                isHeaderValid = isValid;
            }
        }

        private bool ValidateMonth(COGEntryData COGEntryData, GlobalConfig psiDateData)
        {

            var startMonthYear = GetDateFromMonthYear(psiDateData.ConfigValue + "01");
            if (!startMonthYear.HasValue)
            {

                COGEntryData.ResponseList.Add(new SP_InsertCOGEntryDetails
                {
                    ResponseCode = "111",
                    ResponseMessage = "PSI Year is not valid"
                });
            }

            return true;
        }


        #endregion Validations

        #region Dump to DB

        /// <summary>
        /// Datatables for SP call
        /// </summary>
        /// <param name="CogEntryData"></param>
        /// <param name="command"></param>
        /// <param name="uploadedResult"></param>
        /// <returns></returns>
        private Result PrepareAndSaveCOGEntry(COGEntryData CogEntryData, COGEntryUploadCommand command)
        {
            try
            {
                if (CogEntryData != null)
                {
                    #region DataTable Declarations
                    var dtCOGData = new DataTable();
                    dtCOGData.Columns.Add(new DataColumn("CustomerCode", typeof(string)));
                    dtCOGData.Columns.Add(new DataColumn("CustomerName", typeof(string)));
                    dtCOGData.Columns.Add(new DataColumn("MaterialCode", typeof(string)));
                    dtCOGData.Columns.Add(new DataColumn("RowNum", typeof(int)));

                    var dtCogQtyPriceInfo = new DataTable();
                    dtCogQtyPriceInfo.Columns.Add(new DataColumn("RowNum", typeof(int)));
                    dtCogQtyPriceInfo.Columns.Add(new DataColumn("MonthYear", typeof(string)));
                    dtCogQtyPriceInfo.Columns.Add(new DataColumn("Price", typeof(string)));
                    dtCogQtyPriceInfo.Columns.Add(new DataColumn("ChargeType", typeof(string)));
                    dtCogQtyPriceInfo.Columns.Add(new DataColumn("Qty", typeof(int)));
                    #endregion DataTable Declarations

                    #region Datatable Data Load
                    foreach (var row in CogEntryData.COGData)
                    {
                        dtCOGData.Rows.Add(
                            row.CustomerCode,
                            row.CustomerName,
                            row.MaterialCode,
                            row.RowNum
                           );
                    }
                    foreach (var row in CogEntryData.COGEntryPrice)
                    {
                        dtCogQtyPriceInfo.Rows.Add(row.RowNum, row.MonthYear, row.Price, row.ChargeType, row.Qty);
                    }
                    #endregion Datatable Data Load

                    bool isSupeAdmin = command.SessionData.Roles.Contains(Contants.ADMIN_ROLE);
                    return SaveCOG(command, CogEntryData.AttachmentID, CogEntryData.SaleTypeId, CogEntryData.SaleSubType, dtCOGData, dtCogQtyPriceInfo, CogEntryData.ResponseList, isSupeAdmin);
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
        /// Save the COG Excel information to DB
        /// </summary>
        /// <param name="command"></param>
        /// <param name="uploadedResult"></param>
        /// <param name="dtSalesEntries"></param>
        /// <param name="dtSalesQtyInfos"></param>
        /// <param name="dtSalesPriceInfos"></param>
        /// <returns></returns>
        private Result SaveCOG(COGEntryUploadCommand command, int attachmentId, int saleTypeId, string saleSubType, DataTable dtCogEntry, DataTable dtCogQtyPriceInfo, List<SP_InsertCOGEntryDetails> responseList, bool isAdmin)
        {
            try
            {
                var CogEntry = new SqlParameter("@tvpCOGEntries", SqlDbType.Structured);
                CogEntry.Value = dtCogEntry;
                CogEntry.TypeName = "dbo.TVP_COG_ENTRIES";

                var priceQtyInfo = new SqlParameter("@tvpCOGQtyPrice", SqlDbType.Structured);
                priceQtyInfo.Value = dtCogQtyPriceInfo;
                priceQtyInfo.TypeName = "dbo.TVP_COG_QTY_PRICE_INFO";

                var userIdParam = new SqlParameter("@UserId", SqlDbType.NVarChar, 100);
                userIdParam.Value = command.SessionData.ADUserId ?? string.Empty;

                var attachmentIdParam = new SqlParameter("@AttachmentId", SqlDbType.Int);
                attachmentIdParam.Value = attachmentId;

                var saleTypeIdParam = new SqlParameter("@SaleTypeId", SqlDbType.Int);
                saleTypeIdParam.Value = saleTypeId;

                var saleSubTypeParam = new SqlParameter("@SaleSubType", SqlDbType.NVarChar, 20);
                saleSubTypeParam.Value = saleSubType ?? string.Empty;

                var isAdminParam = new SqlParameter("@IsAdmin", SqlDbType.Bit);
                isAdminParam.Value = isAdmin;

                var param = new SqlParameter[] {
                    CogEntry,
                    priceQtyInfo,
                    userIdParam,
                    attachmentIdParam,
                    saleTypeIdParam,
                    saleSubTypeParam,
                    isAdminParam
                    };

                var result = _context.SP_InsertCOGEntryDetails.FromSqlRaw("dbo.SP_INSERT_COGENTRIES @tvpCOGEntries, @tvpCOGQtyPrice, @AttachmentId, @SaleTypeId, @SaleSubType, @UserId,@IsAdmin", param).AsNoTracking().ToList();
                if (result != null && result.ToList().Any())
                {
                    var spResult = result.ToList().Where(r => r.ResponseCode != "200");
                    responseList.AddRange(spResult);
                    if (responseList.Any())
                    {
                        return Result.SuccessWith<List<SP_InsertCOGEntryDetails>>(responseList);
                    }
                    else
                    {
                        var successRespone = result.Where(r => r.ResponseCode == "200").ToList();
                        if (successRespone.Count() > 0)
                        {
                            Task.Run(() => _attachmentService.ActivateFile(attachmentId));
                            return Result.SuccessWith<List<SP_InsertCOGEntryDetails>>(successRespone);
                        }
                        else
                        {
                            var errorResult = new List<SP_InsertCOGEntryDetails>(){
                                new SP_InsertCOGEntryDetails{
                                    ResponseCode = "500",
                                    ResponseMessage = Contants.ERROR_MSG,
                                }
                            };
                            return Result.SuccessWith<List<SP_InsertCOGEntryDetails>>(errorResult);
                        }
                    }
                }
                else
                {
                    var errorResult = new List<SP_InsertCOGEntryDetails>(){
                        new SP_InsertCOGEntryDetails{
                            ResponseCode = "500",
                            ResponseMessage = Contants.ERROR_MSG,
                        }
                    };
                    return Result.SuccessWith<List<SP_InsertCOGEntryDetails>>(errorResult);
                }
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        #endregion Dump to DB

        #region Common Functions

        /// <summary>
        /// Get expected charge type based on excel
        /// </summary>
        /// <param name="colIndex"></param>
        /// <returns></returns>
        static string GetExpectedChargeType(int colIndex)
        {
            return (colIndex >= 3 && colIndex <= 20) ? "frt" :
                   (colIndex >= 21 && colIndex <= 38) ? "cst" :
                   (colIndex >= 39 && colIndex <= 56) ? "fob" :
                   "";
        }

        /// <summary>
        /// Convert Date format as per PSI Dates formats
        /// </summary>
        /// <param name="monthName"></param>
        /// <returns></returns>
        private string ConvertToPSIDate(string monthName, string year)
        {
            string result = "";
            if (!string.IsNullOrEmpty(monthName) && !string.IsNullOrEmpty(year))
            {
                DateTime dt;
                bool isHeaderValidDate = DateTime.TryParseExact("01" + monthName + year, "ddMMMyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt);
                if (isHeaderValidDate)
                {
                    result = dt.ToString("yyyyMM");
                }
            }
            return result;
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
                    var isHeaderValid = DateTime.TryParseExact(dateValue + "01", "yyyyMMdd", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt);
                    if (isHeaderValid)
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
        #endregion Common Functions
    }
}
