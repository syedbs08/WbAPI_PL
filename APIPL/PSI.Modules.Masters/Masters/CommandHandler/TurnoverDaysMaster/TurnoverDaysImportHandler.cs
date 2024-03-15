using AttachmentService.Result;
using AttachmentService;
using Core.BaseUtility.Utility;
using MediatR;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Helpers;
using PSI.Modules.Backends.Masters.Command.TurnoverDaysMaster;
using PSI.Modules.Backends.Masters.Repository.TurnoverDaysMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PSI.Modules.Backends.Masters.Repository.AccountMaster;

namespace PSI.Modules.Backends.Masters.CommandHandler.TurnoverDaysMaster
{
    public class TurnoverDaysImportHandler : IRequestHandler<ImportTurnoverDaysCommand, Result>
    {
        private readonly ITurnoverDaysRepository _turnoverDaysRepository;
        private readonly IAttachmentService _attachmentService;
        private readonly IAccountRepository _accountRepository;
        public TurnoverDaysImportHandler(
            ITurnoverDaysRepository turnoverDaysRepository,
            IAttachmentService attachmentService,
            IAccountRepository accountRepository)
        {
            _turnoverDaysRepository = turnoverDaysRepository;
            _attachmentService = attachmentService;
            _accountRepository = accountRepository;
        }
        public async Task<Result> Handle(ImportTurnoverDaysCommand request, CancellationToken cancellationToken)
        {
            try
            {
                var uploadedResult = await _attachmentService.UploadFiles(request.Command, request.Session, true);
                if (uploadedResult == null)
                {
                    return Result.Failure("Error while uploading turnoverDays in blob");
                }
                var result = ReadTurnoverDaysExcel(request, uploadedResult);
                if (result.IsSuccess)
                {
                    Task.Run(() => _attachmentService.ActivateFile(uploadedResult.Id));

                }
                return result;

            }
            catch (Exception ex)
            {
                Log.Error($"Execption occured while uploading TurnoverDays ", ex.Message);
                return Result.Failure("Problem in adding TurnoverDays ,try later or contact to support team");
            }
        }
        private Result ReadTurnoverDaysExcel(ImportTurnoverDaysCommand command,
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
                    if (sheet.GetRow(0).Cells.Count != 6)
                    {
                        return Result.Failure("Invalid Excel Template has been selected to upload turnoverDays");
                    }
                    var accounts = _accountRepository.GetAll();
                    var turnoverDaysData = GetSheetData(sheet, fileData.Id, command.Session, accounts.ToList());
                    var validateResult = ValidateExcel(turnoverDaysData);
                    if (validateResult.Length > 0)
                    {
                        return Result.Failure(validateResult);
                    }
                    var existTurnoverDays = _turnoverDaysRepository.GetAll();
                    var turnoverDaysToAdd = turnoverDaysData.Where(x => !existTurnoverDays.Any(y => y.SubGroupProductCategoryCode == x.SubGroupProductCategoryCode
                                                                                                && y.Month == x.Month
                                                                                                && y.AccountId == x.AccountId));
                    var recordToUpdate = existTurnoverDays.Where(x => turnoverDaysData.Any(y =>
                                                                        y.SubGroupProductCategoryCode == x.SubGroupProductCategoryCode
                                                                        && y.Month == x.Month
                                                                        && y.AccountId == x.AccountId)).ToList();
                    if (turnoverDaysToAdd.Any())
                    {
                        _turnoverDaysRepository.AddBulk(turnoverDaysToAdd.ToList());
                    }
                    if (recordToUpdate.Any())
                    {
                        foreach (var item in recordToUpdate)
                        {
                            item.TurnoverDay = turnoverDaysData.FirstOrDefault(x => x.SubGroupProductCategoryCode == item.SubGroupProductCategoryCode && x.Month == item.Month && x.AccountId == item.AccountId).TurnoverDay;
                            item.BP_Year = turnoverDaysData.FirstOrDefault(x => x.SubGroupProductCategoryCode == item.SubGroupProductCategoryCode && x.Month == item.Month && x.AccountId == item.AccountId).BP_Year;
                            item.Git_Year = turnoverDaysData.FirstOrDefault(x => x.SubGroupProductCategoryCode == item.SubGroupProductCategoryCode && x.Month == item.Month && x.AccountId == item.AccountId).Git_Year;
                            item.UpdateDate = DateTime.Now;
                        }
                        _turnoverDaysRepository.UpdateBulk(recordToUpdate);
                    }
                    return Result.Success;
                }
                return Result.Failure("Invalid Excel Template has been selected to upload turnoverDays");
            }
            return Result.Success;
        }


        private string[] ValidateExcel(List<TurnoverDays> turnoverDaysList)
        {
            List<string> errors = new List<string>();
            int firstIndex = 1;
            foreach (var turnoverDays in turnoverDaysList)
            {
                if (turnoverDays.SubGroupProductCategoryCode == null)
                {
                    errors.Add($"SubGroup code must be entered at row {turnoverDaysList.IndexOf(turnoverDays) + firstIndex}");
                }
                if ((turnoverDays.AccountId ?? 0) == 0)
                {
                    errors.Add($"OAC Code must be entered or incorrect OAC Code at row {turnoverDaysList.IndexOf(turnoverDays) + firstIndex}");
                }
                if (string.IsNullOrWhiteSpace(turnoverDays.Month) || turnoverDays.Month?.ToString().Length != 6)
                {
                    errors.Add($"Valid month must be entered at row {turnoverDaysList.IndexOf(turnoverDays) + firstIndex}");
                }
                if (turnoverDays.TurnoverDay == null)
                {
                    errors.Add($"Trunover days must be entered at row {turnoverDaysList.IndexOf(turnoverDays) + firstIndex}");
                }
                if ((turnoverDays.BP_Year ?? 0) == 0 || turnoverDays.BP_Year.ToString().Length != 4)
                {
                    errors.Add($"Valid BP year must be entered at row {turnoverDaysList.IndexOf(turnoverDays) + firstIndex}");
                }
                if (turnoverDays.Git_Year == null)
                {
                    errors.Add($"Valid Git days must be entered at row {turnoverDaysList.IndexOf(turnoverDays) + firstIndex}");
                }

            }
            if (turnoverDaysList.Count != turnoverDaysList.Select(x => new { x.SubGroupProductCategoryCode, x.Month, x.AccountId }).Distinct().Count())
            {
                errors.Add("Duplicate data found in the excel sheet");
            }
            return errors.ToArray();

        }
        private List<TurnoverDays> GetSheetData(ISheet excelSheet, int attachmentId, SessionData session, List<Account> accounts)
        {
            var turnoverDaysList = new List<TurnoverDays>();
            int firstRowIndex = 1; //set startting row
            for (int row = firstRowIndex; row <= excelSheet.LastRowNum; row++)
            {

                if (excelSheet.GetRow(row) != null) //null is when the row only contains empty cells 
                {
                    var turnoverDays = new TurnoverDays();
                    turnoverDays.AttachmentId = attachmentId;
                    turnoverDays.SubGroupProductCategoryCode =excelSheet.GetRow(row)
                                             .GetCell(0).ToString();
                    turnoverDays.Month = turnoverDays.Month = excelSheet.GetRow(row)
                                             .GetCell(1).ToString();
                    turnoverDays.AccountId = accounts.FirstOrDefault(x => x.AccountCode == Convert.ToString(excelSheet.GetRow(row)
                                            .GetCell(2)))?.AccountId ?? 0;
                    turnoverDays.TurnoverDay = Helper.ConvertStringToInteger(excelSheet.GetRow(row)
                                             .GetCell(3).ToString());
                    turnoverDays.BP_Year = Helper.ConvertStringToInteger(excelSheet.GetRow(row)
                                             .GetCell(4).ToString());
                    turnoverDays.Git_Year = Helper.ConvertStringToInteger(excelSheet.GetRow(row)
                                             .GetCell(5).ToString());

                    turnoverDays.CreatedBy = session.ADUserId;
                    turnoverDays.UpdateBy = session.ADUserId;
                    turnoverDays.UpdateDate = DateTime.Now;
                    turnoverDays.CreatedDate = DateTime.Now;
                    turnoverDays.IsActive = true;
                    turnoverDays.IsDeleted = false;
                    turnoverDaysList.Add(turnoverDays);
                }
            }
            return turnoverDaysList;

        }

    }
}
