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
using PSI.Modules.Backends.DirectSales.Command;
using PSI.Modules.Backends.DirectSales.Repository;
using PSI.Modules.Backends.Helpers;
using PSI.Modules.Backends.Masters.Repository.GlobalConfigMaster;
using PSI.Modules.Backends.Masters.Repository.MaterialMaster;
using PSI.Modules.Backends.Masters.Repository.ProductCategoryMaster;
using System.Data;
using System.Globalization;
using System.Text.RegularExpressions;

namespace PSI.Modules.Backends.DirectSales.CommandHandler
{
    public class DirectSalesImportHandler : IRequestHandler<DirectSalesCommand, Result>
    {
        private readonly IDirectSaleService _directSalesService;
        private readonly IAttachmentService _attachmentService;
        private readonly IDirectSalesRepository _directSalesRepository;
        private readonly IGlobalConfigRepository _globalConfigRepository;
        private readonly IMaterialRepository _materialRepository;
        private readonly IProductCategoryRepository _productCategoryRepository;
        private readonly PSIDbContext _context;
        public DirectSalesImportHandler(IDirectSaleService directSalesService,
            IAttachmentService attachmentService,
            IDirectSalesRepository directSalesRepository,
            IGlobalConfigRepository globalConfigRepository,
            IMaterialRepository materialRepository,
            IProductCategoryRepository productCategoryRepository)
        {
            _directSalesService = directSalesService;
            _attachmentService = attachmentService;
            _directSalesRepository = directSalesRepository;
            _globalConfigRepository = globalConfigRepository;
            _materialRepository = materialRepository;
            _productCategoryRepository = productCategoryRepository;
            _context = new PSIDbContext();
        }

        /// <summary>
        /// Handle Direct Sale Uploaded File
        /// </summary>
        /// <param name="request"></param>
        /// <param name="cancellationToken"></param>
        /// <returns></returns>
        public async Task<Result> Handle(DirectSalesCommand request, CancellationToken cancellationToken)
        {
            try
            {
                FileCommand fileCommand = new FileCommand
                {
                    File = request.DirectSale.File,
                    FileTypeId = request.DirectSale.FileTypeId,
                    FolderPath = request.DirectSale.FolderPath,
                };
                var uploadedResult = await _attachmentService.UploadFiles(fileCommand, request.SessionData, true);
                if (uploadedResult == null)
                {
                    return ReturnErrorResponse("500", "Error while uploading direct sales in blob.");
                }

                var customerWithLocalCurrency = GetCustomerWithCurrency(request.DirectSale.CustomerId);
                if (customerWithLocalCurrency == null)
                {
                    return ReturnErrorResponse("114", "Customer is not valid.");
                }
                if (customerWithLocalCurrency.CurrencyId == null)
                {
                    return ReturnErrorResponse("114", "Mapped country to currency.");
                }

                var productCategory = await _productCategoryRepository.GetById(request.DirectSale.ProductCategoryId);
                if (productCategory == null)
                {
                    return ReturnErrorResponse("115", "Product Category is not valid.");
                }
                var sheetName = "";
                if (request.DirectSale.ProductSubCategoryId != null)
                {
                    var producttype = await _productCategoryRepository.GetById((int)request.DirectSale.ProductSubCategoryId);
                    if (producttype == null)
                    {
                        return ReturnErrorResponse("115", "Product Type is not valid.");
                    }

                    sheetName = customerWithLocalCurrency.CustomerCode + "-" + productCategory.ProductCategoryCode + "-" + producttype.ProductCategoryCode;
                }
                else
                {
                    sheetName = customerWithLocalCurrency.CustomerCode + "-" + productCategory.ProductCategoryCode;
                }

                var saleEntryData = ReadExcelFile(request.DirectSale, uploadedResult, sheetName);
                if (saleEntryData == null)
                {
                    return ReturnErrorResponse("500", "Error while reading direct sales uploaded file.");
                }

                if (!saleEntryData.IsValidSheet)
                {
                    return ReturnErrorResponse("116", "The Customer and Category selection should same as sheet name.");
                }

                if (saleEntryData.SalesPriceInfos != null && saleEntryData.SalesPriceInfos.Count() == 0 ||
                saleEntryData.SalesQtyInfos != null && saleEntryData.SalesQtyInfos.Count() == 0)
                {
                    return ReturnErrorResponse("109", "Quantity and Price details are not available.");
                }
                GlobalConfig psiDateData = new GlobalConfig();
                if (request.DirectSale.SaleSubType == "BP")
                {
                    psiDateData = _globalConfigRepository.GetAll().FirstOrDefault(c => c.ConfigKey == Contants.global_config_BP_year_key);
                    if (psiDateData == null)
                    {
                        return ReturnErrorResponse("110", "BP Year is not available in the configuration.");
                    }
                }
                else
                {
                    psiDateData = _globalConfigRepository.GetAll().FirstOrDefault(c => c.ConfigKey == Contants.global_config_psi_year_key);
                    if (psiDateData == null)
                    {
                        return ReturnErrorResponse("110", "PSI Year is not available in the configuration.");
                    }
                }

                ValidateMonth(saleEntryData, psiDateData, request.DirectSale.SaleSubType);

                var materialsData = _materialRepository.GetMaterialByMg2Mg3(request.DirectSale.ProductCategoryId, request.DirectSale.ProductSubCategoryId);

                if (materialsData == null || (materialsData != null && materialsData.Count() == 0))
                {
                    return ReturnErrorResponse("112", "Materials are not available for the selected sub Category.");
                }
                ValidateMaterial(saleEntryData, materialsData);

                return PrepareAndSaveDirectSales(saleEntryData, request, uploadedResult);
            }
            catch (Exception ex)
            {
                Log.Error($"Error in uploading/reading direct sales file with Message - {ex.Message}. StackTrace - {ex.StackTrace}");
                return ReturnErrorResponse("500", Contants.ERROR_MSG);
            }

        }

