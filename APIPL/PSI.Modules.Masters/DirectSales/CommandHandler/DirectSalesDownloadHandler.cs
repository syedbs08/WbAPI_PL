using AttachmentService;
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
using PSI.Modules.Backends.DirectSales.Results;
using PSI.Modules.Backends.Helpers;
using PSI.Modules.Backends.Masters.Repository.AttachmentMaster;
using PSI.Modules.Backends.Masters.Repository.CurrencyMaster;
using PSI.Modules.Backends.Masters.Repository.MaterialMaster;
using PSI.Modules.Backends.Masters.Repository.RegionMaster;
using PSI.Modules.Backends.Masters.Repository.ProductCategoryMaster;
using System.Data;
using System.Globalization;
using System.Text.RegularExpressions;
using Core.BaseUtility.TableSearchUtil;
using System.Linq;

namespace PSI.Modules.Backends.DirectSales.CommandHandler
{
    public class DirectSalesDownloadHandler : IRequestHandler<DirectSalesDownloadCommand, Result>
    {

        private readonly ISaleEntryHeaderRepository _saleEntryHeaderRepository;
        private readonly ISalesEntryRepository _saleEntryRepository;
        private readonly ISalesEntryPriceQuantityRepository _salePriceQuantityRepository;
        private readonly IMaterialRepository _materialRepository;
        private readonly IModeofTypeRepository _modeofTypeRepository;
        private readonly IAttachmentRepository _attachmentRepository;
        private readonly IAttachmentService _attachmentService;
        private readonly ICurrencyRepository _currencyRepository;
        private readonly IProductCategoryRepository _productCategoryRepository;
        private readonly PSIDbContext _context;
        public DirectSalesDownloadHandler(
           ISaleEntryHeaderRepository saleEntryHeaderRepository,
           ISalesEntryRepository saleEntryRepository,
           ISalesEntryPriceQuantityRepository salesPriceQuantityRepository,
           IMaterialRepository materialRepository,
           IModeofTypeRepository modeofTypeRepository,
           IAttachmentRepository attachmentRepository,
            IAttachmentService attachmentService,
            ICurrencyRepository currencyRepository,
            IProductCategoryRepository productCategoryRepository)
        {
            _saleEntryHeaderRepository = saleEntryHeaderRepository;
            _saleEntryRepository = saleEntryRepository;
            _salePriceQuantityRepository = salesPriceQuantityRepository;
            _materialRepository = materialRepository;
            _modeofTypeRepository = modeofTypeRepository;
            _attachmentRepository = attachmentRepository;
            _attachmentService = attachmentService;
            _currencyRepository = currencyRepository;
            _productCategoryRepository = productCategoryRepository;
            _context = new PSIDbContext();
        }
        public async Task<Result> Handle(DirectSalesDownloadCommand request, CancellationToken cancellationToken)
        {
            try
            {
                // Get Local and USD Currency
                var customerWithLocalCurrency = GetCustomerWithCurrency(request.DirectSalesDownload.CustomerId);
                var usdCurrency = _currencyRepository.GetCurrency(Contants.direct_sales_upload_usd_currency, Contants.direct_sales_upload_usd_currency);
                var productCategory = _productCategoryRepository.GetById(Convert.ToInt32(request.DirectSalesDownload.ProductCategoryId)).Result;
                if (customerWithLocalCurrency != null && usdCurrency != null && productCategory != null)
                {
                    // get direct sales details from database
                    var sheetName = customerWithLocalCurrency.CustomerCode + "-" + productCategory.ProductCategoryCode;
                    request.DirectSalesDownload.ProductSubCategoryId = request.DirectSalesDownload.ProductSubCategoryId == "null" ? null : request.DirectSalesDownload.ProductSubCategoryId;
                    List<SP_SALES_DOWNLOAD_BP> salesdata = new List<SP_SALES_DOWNLOAD_BP>();
                    if (request.DirectSalesDownload.SaleSubType.ToUpper() == "MONTHLY")
                    {
                        salesdata = await _context.SP_SALES_DOWNLOAD_BP.FromSql($"SP_SALES_DOWNLOAD_MONTHLY {request.DirectSalesDownload.FromMonth},{request.DirectSalesDownload.ToMonth},{request.DirectSalesDownload.CustomerId},{request.DirectSalesDownload.ProductCategoryId},{request.DirectSalesDownload.ProductSubCategoryId},{request.DirectSalesDownload.IsUSDCurrency}").AsNoTracking().ToListAsync();
                    }
                    else
                    {
                        String bp_Year = Convert.ToString(request.DirectSalesDownload.FromMonth).Substring(0, 4);
                        salesdata = await _context.SP_SALES_DOWNLOAD_BP.FromSql($"SP_SALES_DOWNLOAD_BP {request.DirectSalesDownload.FromMonth},{request.DirectSalesDownload.ToMonth},{request.DirectSalesDownload.CustomerId},{request.DirectSalesDownload.ProductCategoryId},{request.DirectSalesDownload.ProductSubCategoryId},{request.DirectSalesDownload.IsUSDCurrency},{bp_Year}").AsNoTracking().ToListAsync();
                    }
                    if (salesdata != null && salesdata.Count() > 0)
                    {
                        string attachmentFilePath = "";
                        string fileExtension = "";
                        //string attachmentFilePath = "DirectSale_Upload.xlsx";
                        //string fileExtension = ".xlsx";
                        if (request.DirectSalesDownload.IsDownload)
                        {
                            int AttachmentId = (int)salesdata.Where(x => x.AttachmentId != 0).Select(x => x.AttachmentId).FirstOrDefault();
                            if (AttachmentId != null)
                            {
                                var attachment = _attachmentRepository.GetAttachmentById(AttachmentId);
                                if (attachment != null)
                                {
                                    attachmentFilePath = attachment.VirtualFileName;
                                    fileExtension = attachment.Extension;

                                    return await PrepareSheetWithNewDataBP(salesdata, customerWithLocalCurrency, usdCurrency, request.DirectSalesDownload.IsUSDCurrency, attachmentFilePath, sheetName, fileExtension);

                                }
                                else
                                {
                                    return Result.Failure("No attachment found");
                                }
                            }
                        }
                        else
                        {
                            return Result.SuccessWith(salesdata);
                        }
                    }
                }
                else
                {
                    return Result.Failure("Customer / Curreny / Product details not found!");
                }

                return Result.Failure("No data found on the search criteria!");
            }
            catch (Exception ex)
            {
                Log.Error($"Error in downloading direct sales file with Message - {ex.Message}. StackTrace - {ex.StackTrace}");
                return Result.Failure(Contants.ERROR_MSG);
            }
        }
        private async Task<Result> PrepareSheetWithNewDataBP(List<SP_SALES_DOWNLOAD_BP> salesEntriesFromDB, SP_Get_Customer_Country_Currency customerWithLocalCurrency, Currency usdCurrency, bool isUSDCurrency, string attachmentFilePath, string sheetName, string fileExtension)
        {

            // get files details from database
            //var filePath = "direct-sales/05e702b2-128d-48db-9dcb-c821d3eb54ab.xlsx";
            var stream = await _attachmentService.GetFileStream(attachmentFilePath, Contants.direct_sales_upload_folder);
            var returnStream = new MemoryStream();
            var fileExt = Path.GetExtension(attachmentFilePath);

            //update cell values data to excel file
            var salesDataExcelHeaders = new List<SalesDataExcelHeader>();
            IWorkbook workbook = null;
            ISheet currentWorksheet;
            bool isReadAndWriteSuccess = false;
            if (stream != null && stream != Stream.Null)
            {
                var streamBuff = stream.ToArray();
                MemoryStream ms = new MemoryStream(streamBuff);
                var sheetNames = new List<string>();
                if (fileExt == ".xls")
                {
                    workbook = new HSSFWorkbook(ms);
                }
                else
                {
                    workbook = new XSSFWorkbook(ms);
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


                    var samplesheetName = "20011790-250";

                    var expectedSheetIndex = sheetNames.FindIndex(c => c == sheetName);
                    if (expectedSheetIndex >= 0)
                    {
                        currentWorksheet = workbook.GetSheetAt(expectedSheetIndex);
                        var lastRowIndexToRead = currentWorksheet.LastRowNum;

                        int uploadFlagIndex = 0, typeColumnIndex = 0, itemCodeColumnIndex = 0, rowToReadFrom = 18, adl1ColumnIndex = 0, adl2ColumnIndex = 0, adl3ColumnIndex = 0, priceColumnIndex = 0;
                        var monthNamesFromFile = new Dictionary<int, string>();
                        var ignoreColumnsIndices = new List<int>() { };

                        var headerRow = currentWorksheet.GetRow(rowToReadFrom);
                        int headerRowCellCount = headerRow.LastCellNum;

                        //Read Header Row
                        GetMarkedIndexFromHeaderRow(headerRowCellCount, headerRow, salesDataExcelHeaders, out uploadFlagIndex,
                            out adl1ColumnIndex, out adl2ColumnIndex, out adl3ColumnIndex, out typeColumnIndex, out itemCodeColumnIndex, out monthNamesFromFile, out priceColumnIndex);

                        //Read Body Content
                        for (int rowIndex = rowToReadFrom + 1; rowIndex <= lastRowIndexToRead; rowIndex++)
                        {
                            var currentRow = currentWorksheet.GetRow(rowIndex);
                            var uploadFlagCell = currentRow.GetCell(uploadFlagIndex);
                            var typeCell = currentRow.GetCell(typeColumnIndex);
                            var itemCodeCell = currentRow.GetCell(itemCodeColumnIndex);
                            bool skipThisRow = false;

                            if (uploadFlagCell != null && Helper.GetCellValue(uploadFlagCell) != Contants.DirectSale_UploadFlag) skipThisRow = true;
                            if (typeCell != null && !Contants.DirectSale_AllowedTypes.Split(",").Any(i => i == Helper.GetCellValue(typeCell))) skipThisRow = true;

                            int currentRowCellCount = currentRow.LastCellNum;
                            var salesDataExcelRow = new SalesEntryRow();
                            salesDataExcelRow.RowIndex = rowIndex;

                            if (!skipThisRow)
                            {
                                var currentRowSalesEntryFromDB = salesEntriesFromDB.FirstOrDefault(s => s.TypeCode == Helper.GetCellValue(typeCell) && s.ItemCode == Helper.GetCellValue(itemCodeCell));
                                if (currentRowSalesEntryFromDB != null)
                                {
                                    //var currentRowSalesEntryPriceQtyFromDB = currentRowSalesEntryFromDB.SalesEntryPriceQuantity;
                                    //if (currentRowSalesEntryPriceQtyFromDB != null && currentRowSalesEntryPriceQtyFromDB.Count() > 0)
                                    //{
                                    for (int colIndex = 0; colIndex <= currentRowCellCount; colIndex++)
                                    {
                                        if (monthNamesFromFile.ContainsKey(colIndex))
                                        {
                                            var currentRowMonth = monthNamesFromFile.First(m => m.Key == colIndex);
                                            if (colIndex > typeColumnIndex + 1 && colIndex < adl1ColumnIndex)
                                            {
                                                var currentQtyMonth = salesEntriesFromDB.FirstOrDefault(s => s.QtyMonthName == currentRowMonth.Value);
                                                if (currentQtyMonth != null)
                                                {
                                                    ICell cell = currentRow.GetCell(colIndex);
                                                    SetNumericCellValue(cell, (int)currentQtyMonth.Qty);
                                                }

                                            }
                                            else if (colIndex == priceColumnIndex)
                                            {
                                                ICell cell = currentRow.GetCell(colIndex);
                                                if (isUSDCurrency == true)
                                                {
                                                    SetCellValue(cell, "USD");
                                                }
                                                else
                                                {
                                                    if (Helper.GetCellValue(typeCell) == "P" || Helper.GetCellValue(typeCell) == "S" || Helper.GetCellValue(typeCell) == "I")
                                                    {
                                                        SetCellValue(cell, customerWithLocalCurrency.CurrencyCode);
                                                    }
                                                    //else
                                                    //{
                                                    //    //SetCellValue(cell, "AED");
                                                    //}

                                                }

                                            }
                                            else if (colIndex > adl2ColumnIndex && colIndex < adl3ColumnIndex)
                                            {
                                                var currentPriceMonth = salesEntriesFromDB.FirstOrDefault(s => s.PriceMonthName == currentRowMonth.Value);
                                                if (currentPriceMonth != null)
                                                {
                                                    //var convertedPrice = GetConvertedPrice(currentPriceMonth.Price, currentRowSalesEntryFromDB.TypeCode, customerWithLocalCurrency.ExchangeRate, usdCurrency.ExchangeRate, isUSDCurrency);
                                                    ICell cell = currentRow.GetCell(colIndex);
                                                    SetCellValue(cell, currentPriceMonth.Price.ToString());
                                                }
                                            }
                                        }
                                    }
                                    //}
                                }
                            }
                        }
                        isReadAndWriteSuccess = true;
                    }
                    //XSSFSheet sheet = (XSSFSheet)workbook.GetSheetAt(1);
                    //workbook.SetSheetName(workbook.GetSheetIndex(sheet), sheetName);
                    //if (workbook is XSSFWorkbook)
                    //{
                    //    XSSFFormulaEvaluator.EvaluateAllFormulaCells(workbook);
                    //}
                    //else
                    //{
                    //    HSSFFormulaEvaluator.EvaluateAllFormulaCells(workbook);
                    //}
                    workbook.Write(returnStream, false);
                    workbook.Close();
                }
                if (isReadAndWriteSuccess)
                {
                    var result = new SalesEntryDownloadFileResult
                    {
                        FileContent = returnStream.ToArray(),
                        FileName = sheetName + "-" + DateTime.Now.ToString("MMMyyyy"),
                        FileExtension = fileExtension,
                    };
                    return Result.SuccessWith(result);
                }
                else
                {
                    return Result.Failure("Unable to read latest file!");
                }
            }
            else
            {
                return Result.Failure("Unable to read latest file!");
            }
        }

