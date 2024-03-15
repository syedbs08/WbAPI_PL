using AttachmentService;
using AttachmentService.Repository;
using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.AspNetCore.Components.Forms;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Constants;
using PSI.Modules.Backends.Masters.Repository.AttachmentMaster;
using PSI.Modules.Backends.Masters.Repository.ProductCategoryMaster;
using PSI.Modules.Backends.SNS.Command;
using PSI.Modules.Backends.SNS.Repository;
using PSI.Modules.Backends.SNS.Results;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.SNS.CommandHandler
{
    public partial class SNSEntryDownloadHandler : IRequestHandler<SNSEntryDownloadCommand, Result>
    {
        private readonly IProductCategoryRepository _productCategoryRepository;
        private readonly ISPSNSEntryDownloadRepository _snsEntryRepository;
        private readonly IAttachmentRepository _attachmentRepository;
        private readonly ISNSEntryQtyPriceRepository _snsEntryQtyPriceRepository;
        private readonly IAttachmentService _attachmentService;
        private readonly IGlobalConfigRepository _globalConfigRepository;
        public SNSEntryDownloadHandler(IProductCategoryRepository productCategoryRepository, ISPSNSEntryDownloadRepository snsEntryRepository,
            ISNSEntryQtyPriceRepository snsEntryQtyPriceRepository, IAttachmentRepository attachmentRepository, IAttachmentService attachmentService
            , IGlobalConfigRepository globalConfigRepository)
        {

            _productCategoryRepository = productCategoryRepository;
            _snsEntryRepository = snsEntryRepository;
            _snsEntryQtyPriceRepository = snsEntryQtyPriceRepository;
            _attachmentRepository = attachmentRepository;
            _attachmentService = attachmentService;
            _globalConfigRepository = globalConfigRepository;
        }

        public async Task<Result> Handle(SNSEntryDownloadCommand request, CancellationToken cancellationToken)
        {
            try
            {

                if (request.SNSEntryDownload.IsDownload)
                {
                    var SNSEntryData = _snsEntryRepository.GetSNSEntryQtyPriceForDownload(request.SNSEntryDownload).ToList();

                    string attachmentFileName = "SNS_Upload.xlsx";
                    string fileExtension = ".xlsx";
                    if (SNSEntryData.Count() > 0)
                    {

                        var SNSEntryDataHeader = SNSEntryData.First();
                        var sheetName = request.SNSEntryDownload.OACCode;
                        int rowNum = 3;
                        List<SNSEntriesCommand> snsEntriesCommand = new List<SNSEntriesCommand>();
                        foreach (var lstSNS in SNSEntryData)
                        {
                            var SNSEntriesCommand = new SNSEntriesCommand()
                            {
                                SNSEntryId = (int)lstSNS.Id,
                                CustomerCode = lstSNS.CustomerCode,
                                CustomerName = lstSNS.CustomerName,
                                Category = lstSNS.ProductCategoryName2,
                                MaterialCode = lstSNS.MaterialCode,
                                MonthYear = Convert.ToString(lstSNS.MonthYear),
                                OACCode = request.SNSEntryDownload.OACCode,
                                SaleSubType = request.SNSEntryDownload.SaleSubType,
                                Qty = lstSNS.Quantity,
                                Price = lstSNS.Price,
                                RowNum = rowNum,
                            };
                            rowNum++;
                            snsEntriesCommand.Add(SNSEntriesCommand);
                        }
                        return await PrepareSheetWithNewData(snsEntriesCommand, attachmentFileName, sheetName, fileExtension, request.SNSEntryDownload.SaleSubType);

                    }

                    return Result.Failure("Data not found!");
                }
                else
                {
                    var SNSEntryDetails = _snsEntryRepository.GetSNSEntryQtyPriceForDownload(request.SNSEntryDownload).ToList();
                    return Result.SuccessWith(SNSEntryDetails);

                }
            }
            catch (Exception ex)
            {

                Log.Error($"Error in downloading d file with Message - {ex.Message}. StackTrace - {ex.StackTrace}");
                return Result.Failure(Contants.ERROR_MSG);
            }

        }
        private List<SNSEntriesQtyPriceDownload> ValidateAndUpdateQtyPriceMonthYear(List<SNSEntryQtyPrice> lstQtyPrice)
        {

            List<SNSEntriesQtyPriceDownload> lstResultData = new List<SNSEntriesQtyPriceDownload>();
            lstQtyPrice.ForEach(x =>
            {
                var monthYear = ConvertSNSEntryDateFormat(x.MonthYear);
                lstResultData.Add(new SNSEntriesQtyPriceDownload()
                {
                    Qty = x.Qty,
                    Price = x.Price,
                    FinalPrice = x.FinalPrice,
                    TotalAmount = x.TotalAmount,
                    MonthYear = monthYear,
                    QtyMonthYear = monthYear + "-Qty",
                    PriceMonthYear = monthYear + "-Price",
                });


            });

            return lstResultData;
        }

        private string ConvertSNSEntryDateFormat(string monthName)
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
                        result = dt.ToString("MMM yyyy");
                    }
                }
            }
            return result;
        }

        private async Task<Result> PrepareSheetWithNewData(List<SNSEntriesCommand> SNSEntriesCommand, string attachmentFilePath, string sheetName, string fileExtension, string saleType)
        {
            var stream = await _attachmentService.GetFileStream(attachmentFilePath, Contants.sample_files_upload_folder);
            //sheetName = psiYear.ConfigValue;
            var returnStream = new MemoryStream();
            var fileExt = Path.GetExtension(attachmentFilePath);
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
                    var samplesheetName = "00029956";
                    var expectedSheetIndex = sheetNames.FindIndex(c => c == samplesheetName);
                    if (expectedSheetIndex != -1)
                    {
                        currentWorksheet = workbook.GetSheetAt(expectedSheetIndex);
                        var lastRowIndexToRead = currentWorksheet.LastRowNum;
                        var monthNamesFromFile = new Dictionary<int, string>();
                        var ignoreColumnsIndices = new List<int>() { };



                        int rowToReadFrom = 2;
                        var headerRow = currentWorksheet.GetRow(rowToReadFrom);
                        int headerRowCellCount = headerRow.LastCellNum;
                        //Read Body Content
                        //Cell for Qty
                        int startQtyIndex = 4;
                        int endQtryIndex = 18;
                        //Cell for Price
                        int startPriceIndex = 20;
                        int endPriceIndex = 34;

                        int cellIndex = 0;

                        //Check data and Sheet Row
                        int TotalRow = (lastRowIndexToRead + 1) - 3;

                        int totalRowFromDB = SNSEntriesCommand
    .Select(x => new { x.CustomerCode, x.MaterialCode }) // Create an anonymous type with the properties to group by
    .Distinct()
    .Count();
                        if (totalRowFromDB > TotalRow)
                        {

                            lastRowIndexToRead = totalRowFromDB + 3;
                            currentWorksheet.CreateRow(lastRowIndexToRead);


                        }

                        //Delete all rows after 4 .

                        int totalrow = 0;

                        for (int rowIndex = rowToReadFrom + 1; rowIndex <lastRowIndexToRead; rowIndex++)
                        {
                            // var lstRowDetails = SNSEntriesCommand.Where(x => x.RowNum == rowIndex).FirstOrDefault();
                            var resdistinct = SNSEntriesCommand
    .Select(x => new { x.CustomerCode, x.MaterialCode }) // Create an anonymous type with the properties to group by
    .Distinct().OrderBy(x => x.CustomerCode).ToList();
                           var res = resdistinct.ElementAt(totalrow);
                            totalrow=totalrow+1;
                            var lstRowDetails = SNSEntriesCommand.Where(x => x.MaterialCode == res.MaterialCode && x.CustomerCode == res.CustomerCode).FirstOrDefault();
                            //currentWorksheet.CopyRow(3, rowIndex+1);


                            //Update Cell
                            var currentRow = currentWorksheet.GetRow(rowIndex);
                            if (currentRow == null)
                            {
                                currentWorksheet.CopyRow(rowIndex - 1, rowIndex);
                                currentRow = currentWorksheet.GetRow(rowIndex);
                            }
                            if (lstRowDetails != null)
                            {


                                ICell cellCustomerCode = currentRow.GetCell(0);//Customer Update
                                SetCellValue(cellCustomerCode, lstRowDetails.CustomerCode);

                                ICell cellCustomerName = currentRow.GetCell(1);//Customer Update
                                SetCellValue(cellCustomerName, lstRowDetails.CustomerName);
                                ICell cellCategory = currentRow.GetCell(2);//Customer Update
                                SetCellValue(cellCategory, lstRowDetails.Category);
                                ICell cellMaterialCode = currentRow.GetCell(3);//Customer Update
                                SetCellValue(cellMaterialCode, lstRowDetails.MaterialCode);

                            }
                            else
                            {

                                currentWorksheet.RemoveRow(currentRow);
                            }

                            //Update Qty Cell
                            var currentHeaderRow = currentWorksheet.GetRow(rowToReadFrom);


                            for (int qtyHeader = startQtyIndex; qtyHeader <= endQtryIndex; qtyHeader++)
                            {
                                if (lstRowDetails == null)
                                {
                                }
                                else
                                {
                                    ICell cellQtyHeader = currentHeaderRow.GetCell(qtyHeader);
                                    var cellQtyHeaderValue = GetCellValue(cellQtyHeader);
                                    DateTime date = DateTime.ParseExact(cellQtyHeaderValue.Split("-")[0], "MMM yyyy", System.Globalization.CultureInfo.InvariantCulture);
                                    // Format the date as YYYYMM
                                    string formattedDate = date.ToString("yyyyMM");
                                    var currentQtyValue = SNSEntriesCommand.Where(x => x.CustomerCode == lstRowDetails.CustomerCode && x.MaterialCode == lstRowDetails.MaterialCode && x.MonthYear == formattedDate).FirstOrDefault();
                                    if (currentQtyValue != null)
                                    {
                                        ICell cellQtyCell = currentRow.GetCell(qtyHeader);//Customer Update
                                        SetCellValueAsNumeric(cellQtyCell, Convert.ToDouble(currentQtyValue.Qty));

                                    }
                                }
                            }
                            //Update Qty Cell
                            for (int priceHeader = startPriceIndex; priceHeader <= endPriceIndex; priceHeader++)
                            {
                                if (lstRowDetails == null)
                                {
                                }
                                else
                                {
                                    ICell cellPriceHeader = currentHeaderRow.GetCell(priceHeader);
                                    var cellPriceHeaderValue = GetCellValue(cellPriceHeader);
                                    DateTime date = DateTime.ParseExact(cellPriceHeaderValue.Split("-")[0], "MMM yyyy", System.Globalization.CultureInfo.InvariantCulture);
                                    // Format the date as YYYYMM
                                    string formattedDate = date.ToString("yyyyMM");
                                    var currentPriceValue = SNSEntriesCommand.Where(x => x.CustomerCode == lstRowDetails.CustomerCode && x.MaterialCode == lstRowDetails.MaterialCode && x.MonthYear == formattedDate).FirstOrDefault();
                                    if (currentPriceValue != null)
                                    {
                                        ICell cellPriceCell = currentRow.GetCell(priceHeader);//Customer Update
                                                                                              //SetCellValue(cellQtyCell, Convert.ToString(currentPriceValue.Price));
                                        SetCellValueAsNumeric(cellPriceCell, Convert.ToDouble(currentPriceValue.Price));

                                    }
                                }

                            }
                        }


                        isReadAndWriteSuccess = true;
                    }
                    XSSFSheet sheet = (XSSFSheet)workbook.GetSheetAt(0);
                    workbook.SetSheetName(workbook.GetSheetIndex(sheet), sheetName);
                    if (workbook is XSSFWorkbook)
                    {
                        XSSFFormulaEvaluator.EvaluateAllFormulaCells(workbook);
                    }
                    else
                    {
                        HSSFFormulaEvaluator.EvaluateAllFormulaCells(workbook);
                    }
                
                    workbook.Write(returnStream, false);
                    workbook.Close();

                }
                if (isReadAndWriteSuccess)
                {
                    var result = new SNSEntryDownloadFileResult
                    {
                        FileContent = returnStream.ToArray(),
                        FileName = sheetName + "-" + DateTime.Now.ToString("MMMyyyy") + "-" + saleType,
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

        /// <summary>
        /// Set Excel Cell Value
        /// </summary>
        /// <param name="cell"></param>
        /// <param name="value"></param>
        private void SetCellValue(ICell cell, string value)
        {
            if (cell != null)
            {
                var cetype = cell.CellType;
                cell.SetCellType(CellType.Numeric);
                cell.SetCellValue(value);
            }
        }
        private void SetCellValueAsNumeric(ICell cell, double value)
        {
            if (cell != null)
            {
                var cetype = cell.CellType;
                cell.SetCellType(CellType.Numeric);
                cell.SetCellValue(value);
            }
        }

        private string GetCellValue(ICell cell)
        {
            string value = string.Empty;
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

            return value;

        }

    }
}