        private Result ReturnErrorResponse(string errorCode, string errorMessage)
        {
            var result = new List<SP_InsertSalesEntries>(){
                new SP_InsertSalesEntries{
                    RowNo = 0,
                    ResponseCode = errorCode,
                    ResponseMessage = errorMessage,
                }
            };
            return Result.SuccessWith<List<SP_InsertSalesEntries>>(result);
        }

        /// <summary>
        /// Read Direct Sales Excel File
        /// </summary>
        /// <param name="command"></param>
        /// <param name="fileData"></param>
        /// <returns></returns>
        private SalesEntryData ReadExcelFile(DirectSale command, FileUploadResult fileData, string sheetName)
        {
            int rowNo = 0;
            string fileName;
            var file = command.File;
            fileName = Guid.NewGuid() + Path.GetExtension(file.FileName);
            var salesEntryData = new SalesEntryData();
            salesEntryData.ResponseList = new List<SP_InsertSalesEntries>();
            try
            {
                if (file != null)
                {
                    var salesDataExcelHeaders = new List<SalesDataExcelHeader>();
                    var fileExt = Path.GetExtension(file.FileName);
                    //var fs = file.OpenReadStream();
                    MemoryStream fs = new MemoryStream(fileData.FileBytes);
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
                        for (int i = 0; i < workbook.NumberOfSheets; i++)
                        {
                            string name = workbook.GetSheetName(i).Trim().Replace(" ", "").ToUpper();

                            if (!string.IsNullOrEmpty(name))
                            {
                                sheetNames.Add(name);
                            }
                        }
                        var expectedSheetIndex = sheetNames.FindIndex(c => c == sheetName);
                        if (expectedSheetIndex >= 0)
                        {
                            salesEntryData.IsValidSheet = true;
                            currentWorksheet = workbook.GetSheetAt(expectedSheetIndex);
                            var lastRowIndexToRead = currentWorksheet.LastRowNum;
                            int uploadFlagIndex = 0, typeColumnIndex = 0, rowToReadFrom = 18, adl1ColumnIndex = 0, adl2ColumnIndex = 0, adl3ColumnIndex = 0;
                            var headerRow = currentWorksheet.GetRow(rowToReadFrom);
                            int headerRowCellCount = headerRow.LastCellNum;

                            //Read Header Row
                            GetMarkedIndexFromHeaderRow(headerRowCellCount, headerRow, salesDataExcelHeaders, out uploadFlagIndex, out adl1ColumnIndex, out adl2ColumnIndex, out adl3ColumnIndex, out typeColumnIndex);

                            //Read Body Content
                            for (int rowIndex = rowToReadFrom + 1; rowIndex <= lastRowIndexToRead; rowIndex++)
                            {
                                rowNo = rowIndex;
                                var currentRow = currentWorksheet.GetRow(rowIndex);

                                var uploadFlagCell = currentRow.GetCell(uploadFlagIndex);
                                var typeCell = currentRow.GetCell(typeColumnIndex);
                                bool skipThisRow = false;

                                if (uploadFlagCell == null || (uploadFlagCell != null && uploadFlagCell.ToString() != Contants.DirectSale_UploadFlag)) skipThisRow = true;
                                if (typeCell == null || (typeCell != null && !Contants.DirectSale_AllowedTypes.Split(",").Any(i => i == typeCell.ToString()))) skipThisRow = true;

                                //if (currentRow == null) continue;
                                int currentRowCellCount = currentRow.LastCellNum;
                                var salesDataExcelRow = new SalesEntryRow();
                                salesDataExcelRow.RowIndex = rowIndex;
                                if (!skipThisRow)
                                {
                                    for (int colIndex = 0; colIndex <= currentRowCellCount; colIndex++)
                                    {
                                        ICell cell = currentRow.GetCell(colIndex);
                                        if (colIndex < adl3ColumnIndex)
                                        {
                                            if (cell != null)
                                            {
                                                string cellValue = Helper.GetCellValue(cell);
                                                PopulateData(colIndex, rowIndex, cellValue, salesDataExcelRow, salesDataExcelHeaders, salesEntryData,
                                                    adl1ColumnIndex, adl2ColumnIndex, adl3ColumnIndex);
                                            }
                                        }
                                        else
                                        {
                                            break;
                                        }
                                    }
                                    if (string.IsNullOrEmpty(salesDataExcelRow.ModelNumber)) salesDataExcelRow.ModelNumber = salesDataExcelRow.ItemCode;

                                    salesEntryData.SalesEntryRows.Add(salesDataExcelRow);
                                }
                            }
                        }
                    }
                }
                return salesEntryData;
            }
            catch (Exception ex)
            {
                rowNo= rowNo;
                throw;
            }
        }