        //private async Task<Result> PrepareSheetWithNewData(List<SP_SALES_DOWNLOAD_BP> salesEntriesFromDB, SP_Get_Customer_Country_Currency customerWithLocalCurrency, Currency usdCurrency, bool isUSDCurrency, string attachmentFilePath, string sheetName, string fileExtension)
        //{

        //    // get files details from database
        //    //var filePath = "direct-sales/05e702b2-128d-48db-9dcb-c821d3eb54ab.xlsx";
        //    var stream = await _attachmentService.GetFileStream(attachmentFilePath, Contants.direct_sales_upload_folder);
        //    var returnStream = new MemoryStream();
        //    var fileExt = Path.GetExtension(attachmentFilePath);

        //    //update cell values data to excel file
        //    var salesDataExcelHeaders = new List<SalesDataExcelHeader>();
        //    IWorkbook workbook = null;
        //    ISheet currentWorksheet;
        //    bool isReadAndWriteSuccess = false;
        //    if (stream != null && stream != Stream.Null)
        //    {
        //        var streamBuff = stream.ToArray();
        //        MemoryStream ms = new MemoryStream(streamBuff);
        //        var sheetNames = new List<string>();
        //        if (fileExt == ".xls")
        //        {
        //            workbook = new HSSFWorkbook(ms);
        //        }
        //        else
        //        {
        //            workbook = new XSSFWorkbook(ms);
        //        }
        //        if (workbook != null)
        //        {
        //            for (int i = 0; i < workbook.NumberOfSheets; i++)
        //            {
        //                string name = workbook.GetSheetName(i).Trim().Replace(" ", "").ToUpper();

