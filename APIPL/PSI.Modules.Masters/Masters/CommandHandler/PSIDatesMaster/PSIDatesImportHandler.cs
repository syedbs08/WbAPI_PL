using AttachmentService.Result;
using AttachmentService;
using Core.BaseUtility.Utility;
using MediatR;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using PSI.Modules.Backends.Helpers;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Command.PSIDatesMaster;
using PSI.Modules.Backends.Masters.Repository.PSIDatesMaster;
using Microsoft.Graph;

namespace PSI.Modules.Backends.Masters.CommandHandler.PSIDatesMaster
{
    public class PSIDatesImportHandler : IRequestHandler<ImportPSIDatesCommand, Result>
    {
        private readonly IPSIDatesRepository _psiDatesRepository;
        private readonly IAttachmentService _attachmentService;
        public PSIDatesImportHandler(
            IPSIDatesRepository psiDatesRepository,
            IAttachmentService attachmentService)
        {
            _psiDatesRepository = psiDatesRepository;
            _attachmentService = attachmentService;
        }
        public async Task<Result> Handle(ImportPSIDatesCommand request, CancellationToken cancellationToken)
        {
            try
            {
                var uploadedResult = await _attachmentService.UploadFiles(request.Command, request.Session, true);
                if (uploadedResult == null)
                {
                    return Result.Failure("Error while uploading PSIDates in blob");
                }
                var result = ReadPSIDatesExcel(request, uploadedResult);
                if (result.IsSuccess)
                {
                    Task.Run(() => _attachmentService.ActivateFile(uploadedResult.Id));

                }
                return result;

            }
            catch (Exception ex)
            {
                Log.Error($"Execption occured while uploading PSIDates ", ex.Message);
               
                return Result.Failure("Problem in adding PSIDates ,try later");
            }
        }
        private Result ReadPSIDatesExcel(ImportPSIDatesCommand command,
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
                    if (sheet.GetRow(0).Cells.Count != 4)
                    {
                        return Result.Failure("Invalid Excel Template has been selected to upload PSIDates");
                    }
                    var psiDatesData = GetSheetData(sheet, fileData.Id, command.Session);
                    var validateResult = ValidateExcel(psiDatesData);
                    if (validateResult.Length > 0)
                    {
                        return Result.Failure(validateResult);
                    }
                    var existPSIDates = _psiDatesRepository.GetAll();
                    var psiDatesToAdd = psiDatesData.Where(x => !existPSIDates.Any(y => y.Month == x.Month));
                    var recordToUpdate = existPSIDates.Where(x => psiDatesData.Any(y => y.Month == x.Month)).ToList();
                    if (psiDatesToAdd.Any())
                    {
                        _psiDatesRepository.AddBulk(psiDatesToAdd.ToList());
                    }
                    if (recordToUpdate.Any())
                    {
                        foreach (var item in recordToUpdate)
                        {
                            item.UpdateDate = DateTime.Now;
                            item.TransmitDate = psiDatesData.FirstOrDefault(x => x.Month == item.Month).TransmitDate;
                            item.ATPDate = psiDatesData.FirstOrDefault(x => x.Month == item.Month).ATPDate;
                            item.PODate = psiDatesData.FirstOrDefault(x => x.Month == item.Month).PODate;
                        }
                        _psiDatesRepository.UpdateBulk(recordToUpdate);

                    }
                    return Result.Success;
                }
                return Result.Failure("Invalid Excel Template has been selected to upload PSIDates");
            }
            return Result.Success;
        }
        private string[] ValidateExcel(List<PSIDates> psiDatesList)
        {
            List<string> errors = new List<string>();
            int firstIndex = 1;
            foreach (var psiDates in psiDatesList)
            {
                if (string.IsNullOrWhiteSpace(psiDates.Month))
                {
                    errors.Add("PSI month must be entered at row " + psiDatesList.IndexOf(psiDates) + firstIndex);

                }
                if (psiDates.TransmitDate==null)
                {
                    errors.Add("Transmit date must be entered at row " + psiDatesList.IndexOf(psiDates) + firstIndex);

                }
                if (psiDates.ATPDate == null)
                {
                    errors.Add("ATP date must be entered at row " + psiDatesList.IndexOf(psiDates) + firstIndex);

                }
                if (psiDates.ATPDate == null)
                {
                    errors.Add("ATP date must be entered at row " + psiDatesList.IndexOf(psiDates) + firstIndex);

                }
            }
            if (psiDatesList.Count != psiDatesList.DistinctBy(x => x.Month).Count())
            {
                errors.Add("Duplicate month found in the excel sheet");
            }
            return errors.ToArray();

        }
        private List<PSIDates> GetSheetData(ISheet excelSheet, int attachmentId, SessionData session)
        {
            var psiDatesList = new List<PSIDates>();
            int firstRowIndex = 1; //set startting row
            for (int row = firstRowIndex; row <= excelSheet.LastRowNum; row++)
            {

                if (excelSheet.GetRow(row) != null) //null is when the row only contains empty cells 
                {
                    var psiDates = new PSIDates();
                    psiDates.AttachmentId = attachmentId;
                    psiDates.Month = Convert.ToString(excelSheet.GetRow(row).GetCell(0).ToString());
                    psiDates.TransmitDate = Convert.ToDateTime(excelSheet.GetRow(row)
                                             .GetCell(1).DateCellValue.ToString());
                    psiDates.ATPDate = Convert.ToDateTime(excelSheet.GetRow(row)
                                             .GetCell(2).DateCellValue.ToString());
                    psiDates.PODate = Convert.ToDateTime(excelSheet.GetRow(row)
                                           .GetCell(3).DateCellValue.ToString());
                    psiDates.CreatedBy = session.ADUserId;
                    psiDates.UpdateBy = session.ADUserId;
                    psiDates.UpdateDate = DateTime.Now;
                    psiDates.CreatedDate = DateTime.Now;
                    psiDates.IsActive =true;
                    psiDatesList.Add(psiDates);
                }
            }
            return psiDatesList;

        }

    }
}