        /// <summary>
        /// Get Marked Index From Header Row
        /// </summary>
        /// <param name="headerRowCellCount"></param>
        /// <param name="headerRow"></param>
        /// <param name="salesDataExcelHeaders"></param>
        /// <param name="uploadFlagIndex"></param>
        /// <param name="adl1ColumnIndex"></param>
        /// <param name="adl2ColumnIndex"></param>
        /// <param name="adl3ColumnIndex"></param>
        /// <param name="typeColumnIndex"></param>
        /// <returns></returns>
        private void GetMarkedIndexFromHeaderRow(int headerRowCellCount, IRow headerRow, List<SalesDataExcelHeader> salesDataExcelHeaders,
            out int uploadFlagIndex, out int adl1ColumnIndex, out int adl2ColumnIndex, out int adl3ColumnIndex, out int typeColumnIndex)
        {
            uploadFlagIndex = 0;
            adl1ColumnIndex = 0;
            adl2ColumnIndex = 0;
            adl3ColumnIndex = 0;
            typeColumnIndex = 0;

            for (int colIndex = 0; colIndex <= headerRowCellCount; colIndex++)
            {
                ICell cell = headerRow.GetCell(colIndex);
                if (cell != null)
                {
                    switch (cell.ToString())
                    {
                        case Contants.DirectSale_Header_UploadFlag:
                            uploadFlagIndex = colIndex;
                            break;
                        case Contants.DirectSale_Header_Adl1:
                            adl1ColumnIndex = colIndex;
                            break;
                        case Contants.DirectSale_Header_Adl2:
                            adl2ColumnIndex = colIndex;
                            break;
                        case Contants.DirectSale_Header_Adl3:
                            adl3ColumnIndex = colIndex;
                            break;
                        case Contants.DirectSale_Header_Type:
                            typeColumnIndex = colIndex;
                            break;
                    }
                    if (adl3ColumnIndex == 0)
                    {
                        salesDataExcelHeaders.Add(new SalesDataExcelHeader { Index = colIndex, Name = cell.ToString() });
                    }
                    else
                    {
                        break;
                    }
                }
            }
        }