        //                if (!string.IsNullOrEmpty(name))
        //                {
        //                    sheetNames.Add(name);
        //                }
        //            }
        //            var expectedSheetIndex = sheetNames.FindIndex(c => c == sheetName);
        //            if (expectedSheetIndex >= 0)
        //            {
        //                currentWorksheet = workbook.GetSheetAt(expectedSheetIndex);
        //                var lastRowIndexToRead = currentWorksheet.LastRowNum;

        //                int uploadFlagIndex = 0, typeColumnIndex = 0, itemCodeColumnIndex = 0, rowToReadFrom = 18, adl1ColumnIndex = 0, adl2ColumnIndex = 0, adl3ColumnIndex = 0, priceColumnIndex = 0;
        //                var monthNamesFromFile = new Dictionary<int, string>();
        //                var ignoreColumnsIndices = new List<int>() { };

        //                var headerRow = currentWorksheet.GetRow(rowToReadFrom);
        //                int headerRowCellCount = headerRow.LastCellNum;

        //                //Read Header Row
        //                GetMarkedIndexFromHeaderRow(headerRowCellCount, headerRow, salesDataExcelHeaders, out uploadFlagIndex,
        //                    out adl1ColumnIndex, out adl2ColumnIndex, out adl3ColumnIndex, out typeColumnIndex, out itemCodeColumnIndex, out monthNamesFromFile, out priceColumnIndex);

