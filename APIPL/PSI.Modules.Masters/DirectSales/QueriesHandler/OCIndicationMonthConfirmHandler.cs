using DevExtreme.AspNet.Data;
using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using PSI.Domains;
using PSI.Modules.Backends.DirectSales.Queries;
using PSI.Modules.Backends.Constants;
using PSI.Modules.Backends.Masters.Results;
using PSI.Domains.Entity;
using static PSI.Modules.Backends.Constants.Contants;
using PSI.Modules.Backends.DirectSales.Results;
using PSI.Modules.Backends.Helpers;
using PSI.Modules.Backends.Masters.Repository.CompanyMaster;

using System.Collections.Generic;
using Microsoft.Graph;
using Attachment = PSI.Domains.Entity.Attachment;
using AttachmentService.Repository;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;

namespace PSI.Modules.Backends.DirectSales.QueriesHandler
{
    internal class OCIndicationMonthConfirmHandler : IRequestHandler<OCIndicationMonthConfirmSearchQuery, LoadResult>
    {
        private readonly PSIDbContext _context;
        private readonly Contants _myConstants = new Contants();
        private readonly IAttachmentsRepository _attachmentsRepository;
        public OCIndicationMonthConfirmHandler(IAttachmentsRepository attachmentsRepository)
        {
            _context = new PSIDbContext();
            _attachmentsRepository= attachmentsRepository;
        }
        public async Task<LoadResult> Handle(OCIndicationMonthConfirmSearchQuery request, CancellationToken cancellationToken)
        {
            try
            {
                var searchCommand = request.OCIndicationMonthCommand;
                var attachments = _attachmentsRepository.GetAll().Where(x => x.FileTypeId == (int)FileTypeEnum.OcIndicationMonth);
                bool isMrktHead = request.Session.Roles.Contains(Contants.MKTG_HEAD_ROLE);
                var data = _context.SP_OcIndicationMonthConfirm.FromSql($"SP_OCINDICATIONMONTHCONFIRM {searchCommand.CountryId}, {searchCommand.CustomerId}, {searchCommand.ProductCategoryId},{searchCommand.ProductSubCategoryId},{searchCommand.StartMonthYear},{searchCommand.CustomerTypeId},{isMrktHead}").AsNoTracking().ToList();
                var directSaleViewdata = _context.DirectSaleView.Where(x => x.ModeOfTypeId == (int)ModeOfTypeEnum.MPO && Convert.ToInt32(x.MonthYear)==Convert.ToInt32(searchCommand.StartMonthYear)).ToList();
                var ocIndicationMonthResult = data.Select(x => new OCIndicationMonthResult
                {
                    SalesEntryId=x.SalesEntryId,
                    CustomerId = x.CustomerId,
                    MonthYear = x.MonthYear,
                    CompanyId = x.CompanyId,
                    CountryId = x.CountryId,
                    CustomerCode = x.CustomerCode,
                    CustomerName = x.CustomerName,
                    MaterialCode = x.MaterialCode,
                    ProductCategoryId1 = x.ProductCategoryId1,
                    ProductCategoryId2 = x.ProductCategoryId3,
                    Mg = x.Mg,
                    Mg1 = x.Mg1,
                    OrderQunatity = x.OrderQunatity,
                    SNSQunatity = directSaleViewdata.FirstOrDefault(z => z.CustomerId == x.CustomerId && z.MaterialCode == x.MaterialCode).Quantity,
                    TotalQunatity = x.OrderQunatity + directSaleViewdata.FirstOrDefault(z => z.CustomerId == x.CustomerId && z.MaterialCode == x.MaterialCode).Quantity,
                    OrderPrice = x.OrderPrice,
                    SNSPrice = directSaleViewdata.FirstOrDefault(z => z.CustomerId == x.CustomerId && z.MaterialCode == x.MaterialCode).Price,
                    TotalPrice = x.OrderPrice + directSaleViewdata.FirstOrDefault(z => z.CustomerId == x.CustomerId && z.MaterialCode == x.MaterialCode).Price,
                    Order_Amount = x.OrderQunatity * x.OrderPrice,
                    SNSAmount = (directSaleViewdata.FirstOrDefault(z => z.CustomerId == x.CustomerId && z.MaterialCode == x.MaterialCode).Quantity) * (directSaleViewdata.FirstOrDefault(z => z.CustomerId == x.CustomerId && z.MaterialCode == x.MaterialCode).Price),
                    Amount = (x.OrderQunatity * x.OrderPrice) + ((directSaleViewdata.FirstOrDefault(z => z.CustomerId == x.CustomerId && z.MaterialCode == x.MaterialCode).Quantity) * (directSaleViewdata.FirstOrDefault(z => z.CustomerId == x.CustomerId && z.MaterialCode == x.MaterialCode).Price)),
                    IsSNS = x.IsSNS,
                    Reason = x.Reason,
                    Remarks = x.Remarks,
                    OcIndicationMonthStatus = x.OcIndicationMonthStatus,
                    Attachements = GetAttachmentFilesName(attachments, x.OcIndicationMonthAttachmentIds),
                });
                var loadOptions = request?.LoadOptions;
                var result = DataSourceLoader.Load(ocIndicationMonthResult, loadOptions);
                return result;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public List<AttachementResult> GetAttachmentFilesName(IEnumerable<Attachment> attachments, string ocIndicationMonthAttachmentIds)
        {
            if (string.IsNullOrWhiteSpace(ocIndicationMonthAttachmentIds) == true)
            {
                return new List<AttachementResult>();

            }
            List <AttachementResult> attachementResult = new List<AttachementResult>();
            int[] ids = Helper.SplitToInt(ocIndicationMonthAttachmentIds);
            var data= attachments.Where(x => ids.Contains(x.Id)).ToList();
            if (data.Any())
            {
                foreach (var item in data)
                {
                    attachementResult.Add(new AttachementResult { OcIndicationMonthAttachmentIdFile = item.DocumentName, OcIndicationMonthAttachmentIdBlobFile = item.VirtualFileName });
                }
            }
            return attachementResult;
        }
    }

}