        /// <summary>
        /// Populate the Cell Value with the Model
        /// </summary>
        /// <param name="colIndex"></param>
        /// <param name="rowIndex"></param>
        /// <param name="cellValue"></param>
        /// <param name="salesDataExcelRow"></param>
        /// <param name="salesDataExcelHeaders"></param>
        /// <param name="salesEntryData"></param>
        /// <param name="adl1ColumnIndex"></param>
        /// <param name="adl2ColumnIndex"></param>
        /// <param name="adl3ColumnIndex"></param>
        /// <returns></returns>
        private void PopulateData(int colIndex, int rowIndex, string cellValue, SalesEntryRow salesDataExcelRow,
            List<SalesDataExcelHeader> salesDataExcelHeaders, SalesEntryData salesEntryData,
            int adl1ColumnIndex, int adl2ColumnIndex, int adl3ColumnIndex)
        {
            var ignoreColumnsIndices = new List<int>() { };
            switch (colIndex)
            {
                case 0:
                    salesDataExcelRow.UploadFlag = cellValue;
                    break;
                case 1:
                    salesDataExcelRow.Class1 = cellValue;
                    break;
                case 2:
                    salesDataExcelRow.Class2 = cellValue;
                    break;
                case 3:
                    salesDataExcelRow.Class3 = cellValue;
                    break;
                case 4:
                    salesDataExcelRow.Class4 = cellValue;
                    break;
                case 5:
                    salesDataExcelRow.Class5 = cellValue;
                    break;
                case 6:
                    salesDataExcelRow.Class6 = cellValue;
                    break;
                case 7:
                    salesDataExcelRow.Class7 = cellValue;
                    break;
                case 8:
                    salesDataExcelRow.Class8 = cellValue;
                    break;
                case 9:
                    salesDataExcelRow.ItemCode = cellValue;
                    break;
                case 10:
                    salesDataExcelRow.ModelNumber = cellValue;
                    break;
                case 11:
                    salesDataExcelRow.TypeCode = cellValue;
                    break;
                case 12:
                    salesDataExcelRow.Comments = cellValue;
                    break;
                default:
                    if (!ignoreColumnsIndices.Any(i => i == colIndex))
                    {
                        var salesDataExcelHeader = salesDataExcelHeaders.First(s => s.Index == colIndex);
                        var monthNameStr = ConvertQtyMonthName(salesDataExcelHeader.Name);
                        if (colIndex < adl1ColumnIndex && monthNameStr != "")
                        {
                            if (string.IsNullOrEmpty(monthNameStr))
                            {
                                salesEntryData.ResponseList.Add(new SP_InsertSalesEntries
                                {
                                    RowNo = rowIndex + 1,
                                    ResponseCode = "107",
                                    ResponseMessage = $"RowNo: {rowIndex + 1}: Month is not valid"
                                });
                            }
                            else
                            {
                                int quantityValue = 0;
                                if (!string.IsNullOrEmpty(cellValue))
                                {
                                    var isValid = Int32.TryParse(cellValue, out quantityValue);
                                    if (isValid)
                                    {
                                        if (salesDataExcelRow.TypeCode == "I" && quantityValue < 0)
                                        {
                                            salesEntryData.ResponseList.Add(new SP_InsertSalesEntries
                                            {
                                                RowNo = rowIndex + 1,
                                                ResponseCode = "108",
                                                ResponseMessage = $"RowNo: {rowIndex + 1}: Month: {salesDataExcelHeader.Name} has negative value"
                                            });
                                        }
                                        else
                                        {
                                            salesEntryData.SalesQtyInfos.Add(
                                            new SalesQtyInfo
                                            {
                                                ColIndex = colIndex,
                                                RowIndex = rowIndex,
                                                QtyMonthName = monthNameStr,
                                                Qty = quantityValue
                                            });
                                        }
                                    }
                                    else
                                    {
                                        salesEntryData.ResponseList.Add(new SP_InsertSalesEntries
                                        {
                                            RowNo = rowIndex + 1,
                                            ResponseCode = "103",
                                            ResponseMessage = $"RowNo: {rowIndex + 1}: Has invalid character, It should be numeric"
                                        });
                                    }
                                }
                                else
                                {
                                    salesEntryData.SalesQtyInfos.Add(
                                   new SalesQtyInfo
                                   {
                                       ColIndex = colIndex,
                                       RowIndex = rowIndex,
                                       QtyMonthName = monthNameStr,
                                       Qty = 0
                                   });
                                }
                            }
                        }

                        else if (colIndex > adl2ColumnIndex && colIndex < adl3ColumnIndex)
                        {
                            if (colIndex == adl2ColumnIndex + 1)
                            {
                                salesDataExcelRow.Currency = cellValue;
                            }
                            else if (string.IsNullOrEmpty(monthNameStr))
                            {
                                salesEntryData.ResponseList.Add(new SP_InsertSalesEntries
                                {
                                    RowNo = rowIndex + 1,
                                    ResponseCode = "107",
                                    ResponseMessage = $"RowNo: {rowIndex + 1}: Month is not valid"
                                });
                            }
                            else
                            {
                                decimal priceValue = 0;
                                if (!string.IsNullOrEmpty(cellValue))
                                {
                                    var isValid = Decimal.TryParse(cellValue, out priceValue);
                                    if (isValid)
                                    {
                                        if (salesDataExcelRow.TypeCode == "I" && priceValue < 0)
                                        {
                                            salesEntryData.ResponseList.Add(new SP_InsertSalesEntries
                                            {
                                                RowNo = rowIndex + 1,
                                                ResponseCode = "108",
                                                ResponseMessage = $"RowNo: {rowIndex + 1}: Month: {salesDataExcelHeader.Name} has negative value"
                                            });
                                        }
                                        else
                                        {
                                            salesEntryData.SalesPriceInfos.Add(
                                            new SalesPriceInfo
                                            {
                                                ColIndex = colIndex,
                                                RowIndex = rowIndex,
                                                PriceMonthName = monthNameStr,
                                                Price = priceValue
                                            });
                                        }
                                    }
                                    else
                                    {
                                        salesEntryData.ResponseList.Add(new SP_InsertSalesEntries
                                        {
                                            RowNo = rowIndex + 1,
                                            ResponseCode = "103",
                                            ResponseMessage = $"RowNo: {rowIndex + 1}: Has invalid character, It should be numeric"
                                        });
                                    }
                                }
                                else
                                {
                                    salesEntryData.SalesPriceInfos.Add(
                                    new SalesPriceInfo
                                    {
                                        ColIndex = colIndex,
                                        RowIndex = rowIndex,
                                        PriceMonthName = monthNameStr,
                                        Price = 0
                                    });
                                }
                            }
                        }
                    }
                    break;
            }
        }