        //                //Read Body Content
        //                for (int rowIndex = rowToReadFrom + 1; rowIndex <= lastRowIndexToRead; rowIndex++)
        //                {
        //                    var currentRow = currentWorksheet.GetRow(rowIndex);
        //                    var uploadFlagCell = currentRow.GetCell(uploadFlagIndex);
        //                    var typeCell = currentRow.GetCell(typeColumnIndex);
        //                    var itemCodeCell = currentRow.GetCell(itemCodeColumnIndex);
        //                    bool skipThisRow = false;

        //                    if (uploadFlagCell != null && Helper.GetCellValue(uploadFlagCell) != Contants.DirectSale_UploadFlag) skipThisRow = true;
        //                    if (typeCell != null && !Contants.DirectSale_AllowedTypes.Split(",").Any(i => i == Helper.GetCellValue(typeCell))) skipThisRow = true;

        //                    int currentRowCellCount = currentRow.LastCellNum;
        //                    var salesDataExcelRow = new SalesEntryRow();
        //                    salesDataExcelRow.RowIndex = rowIndex;

        //                    if (!skipThisRow)
        //                    {
        //                        var currentRowSalesEntryFromDB = salesEntriesFromDB.FirstOrDefault(s => s.TypeCode == Helper.GetCellValue(typeCell) && s.ItemCode == Helper.GetCellValue(itemCodeCell));
        //                        if (currentRowSalesEntryFromDB != null)
        //                        {
        //                            var currentRowSalesEntryPriceQtyFromDB = currentRowSalesEntryFromDB.SalesEntryPriceQuantity;
        //                            if (currentRowSalesEntryPriceQtyFromDB != null && currentRowSalesEntryPriceQtyFromDB.Count() > 0)
        //                            {
        //                                for (int colIndex = 0; colIndex <= currentRowCellCount; colIndex++)
        //                                {
        //                                    if (monthNamesFromFile.ContainsKey(colIndex))
        //                                    {
        //                                        var currentRowMonth = monthNamesFromFile.First(m => m.Key == colIndex);
        //                                        if (colIndex > typeColumnIndex + 1 && colIndex < adl1ColumnIndex)
        //                                        {
        //                                            var currentQtyMonth = currentRowSalesEntryPriceQtyFromDB.FirstOrDefault(s => s.QtyMonthName == currentRowMonth.Value);
        //                                            if (currentQtyMonth != null)
        //                                            {
        //                                                ICell cell = currentRow.GetCell(colIndex);
        //                                                SetNumericCellValue(cell, currentQtyMonth.Qty);
        //                                            }

