using AttachmentService;
using AttachmentService.Command;
using AttachmentService.Result;
using Azure.Core;
using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.Graph;
using PSI.Domains;
using PSI.Modules.Backends.DirectSales.Command;
using PSI.Modules.Backends.DirectSales.Repository;
using static PSI.Modules.Backends.Constants.Contants;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Helpers;
using System.Linq;
using Microsoft.EntityFrameworkCore;

namespace PSI.Modules.Backends.DirectSales.CommandHandler
{
    public class UpdateOCIndicationMonthHandler : IRequestHandler<UpdateOCIndicationMonthCommand, Result>
    {
        private readonly ISalesEntryRepository _salesEntryRepository;
        private readonly IAttachmentService _attachmentService;
        private readonly PSIDbContext _context;
        public UpdateOCIndicationMonthHandler(ISalesEntryRepository salesEntryRepository, IAttachmentService attachmentService)
        {
            _salesEntryRepository = salesEntryRepository;
            _attachmentService = attachmentService;
            _context = new PSIDbContext();
        }
        public async Task<Result> Handle(UpdateOCIndicationMonthCommand request, CancellationToken cancellationToken)
        {
            try
            {
                
                if (request.OCIndicationMonthCommand.CustomerId.Count() > 0)
                {
                    List<int> salesEntryIds = request.OCIndicationMonthCommand.SalesEntryId.Split(',').Select(int.Parse).ToList();

                    var lockmonthyear = _context.GlobalConfig.Where(x => x.ConfigKey == "Lock_Month").Select(x => x.ConfigValue).FirstOrDefault();
                    string MonthYear = Helper.AddMonthYYYYMM(lockmonthyear, 1);
                    List<SalesEntry> recordToUpdate = _context.SalesEntries.Where(x => salesEntryIds.Contains(x.SalesEntryId) && x.MonthYear == MonthYear).ToList();
                    if (recordToUpdate.Count() > 0)
                    {
                        List<string> materialCodes= recordToUpdate.Select(x=>x.MaterialCode).ToList();
                        List<string> customerCodes = recordToUpdate.Select(x=>x.CustomerCode).ToList();


                    List<string> subCateCodes = (from m in _context.Materials
                                                 join p in _context.ProductCategories
                                                 on m.ProductCategoryId2 equals p.ProductCategoryId
                                                 where p.CategoryLevel == 2 && materialCodes.Contains(m.MaterialCode)
                                                 select p.ProductCategoryCode).Distinct().ToList();

                    var checkPermissionToUpdateRecord = _context.LockPSI.Where(x => x.UserId == request.Session.ADUserId && customerCodes.Contains(x.CustomerCode) && x.OC_IndicationMonth == true && subCateCodes.Contains(x.SubCategoryCode)).Distinct().ToList();
                    if (checkPermissionToUpdateRecord.Any())
                    {
                        string customer = string.Join(", ", checkPermissionToUpdateRecord.Select(item => item.CustomerCode).Distinct());
                        string mg1s = string.Join(", ", checkPermissionToUpdateRecord.Select(item => item.SubCategoryCode).Distinct());
                        return Result.Failure("You don't have permission to update oc indication month of these customer(" + customer + ") and MG1(" + mg1s + ").Please contact to admin");
                    }
                   
                  
                   
                        if (request.OCIndicationMonthCommand.Status == "Update")
                        {
                            string ocIndicationMonthAttachmentIds = "";
                            IList<FileUploadResult> attachementFile = new List<FileUploadResult>();
                            if (request.OCIndicationMonthCommand.files != null)
                            {
                                FileCommand fileCommand = new FileCommand();
                                fileCommand.FolderPath = request.OCIndicationMonthCommand.FolderPath;
                                fileCommand.FileTypeId = (int)FileTypeEnum.OcIndicationMonth;
                                fileCommand.Files = request.OCIndicationMonthCommand.files;
                                attachementFile = await _attachmentService.UploadFile(fileCommand, request.Session);
                                if (attachementFile != null)
                                {
                                    ocIndicationMonthAttachmentIds = String.Join(",", attachementFile.Select(x => x.Id));
                                }
                            }
                            foreach (var data in recordToUpdate)
                            {
                                data.OrderIndicationConfirmedBySaleTeamDate = DateTime.Now;
                                data.OrderIndicationConfirmedBySaleTeam = request.Session.Name;
                                data.Reason = request.OCIndicationMonthCommand.Reason;
                                data.IsSNS = request.OCIndicationMonthCommand.IsSNS;
                                data.OcIndicationMonthAttachmentIds = ocIndicationMonthAttachmentIds;
                                data.Remarks = request.OCIndicationMonthCommand.Remarks;
                            }
                            _salesEntryRepository.UpdateBulk(recordToUpdate);

                            foreach (var data in attachementFile)
                            {
                                Task.Run(() => _attachmentService.ActivateFile(data.Id));
                            }

                        }
                        else if (request.OCIndicationMonthCommand.Status == "Confirm")
                        {
                            foreach (var data in recordToUpdate)
                            {
                                data.OrderIndicationConfirmedBySaleTeamDate = DateTime.Now;
                                data.OrderIndicationConfirmedByMarketingTeamDate = DateTime.Now;
                                data.OrderIndicationConfirmedByMarketingTeam = request.Session.Name;
                                data.OrderIndicationConfirmedBySaleTeam = request.Session.Name;
                                data.IsPO = request.OCIndicationMonthCommand.IsPO;
                                data.TermId = Convert.ToString(request.OCIndicationMonthCommand.TermId);
                                data.OcIndicationMonthStatus = "Confirmed";
                            }
                            _salesEntryRepository.UpdateBulk(recordToUpdate);
                        }
                        else if (request.OCIndicationMonthCommand.Status == "Delete")
                        {
                            foreach (var data in recordToUpdate)
                            {
                                data.OrderIndicationConfirmedBySaleTeamDate = DateTime.Now;
                                data.OrderIndicationConfirmedBySaleTeam = "";
                                data.Reason = "";
                                data.IsSNS = false;
                                data.OcIndicationMonthAttachmentIds = "";
                                data.Remarks = "";
                            }
                            _salesEntryRepository.UpdateBulk(recordToUpdate);
                        }



                    }
                    else
                    {
                        return Result.Failure("You can't confirm this record ");
                    }
                }
                return Result.Success;
            }
            catch (Exception ex)
            {
                Log.Error($"Execption occured while updating OC Indication Month", ex.Message);
                return Result.Failure("Problem in  updating OC Indication Month ,try later");

            }

        }
    }
}
