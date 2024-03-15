
using System;
using System.Linq;
using System.Collections;
using System.Collections.Generic;
using PSI.Domains.Entity;
using Core.BaseEntitySql.BaseRepository;
using System.Security.Cryptography.X509Certificates;

namespace AttachmentService.Repository
{
    public partial interface IVW_AttachmentRepository
    {
        List<string> AttachmentMonths();
        IEnumerable<VW_ATTACHMENT> GetAttachmentList(string userIds, string monthYear);
    }
    public partial class VW_AttachmentRepository : IVW_AttachmentRepository
    {
        public IEnumerable<VW_ATTACHMENT> GetAttachmentList(string userIds, string monthYear)
        {
            var filterMain = Filter<VW_ATTACHMENT>.Create(p => p.CreatedMonthYear==monthYear && p.IsActive==true);
            var query = Query.WithFilter(filterMain);
            if (userIds.Any())
            {
                query = Query.WithFilter(filterMain.And(Filter<VW_ATTACHMENT>
                  .Create(p => p.CreatedBy==userIds
                  )));
            }
            var result = Get(query).OrderByDescending(x=>x.CreatedDate);
            return result;

        }
        public List<string> AttachmentMonths()
        {
            var monthResult = GetAll();
           var result= monthResult.GroupBy(c => c.DocumentMonth)
                   .Select(grp => grp.FirstOrDefault()?.DocumentMonth)
                   .ToList(); ;
            return result;

        }



    }
}