        //                                        }
        //                                        else if (colIndex == priceColumnIndex)
        //                                        {
        //                                            ICell cell = currentRow.GetCell(colIndex);
        //                                            if (isUSDCurrency == true)
        //                                            {
        //                                                SetCellValue(cell, "USD");
        //                                            }
        //                                            else
        //                                            {
        //                                                if (Helper.GetCellValue(typeCell) == "P" || Helper.GetCellValue(typeCell) == "S" || Helper.GetCellValue(typeCell) == "I")
        //                                                {
        //                                                    SetCellValue(cell, customerWithLocalCurrency.CurrencyCode);
        //                                                }
        //                                                //else
        //                                                //{
        //                                                //    //SetCellValue(cell, "AED");
        //                                                //}

        //                                            }

        //                                        }
        //                                        else if (colIndex > adl2ColumnIndex && colIndex < adl3ColumnIndex)
        //                                        {
        //                                            var currentPriceMonth = currentRowSalesEntryPriceQtyFromDB.FirstOrDefault(s => s.PriceMonthName == currentRowMonth.Value);
        //                                            if (currentPriceMonth != null)
        //                                            {
        //                                                //var convertedPrice = GetConvertedPrice(currentPriceMonth.Price, currentRowSalesEntryFromDB.TypeCode, customerWithLocalCurrency.ExchangeRate, usdCurrency.ExchangeRate, isUSDCurrency);
        //                                                ICell cell = currentRow.GetCell(colIndex);
        //                                                SetCellValue(cell, currentPriceMonth.Price.ToString());
        //                                            }
        //                                        }
        //                                    }
        //                                }
        //                            }
        //                        }
        //                    }
        //                }
        //                isReadAndWriteSuccess = true;
        //            }
        //            workbook.Write(returnStream, false);
        //            workbook.Close();
        //        }
        //        if (isReadAndWriteSuccess)
        //        {
        //            var result = new SalesEntryDownloadFileResult
        //            {
        //                FileContent = returnStream.ToArray(),
        //                FileName = sheetName + "-" + DateTime.Now.ToString("MMMyyyy"),
        //                FileExtension = fileExtension,
        //            };
        //            return Result.SuccessWith(result);
        //        }
        //        else
        //        {
        //            return Result.Failure("Unable to read latest file!");
        //        }
        //    }
        //    else
        //    {
        //        return Result.Failure("Unable to read latest file!");
        //    }
        //}


