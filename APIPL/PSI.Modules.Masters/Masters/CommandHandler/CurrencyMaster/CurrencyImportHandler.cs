using AttachmentService;
using AttachmentService.Result;
using Core.BaseUtility.Utility;
using MediatR;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Helpers;
using PSI.Modules.Backends.Masters.Command.CurrencyMaster;
using PSI.Modules.Backends.Masters.Repository.CurrencyMaster;
using Log = Core.BaseUtility.Utility.Log;

namespace PSI.Modules.Backends.Masters.CommandHandler.CurrencyMaster
{
    public class CurrencyImportHandler : IRequestHandler<ImportCurrencyCommand, Result>
    {
        private readonly ICurrencyRepository _currencyRepository;
        private readonly IAttachmentService _attachmentService;
        public CurrencyImportHandler(
            ICurrencyRepository currencyRepository,
            IAttachmentService attachmentService)
        {
            _currencyRepository = currencyRepository;
            _attachmentService = attachmentService;
        }
        public async Task<Result> Handle(ImportCurrencyCommand request, CancellationToken cancellationToken)
        {
            try
            {
                var uploadedResult = await _attachmentService.UploadFiles(request.Command, request.Session, true);
                if (uploadedResult == null)
                { 
                    return Result.Failure("Error while uploading currency in blob");
                }
                var result = ReadCurrencyExcel(request, uploadedResult);
                return result;

            }
            catch (Exception ex)
            {
                Log.Error($"Execption occured while uploading Currency ", ex.Message);
                return Result.Failure("Problem in adding Currency ,try later");
            }
        }
        private Result ReadCurrencyExcel(ImportCurrencyCommand command,
            FileUploadResult fileData)
        {
            var file = command.Command.File;

            var fileExt = Path.GetExtension(file.FileName);
            IWorkbook workbook = null;
            MemoryStream fs = new MemoryStream(fileData.FileBytes);
            ISheet sheet;
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
                sheet = workbook.GetSheetAt(0);
                if (sheet != null)
                {
                    if (sheet.GetRow(0).Cells.Count != 3)
                    {
                        return Result.Failure("Invalid Excel Template has been selected to upload currency");
                    }
                    var currencyData = GetSheetData(sheet, fileData.Id, command.Session);
                    var validateResult = ValidateExcel(currencyData);
                    if (validateResult.Length > 0)
                    {
                        return Result.Failure(validateResult);
                    }

                    var existCurrency = _currencyRepository.GetAll();
                    var currencyToAdd = currencyData.Where(x => !existCurrency.Any(y => y.CurrencyCode == x.CurrencyCode));
                    var recordToUpdate = existCurrency.Where(x => currencyData.Any(y => y.CurrencyCode == x.CurrencyCode)).ToList();
                    if (currencyToAdd.Any())
                    {
                        _currencyRepository.AddBulk(currencyToAdd.ToList());
                    }
                    if (recordToUpdate.Any())
                    {
                        foreach (var item in recordToUpdate)
                        {
                            item.ExchangeRate= currencyData.FirstOrDefault(x => x.CurrencyCode == item.CurrencyCode).ExchangeRate;
                            item.UpdateDate=DateTime.Now;
                        }
                       
                      _currencyRepository.UpdateBulk(recordToUpdate);

                    }
                    return Result.Success;
                }
                return Result.Failure("Invalid Excel Template has been selected to upload currency");
            }
            return Result.Success;
        }
        private string[] ValidateExcel(List<Currency> currencyList)
        {
            List<string> errors = new List<string>();
            int firstIndex = 2;
            foreach (var currency in currencyList)
            {
                int row = Convert.ToInt32(currencyList.IndexOf(currency)) + firstIndex;
                if (currency.CurrencyName!=null  && currency.CurrencyCode != null && currency.ExchangeRate != 0)
                {
                   
                    if (string.IsNullOrWhiteSpace(currency.CurrencyName))
                    {
                        errors.Add("Currency name must be entered at row " + row);

                    }
                    if (string.IsNullOrWhiteSpace(currency.CurrencyCode))
                    {
                        errors.Add("Currency code must be entered at row " + row);

                    }
                    if (currency.ExchangeRate == null)
                    {
                        errors.Add("exchange rate must be entered at row " + row);

                    }
                }
             
            }
            var removeList = currencyList.Where(x => x.CurrencyCode == "" || x.CurrencyName == "" || x.ExchangeRate == 0).ToList();
            currencyList.RemoveAll(x => removeList.Contains(x));

            if (currencyList.Count != currencyList.DistinctBy(x=>x.CurrencyCode).Count())
            {
                errors.Add("Duplicate currency code found in the excel sheet ");
            }
            return errors.ToArray();

        }
        private List<Currency> GetSheetData(ISheet excelSheet, int attachmentId, SessionData session)
        {
            var currencyList = new List<Currency>();
            int firstRowIndex = 1; //set startting row
            for (int row = firstRowIndex; row <= excelSheet.LastRowNum; row++)
            {

                if (excelSheet.GetRow(row) != null) //null is when the row only contains empty cells 
                {
                    var currency = new Currency();
                    currency.AttachmentId = attachmentId;
                    currency.CurrencyName = excelSheet.GetRow(row).GetCell(0).StringCellValue;
                    currency.CurrencyCode = excelSheet.GetRow(row).GetCell(1).StringCellValue;
                    currency.ExchangeRate = Helper.ConvertStringToDecimal(excelSheet.GetRow(row)
                                             .GetCell(2).NumericCellValue.ToString());
                    currency.CreatedBy = session.ADUserId;
                    currency.UpdateBy = session.ADUserId;
                    currency.UpdateDate = DateTime.Now;
                    currency.CreatedDate = DateTime.Now;
                    currencyList.Add(currency);
                }
            }
            return currencyList;

        }

    }
}
