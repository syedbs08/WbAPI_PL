
using System;
using System.Linq;
using System.Collections;
using System.Collections.Generic;
using PSI.Domains.Entity;
using Core.BaseEntitySql.BaseRepository;
using System.Security.Cryptography.X509Certificates;

namespace AttachmentService.Repository
{
    public partial interface IAttachmentsRepository
    {
        List<string> AttachmentMonths();
        IEnumerable<Attachment> GetAttachmentList(string userIds, string monthYear);
    }
    public partial class AttachmentsRepository: IAttachmentsRepository
    {
        public IEnumerable<Attachment> GetAttachmentList(string userIds, string monthYear)
        {
            var filterMain = Filter<Attachment>.Create(p => p.DocumentMonth==monthYear);
            var query = Query.WithFilter(filterMain);
            if (userIds.Any())
            {
                query = Query.WithFilter(filterMain.And(Filter<Attachment>
                  .Create(p => p.CreatedBy==userIds
                  )));
            }
            var result = Get(query).OrderByDescending(x=>x.CreatedDate);
            return result;

        }
        public List<string> AttachmentMonths()
        {
            var monthResult= GetAll().GroupBy(c => c.DocumentMonth)
                   .Select(grp => grp.FirstOrDefault()?.DocumentMonth)
                   .ToList(); ;
            return monthResult;

        }



    }
}