        /// <summary>
        /// Get SaleEntry Quantity and Price Data
        /// </summary>
        /// <param name="directSalesDownload"></param>
        /// <param name="localCurrencyExchangeRate"></param>
        /// <param name="usdCurrencyExchangeRate"></param>
        /// <param name="isUSDCurrency"></param>
        /// <param name="attachmentFileName"></param>
        /// <param name="fileExtension"></param>
        private List<SalesEntryCommand> GetSaleEntryData(DirectSalesDownload directSalesDownload, decimal? localCurrencyExchangeRate, decimal? usdCurrencyExchangeRate, bool isUSDCurrency,
            out string attachmentFileName, out string fileExtension)
        {
            var result = new List<SalesEntryCommand>();
            attachmentFileName = "";
            fileExtension = "";
            directSalesDownload.SaleTypeId = 1;
            //var saleEntryHeaders = _saleEntryRepository.GetSaleEntries(directSalesDownload);
            List<VW_SalesEntryMaterial> saleEntries = new List<VW_SalesEntryMaterial>();
            //List<int> salesEntryIds = saleEntryHeaders.Select(x => x.SalesEntryId).ToList();

            if (directSalesDownload.ProductSubCategoryId != "null")
            {
                saleEntries = _context.VW_SalesEntryMaterial.Where(x => x.MG2 == Convert.ToInt16(directSalesDownload.ProductCategoryId) && x.ProductCategoryId3 == Convert.ToInt16(directSalesDownload.ProductSubCategoryId)
                && x.CustomerId == directSalesDownload.CustomerId && x.SaleTypeId == directSalesDownload.SaleTypeId && x.SaleSubType == directSalesDownload.SaleSubType
            && Convert.ToInt32(x.MonthYear) >= directSalesDownload.FromMonth && Convert.ToInt32(x.MonthYear) <= directSalesDownload.ToMonth).ToList();
            }
            else
            {

                saleEntries = _context.VW_SalesEntryMaterial.Where(x => x.MG2 == Convert.ToInt16(directSalesDownload.ProductCategoryId) && x.CustomerId == directSalesDownload.CustomerId && x.SaleTypeId == directSalesDownload.SaleTypeId && x.SaleSubType == directSalesDownload.SaleSubType
            && Convert.ToInt32(x.MonthYear) >= directSalesDownload.FromMonth && Convert.ToInt32(x.MonthYear) <= directSalesDownload.ToMonth).ToList();
            }
            if (saleEntries.Count() > 0)
            {

                var saleEntryHeader = saleEntries.First();
                var previousSaleEntryHeader = saleEntries.OrderByDescending(c => c.SalesEntryId).FirstOrDefault(c => c.SalesEntryId != saleEntryHeader.SalesEntryId);
                if (saleEntryHeader.AttachmentId != null && directSalesDownload.IsDownload)
                {
                    var attachment = _attachmentRepository.GetAttachmentById(saleEntryHeader.AttachmentId.Value);
                    if (attachment != null)
                    {
                        attachmentFileName = attachment.VirtualFileName;
                        fileExtension = attachment.Extension;
                    }

                }

                //var materials = _materialRepository.GetMaterials();
                var modeOfTypes = _modeofTypeRepository.GetAll();

                //var saleEntries = _saleEntryRepository.Get(saleEntryHeader.SaleEntryHeaderId);
                var saleEntryIds = saleEntries.Select(s => s.SalesEntryId).ToList();
                var previousSaleEntries = new List<SalesEntry>();
                var previousSaleEntryIds = new List<int>();
                //if(previousSaleEntryHeader != null){
                //    previousSaleEntries = _saleEntryRepository.Get(previousSaleEntryHeader.SaleEntryHeaderId);
                //    previousSaleEntryIds = previousSaleEntries.Select( s => s.SalesEntryId ).ToList();
                //}
                if (saleEntryIds.Any())
                {
                    var saleEntryPriceQuantities = _saleEntryRepository.Get(saleEntryIds, directSalesDownload.FromMonth, directSalesDownload.ToMonth).ToList();
                    var previousSaleEntryPriceQuantities = new List<SalesEntry>();
                    //if (previousSaleEntryHeader != null && previousSaleEntryIds.Any())
                    //{
                    //    previousSaleEntryPriceQuantities = _salePriceQuantityRepository.Get(previousSaleEntryIds,directSalesDownload.FromMonth,directSalesDownload.ToMonth).Where(c=> c.OCstatus == "Y").ToList();
                    //}
                    foreach (var saleEntry in saleEntries)
                    {
                        if (directSalesDownload.ProductSubCategoryId != "null")
                        {

                        }
                        else
                        {

                        }
                        //var material = materials.FirstOrDefault(m => m.MaterialId == saleEntry.MaterialId);
                        var modeOfType = modeOfTypes.FirstOrDefault(m => m.ModeofTypeId == saleEntry.ModeOfTypeId);
                        var saleEntryCommand = new SalesEntryCommand
                        {
                            //SaleEntryHeaderId = saleEntryHeader.SaleEntryHeaderId,
                            SaleEntryId = saleEntry.SalesEntryId,
                            ItemCode = saleEntry.MaterialCode,
                            TypeCode = modeOfType?.ModeofTypeCode ?? "",
                            SalesEntryPriceQuantity = new List<SalesEntryPriceQuantityCommand>()
                        };

                        var itemSaleEntryPriceQuantities = saleEntryPriceQuantities.Where(s => s.SalesEntryId == saleEntry.SalesEntryId).ToList();
                        var itemPreviousSaleEntryPriceQuantities = new List<SalesEntry>();
                        var _pSaleEntry = previousSaleEntries.FirstOrDefault(c => c.MaterialId == saleEntry.MaterialId && c.ModeOfTypeId == saleEntry.ModeOfTypeId);
                        if (_pSaleEntry != null)
                        {
                            itemPreviousSaleEntryPriceQuantities = previousSaleEntryPriceQuantities.Where(s => s.SalesEntryId == _pSaleEntry.SalesEntryId).ToList();
                        }

                        saleEntryCommand.SalesEntryPriceQuantity = FillSaleEntryPriceQty(itemSaleEntryPriceQuantities, itemPreviousSaleEntryPriceQuantities, saleEntryCommand.TypeCode, localCurrencyExchangeRate, usdCurrencyExchangeRate, isUSDCurrency);

                        result.Add(saleEntryCommand);
                    }
                }
            }
            return result;
        }