        /// <summary>
        /// Convert Date format as per PSI Dates formats
        /// </summary>
        /// <param name="monthName"></param>
        /// <returns></returns>
        private string ConvertQtyMonthName(string monthName)
        {
            string result = "";

            if (!string.IsNullOrEmpty(monthName))
            {
                Regex rgMonth = new Regex(@"^...-\d\d-[Q|P]$");
                if (rgMonth.IsMatch(monthName))
                {
                    var strSplits = monthName.Split('-');
                    DateTime dt;
                    bool isValidDate = DateTime.TryParseExact("01" + strSplits[0] + strSplits[1], "ddMMMyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt);
                    if (isValidDate)
                    {
                        result = dt.ToString("yyyyMM");
                    }
                }
            }
            return result;
        }

        /// <summary>
        /// Prepare Data And Save DirectSales
        /// </summary>
        /// <param name="salesEntryData"></param>
        /// <param name="command"></param>
        /// <param name="uploadedResult"></param>
        /// <returns></returns>
        private Result PrepareAndSaveDirectSales(SalesEntryData salesEntryData, DirectSalesCommand command, FileUploadResult uploadedResult)
        {
            try
            {
                if (salesEntryData != null && salesEntryData.SalesEntryRows.Count > 0)
                {
                    var dtSalesEntries = new DataTable();
                    dtSalesEntries.Columns.Add(new DataColumn("RowIndex", typeof(int)));
                    dtSalesEntries.Columns.Add(new DataColumn("UploadFlag", typeof(string)));
                    dtSalesEntries.Columns.Add(new DataColumn("Class1", typeof(string)));
                    dtSalesEntries.Columns.Add(new DataColumn("Class2", typeof(string)));
                    dtSalesEntries.Columns.Add(new DataColumn("Class3", typeof(string)));
                    dtSalesEntries.Columns.Add(new DataColumn("Class4", typeof(string)));
                    dtSalesEntries.Columns.Add(new DataColumn("Class5", typeof(string)));
                    dtSalesEntries.Columns.Add(new DataColumn("Class6", typeof(string)));
                    dtSalesEntries.Columns.Add(new DataColumn("Class7", typeof(string)));
                    dtSalesEntries.Columns.Add(new DataColumn("Class8", typeof(string)));
                    dtSalesEntries.Columns.Add(new DataColumn("ItemCode", typeof(string)));
                    dtSalesEntries.Columns.Add(new DataColumn("ModelNumber", typeof(string)));
                    dtSalesEntries.Columns.Add(new DataColumn("TypeCode", typeof(string)));
                    dtSalesEntries.Columns.Add(new DataColumn("Comments", typeof(string)));
                    dtSalesEntries.Columns.Add(new DataColumn("Currency", typeof(string)));

                    var dtSalesQtyInfos = new DataTable();
                    dtSalesQtyInfos.Columns.Add(new DataColumn("RowIndex", typeof(int)));
                    dtSalesQtyInfos.Columns.Add(new DataColumn("QtyMonthName", typeof(string)));
                    dtSalesQtyInfos.Columns.Add(new DataColumn("Qty", typeof(int)));

                    var dtSalesPriceInfos = new DataTable();
                    dtSalesPriceInfos.Columns.Add(new DataColumn("RowIndex", typeof(int)));
                    dtSalesPriceInfos.Columns.Add(new DataColumn("PriceMonthName", typeof(string)));
                    dtSalesPriceInfos.Columns.Add(new DataColumn("Price", typeof(decimal)));

                    foreach (var row in salesEntryData.SalesEntryRows)
                    {
                        dtSalesEntries.Rows.Add(
                            row.RowIndex,
                            row.UploadFlag,
                            row.Class1,
                            row.Class2,
                            row.Class3,
                            row.Class4,
                            row.Class5,
                            row.Class6,
                            row.Class7,
                            row.Class8,
                            row.ItemCode,
                            row.ModelNumber,
                            row.TypeCode,
                            row.Comments,
                            row.Currency);
                    }
                    foreach (var row in salesEntryData.SalesQtyInfos)
                    {
                        dtSalesQtyInfos.Rows.Add(row.RowIndex, row.QtyMonthName, row.Qty);
                    }
                    foreach (var row in salesEntryData.SalesPriceInfos)
                    {
                        dtSalesPriceInfos.Rows.Add(row.RowIndex, row.PriceMonthName, row.Price);
                    }

                    return SaveDirectSales(command, uploadedResult, dtSalesEntries, dtSalesQtyInfos, dtSalesPriceInfos, salesEntryData.ResponseList);
                }
                else
                {
                    return ReturnErrorResponse("500", "No Valid Data To Process.");
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
        private Result SaveDirectSales(DirectSalesCommand command, FileUploadResult uploadedResult, DataTable dtSalesEntries, DataTable dtSalesQtyInfos, DataTable dtSalesPriceInfos, List<SP_InsertSalesEntries> responseList)
        {
            try
            {

                var customerId = new SqlParameter("@customerId", SqlDbType.Int);
                customerId.Value = command.DirectSale.CustomerId;

                var productCategoryId = new SqlParameter("@productCategoryId", SqlDbType.Int);
                productCategoryId.Value = command.DirectSale.ProductCategoryId;


                var salesEntry = new SqlParameter("@tvpSalesEntries", SqlDbType.Structured);
                salesEntry.Value = dtSalesEntries;
                salesEntry.TypeName = "dbo.TVP_SALES_ENTRY_ROWS";

                var qtyInfo = new SqlParameter("@tvpSalesQuantities", SqlDbType.Structured);
                qtyInfo.Value = dtSalesQtyInfos;
                qtyInfo.TypeName = "dbo.TVP_SALES_ENTRY_QUANTITIES";

                var priceInfo = new SqlParameter("@tvpSalesPrices", SqlDbType.Structured);
                priceInfo.Value = dtSalesPriceInfos;
                priceInfo.TypeName = "dbo.TVP_SALES_ENTRY_PRICES";

                var userId = new SqlParameter("@userId", SqlDbType.NVarChar, 100);
                userId.Value = command.SessionData.ADUserId ?? string.Empty;

                var attachmentId = new SqlParameter("@attachmentId", SqlDbType.Int);
                attachmentId.Value = uploadedResult.Id;

                var saleSubType = new SqlParameter("@saleSubType", SqlDbType.VarChar, 50);
                saleSubType.Value = command.DirectSale.SaleSubType;

                var isValid = new SqlParameter("@isValid", SqlDbType.Bit);
                isValid.Value = responseList.Count() == 0 ? 1 : 0;

                var param = new SqlParameter[] {
                    customerId,
                    productCategoryId,
                   
                    salesEntry,
                    qtyInfo,
                    priceInfo,
                    userId,
                    attachmentId,
                    saleSubType,
                    isValid
                    };
                var result = new List<SP_InsertSalesEntries>();
                if (command.DirectSale.SaleSubType.ToUpper() == "BP")
                {
                    result = _context.SP_InsertSalesEntries.FromSqlRaw("dbo.SP_INSUPD_SALES_ENTRY_BP @customerId, @productCategoryId, @tvpSalesEntries, @tvpSalesQuantities, @tvpSalesPrices, @userId, @attachmentId, @saleSubType, @isValid", param).AsNoTracking().ToList();
                }
                else
                {
                    result = _context.SP_InsertSalesEntries.FromSqlRaw("dbo.SP_Insert_Sales_Entries @customerId, @productCategoryId, @tvpSalesEntries, @tvpSalesQuantities, @tvpSalesPrices, @userId, @attachmentId, @saleSubType, @isValid", param).AsNoTracking().ToList();
                }
                //var result = _directSalesRepository.ExecuteProcedure("dbo.SP_Insert_Sales_Entries", param);

                if (result != null && result.ToList().Any())
                {
                    var spResult = result.ToList().Where(r => r.ResponseCode != "200");
                    responseList.AddRange(spResult);
                    if (responseList.Any())
                    {
                        responseList = responseList.OrderBy(c => c.RowNo).ToList();
                        return Result.SuccessWith<List<SP_InsertSalesEntries>>(responseList);
                    }
                    else
                    {
                        var successRespone = result.Where(r => r.ResponseCode == "200").ToList();
                        if (successRespone.Count() > 0)
                        {
                            Task.Run(() => _attachmentService.ActivateFile(uploadedResult.Id));
                            return Result.SuccessWith<List<SP_InsertSalesEntries>>(successRespone);
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

        private bool ValidateMonth(SalesEntryData salesEntryData, GlobalConfig psiDateData, string salesSubType)
        {
            int firstRowIndex = salesEntryData.SalesEntryRows.First().RowIndex;
            if (salesEntryData.SalesPriceInfos.Count(c => c.RowIndex == firstRowIndex) != Contants.direct_sales_upload_month_count ||
            salesEntryData.SalesQtyInfos.Count(c => c.RowIndex == firstRowIndex) != Contants.direct_sales_upload_month_count)
            {
                salesEntryData.ResponseList.Add(new SP_InsertSalesEntries
                {
                    RowNo = 0,
                    ResponseCode = "111",
                    ResponseMessage = "File contains extra column/ File contains less number of columns than expected"
                });
            }

            int monthCount = 0;
            DateTime? startMonthYear;
            if (salesSubType == "BP")
            {

                 startMonthYear = GetDateFromMonthYear(psiDateData.ConfigValue + Convert.ToString(salesEntryData.SalesQtyInfos[0].QtyMonthName).Substring(4, 2));
                if (!startMonthYear.HasValue)
                {
                    salesEntryData.ResponseList.Add(new SP_InsertSalesEntries
                    {
                        RowNo = 0,
                        ResponseCode = "111",
                        ResponseMessage = "BP Year is not valid"
                    });
                }
            }
            else
            {
                startMonthYear = GetDateFromMonthYear(psiDateData.ConfigValue + "01");
                if (!startMonthYear.HasValue)
                {
                    salesEntryData.ResponseList.Add(new SP_InsertSalesEntries
                    {
                        RowNo = 0,
                        ResponseCode = "111",
                        ResponseMessage = "PSI Year is not valid"
                    });
                }
            }

            foreach (var item in salesEntryData.SalesQtyInfos.Where(c => c.RowIndex == firstRowIndex))
            {
                var dateMonthYear = GetDateFromMonthYear(item.QtyMonthName);
                if (dateMonthYear != null)
                {
                    if (monthCount == 0)
                    {
                        if (GetMonthYearFromDate(startMonthYear.Value) != GetMonthYearFromDate(dateMonthYear.Value))
                        {
                            salesEntryData.ResponseList.Add(new SP_InsertSalesEntries
                            {
                                RowNo = item.RowIndex + 1,
                                ResponseCode = "111",
                                ResponseMessage = $"{item.QtyMonthName} Month is not valid PSI Year / Invalid sequence"
                            });
                        }
                    }
                    else
                    {
                        var currentMonthYear = startMonthYear.Value.AddMonths(monthCount);
                        if (GetMonthYearFromDate(currentMonthYear) != GetMonthYearFromDate(dateMonthYear.Value))
                        {
                            salesEntryData.ResponseList.Add(new SP_InsertSalesEntries
                            {
                                RowNo = item.RowIndex + 1,
                                ResponseCode = "111",
                                ResponseMessage = $"{item.QtyMonthName} Month is not valid PSI Year / Invalid sequence"
                            });
                        }
                    }
                }
                else
                {
                    salesEntryData.ResponseList.Add(new SP_InsertSalesEntries
                    {
                        RowNo = item.RowIndex + 1,
                        ResponseCode = "111",
                        ResponseMessage = $"{item.QtyMonthName} Month is not valid"
                    });
                }
                monthCount++;
            }

            monthCount = 0;
            foreach (var item in salesEntryData.SalesPriceInfos.Where(c => c.RowIndex == firstRowIndex))
            {
                var dateMonthYear = GetDateFromMonthYear(item.PriceMonthName);
                if (dateMonthYear != null)
                {
                    if (monthCount == 0)
                    {
                        if (GetMonthYearFromDate(startMonthYear.Value) != GetMonthYearFromDate(dateMonthYear.Value))
                        {
                            salesEntryData.ResponseList.Add(new SP_InsertSalesEntries
                            {
                                RowNo = item.RowIndex + 1,
                                ResponseCode = "111",
                                ResponseMessage = $"{item.PriceMonthName} Month is not valid PSI Year / Invalid sequence"
                            });
                        }
                    }
                    else
                    {
                        var currentMonthYear = startMonthYear.Value.AddMonths(monthCount);
                        if (GetMonthYearFromDate(currentMonthYear) != GetMonthYearFromDate(dateMonthYear.Value))
                        {
                            salesEntryData.ResponseList.Add(new SP_InsertSalesEntries
                            {
                                RowNo = item.RowIndex + 1,
                                ResponseCode = "111",
                                ResponseMessage = $"{item.PriceMonthName} Month is not valid PSI Year / Invalid sequence"
                            });
                        }
                    }
                }
                else
                {
                    salesEntryData.ResponseList.Add(new SP_InsertSalesEntries
                    {
                        RowNo = item.RowIndex + 1,
                        ResponseCode = "111",
                        ResponseMessage = $"{item.PriceMonthName} Month is not valid"
                    });
                }
                monthCount++;
            }

            return true;
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
        /// Validate Material
        /// </summary>
        /// <param name="salesEntryData"></param>
        /// <param name="materials"></param>
        /// <returns></returns>
        private void ValidateMaterial(SalesEntryData salesEntryData, List<Material> materials)
        {
            var responseList = new List<SP_InsertSalesEntries>();
            foreach (var row in salesEntryData.SalesEntryRows.Where(x=>x.TypeCode=="O"))
            {
                if (materials.FirstOrDefault(c => c.MaterialCode.ToLower() == row.ItemCode.ToLower()) == null)
                {
                    salesEntryData.ResponseList.Add(new SP_InsertSalesEntries
                    {
                        RowNo = row.RowIndex + 1,
                        ResponseCode = "113",
                        ResponseMessage = $"RowNo: {row.RowIndex + 1},Material Code:" + row.ItemCode + ", Has invalid Material, Which is not mapped to the selected Category"
                    });
                }
            }
        }

        /// <summary>
        /// Get Customer With Currency,
        /// </summary>
        /// <param name="customerId"></param>
        /// <returns></returns>
        private SP_Get_Customer_Country_Currency GetCustomerWithCurrency(int customerId)
        {
            try
            {
                var paramCustomerId = new SqlParameter("@customerId", SqlDbType.Int);
                paramCustomerId.Value = customerId;
                var param = new SqlParameter[] {
                    paramCustomerId
                };
                var result = _context.SP_Get_Customer_Country_Currency.FromSqlRaw("dbo.SP_Get_Customer_Country_Currency @customerId", param).AsNoTracking().ToList();
                if (result != null && result.Count() > 0)
                {
                    return result[0];
                }
                return null;
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}