        /// <summary>
        /// Fill Sale Entry Price Qty model
        /// </summary>
        /// <param name="salesEntryPriceQuantities"></param>
        /// <param name="previousSalesEntryPriceQuantities"></param>
        /// <param name="typeCode"></param>
        /// <param name="localCurrencyExchangeRate"></param>
        /// <param name="usdCurrencyExchangeRate"></param>
        /// <param name="isUSDCurrency"></param>
        /// <returns></returns>
        private List<SalesEntryPriceQuantityCommand> FillSaleEntryPriceQty(List<SalesEntry> salesEntryPriceQuantities, List<SalesEntry> previousSalesEntryPriceQuantities,
        string typeCode, decimal? localCurrencyExchangeRate, decimal? usdCurrencyExchangeRate, bool isUSDCurrency)
        {
            var result = new List<SalesEntryPriceQuantityCommand>();
            salesEntryPriceQuantities.ForEach(s =>
            {
                var monthYear = ConvertSaleEntryDateFormat(s.MonthYear ?? "");
                if (s.OCstatus == "Y")
                {
                    var convertedPrice = GetConvertedPrice(s.Price ?? 0, typeCode, localCurrencyExchangeRate, usdCurrencyExchangeRate, isUSDCurrency);
                    result.Add(new SalesEntryPriceQuantityCommand()
                    {
                        PriceMonthName = monthYear + "-P",
                        Price = convertedPrice,
                        QtyMonthName = monthYear + "-Q",
                        Qty = s.Quantity ?? 0,
                        MonthYear = monthYear,
                        Currency = isUSDCurrency == true ? "USD" : s.CurrencyCode
                    });
                }
                else
                {
                    var saleQtyPrice = previousSalesEntryPriceQuantities.FirstOrDefault(c => c.MonthYear == s.MonthYear);
                    if (saleQtyPrice != null)
                    {
                        var convertedPrice = GetConvertedPrice(saleQtyPrice.Price ?? 0, typeCode, localCurrencyExchangeRate, usdCurrencyExchangeRate, isUSDCurrency);
                        result.Add(new SalesEntryPriceQuantityCommand()
                        {
                            PriceMonthName = monthYear + "-P",
                            Price = convertedPrice,
                            QtyMonthName = monthYear + "-Q",
                            Qty = saleQtyPrice.Quantity ?? 0,
                            MonthYear = monthYear,
                            Currency = isUSDCurrency == true ? "USD" : s.CurrencyCode
                        });
                    }
                }
            });
            return result;
        }

        /// <summary>
        /// Convert Sale Entry Date Format
        /// </summary>
        /// <param name="monthName"></param>
        /// <param name="type"></param>
        /// <returns></returns>
        private string ConvertSaleEntryDateFormat(string monthName)
        {
            var result = "";
            if (!string.IsNullOrEmpty(monthName))
            {
                Regex rgMonth = new Regex(@"^\d{6}$");
                if (rgMonth.IsMatch(monthName))
                {
                    DateTime dt;
                    bool isValidDate = DateTime.TryParseExact(monthName + "01", "yyyyMMdd", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt);
                    if (isValidDate)
                    {
                        result = dt.ToString("MMM-yy");
                    }
                }
            }
            return result;
        }

        /// <summary>
        /// Set Excel Cell Value
        /// </summary>
        /// <param name="cell"></param>
        /// <param name="value"></param>
        private void SetCellValue(ICell cell, string value)
        {
            if (cell != null)
            {
                cell.SetCellType(CellType.Numeric);
                cell.SetCellValue(value);
            }
        }
        private void SetNumericCellValue(ICell cell, Int32 value)
        {
            if (cell != null)
            {
                cell.SetCellType(CellType.Numeric);
                cell.SetCellValue(value);
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
            out int uploadFlagIndex, out int adl1ColumnIndex, out int adl2ColumnIndex, out int adl3ColumnIndex, out int typeColumnIndex,
           out int itemCodeColumnIndex, out Dictionary<int, string> monthNamesFromFile, out int priceColumnIndex)
        {
            uploadFlagIndex = 0;
            adl1ColumnIndex = 0;
            adl2ColumnIndex = 0;
            adl3ColumnIndex = 0;
            typeColumnIndex = 0;
            itemCodeColumnIndex = 0;
            priceColumnIndex = 0;
            monthNamesFromFile = new Dictionary<int, string>();

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
                        case Contants.DirectSale_Header_Item_code:
                            itemCodeColumnIndex = colIndex;
                            break;
                        case Contants.DirectSale_Header_Price_code:
                            priceColumnIndex = colIndex;
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
            for (int index = typeColumnIndex + 2; index < headerRowCellCount; index++)
            {
                ICell cell = headerRow.GetCell(index);
                monthNamesFromFile.Add(index, Convert.ToString(cell));
            }

        }

        /// <summary>
        /// Get Customer With Currency
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

        /// <summary>
        /// Get Converted Price
        /// </summary>
        /// <param name="price"></param>
        /// param name="modeOfType"></param>
        /// param name="localExchangeRate"></param>
        /// param name="usdExchangeRate"></param>
        /// param name="isUSDCurreny"></param>
        /// <returns></returns>
        private decimal GetConvertedPrice(decimal price, string modeOfType, decimal? localExchangeRate, decimal? usdExchangeRate, bool isUSDCurreny)
        {
            if (isUSDCurreny && (modeOfType == "P" || modeOfType == "S" || modeOfType == "I"))
            {
                return usdExchangeRate.HasValue ? Math.Round(usdExchangeRate.Value * price, 2) : price;
            }
            //else if(!isUSDCurreny && (modeOfType == "O" || modeOfType == "ADJ" || modeOfType == "MPO")){
            //    return localExchangeRate.HasValue ? Math.Round(localExchangeRate.Value * price, 2) : price;
            //}
            return price;
        }
        //private Result PrepareSalesEntryDataBP(List<SP_SALES_DOWNLOAD_BP> salesEntries, string currency)
        //{
        //    var result = new List<SalesEntryDownloadResult>();
        //    foreach (var sale in salesEntries)
        //    {
        //        if (currency == "USD")
        //        {
        //            //foreach (var saleEntry in sale.SalesEntryPriceQuantity)
        //            //{
        //                result.Add(new SalesEntryDownloadResult
        //                {
        //                    ItemCode = sale.ItemCode,
        //                    ModeOfType = sale.TypeCode,
        //                    MonthYear = sale.MonthYear,
        //                    Quantity = sale.Qty,
        //                    Price = sale.Price,
        //                    Currency = currency,
        //                    Amount = Math.Round(sale.Qty * sale.Price, 2),
        //                });
        //            //}
        //        }
        //        else
        //        {

        //                result.Add(new SalesEntryDownloadResult
        //                {
        //                    ItemCode = sale.ItemCode,
        //                    ModeOfType = sale.TypeCode,
        //                    MonthYear = sale.MonthYear,
        //                    Quantity = sale.Qty,
        //                    Price = sale.Price,
        //                    Currency = sale.Currency,
        //                    Amount = Math.Round(sale.Qty * sale.Price, 2),
        //                });

        //        }

        //    }
        //    return Result.SuccessWith(result);
        //}
        private Result PrepareSalesEntryData(List<SalesEntryCommand> salesEntries, string currency)
        {
            var result = new List<SalesEntryDownloadResult>();
            foreach (var sale in salesEntries)
            {
                if (currency == "USD")
                {
                    foreach (var saleEntry in sale.SalesEntryPriceQuantity)
                    {
                        result.Add(new SalesEntryDownloadResult
                        {
                            ItemCode = sale.ItemCode,
                            ModeOfType = sale.TypeCode,
                            MonthYear = saleEntry.MonthYear,
                            Quantity = saleEntry.Qty,
                            Price = saleEntry.Price,
                            Currency = currency,
                            Amount = Math.Round(saleEntry.Qty * saleEntry.Price, 2),
                        });
                    }
                }
                else
                {
                    foreach (var saleEntry in sale.SalesEntryPriceQuantity)
                    {
                        result.Add(new SalesEntryDownloadResult
                        {
                            ItemCode = sale.ItemCode,
                            ModeOfType = sale.TypeCode,
                            MonthYear = saleEntry.MonthYear,
                            Quantity = saleEntry.Qty,
                            Price = saleEntry.Price,
                            Currency = saleEntry.Currency,
                            Amount = Math.Round(saleEntry.Qty * saleEntry.Price, 2),
                        });
                    }
                }

            }
            return Result.SuccessWith(result);
        }
    }
}
