using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;

namespace PSI.Modules.Backends.SNS.Repository
{
    public partial interface IVW_SNSPlanningCommentRepository
    {
        IEnumerable<VW_SNSPlanningComment> GetSNSPlanningCommentByQuery(string materialcode, string accountcode);
    }
    public partial class VW_SNSPlanningCommentRepository
    {
        public IEnumerable<VW_SNSPlanningComment> GetSNSPlanningCommentByQuery(string materialcode, string accountcode)
        {
            var result = Get(Query.WithFilter(Filter<VW_SNSPlanningComment>
                   .Create(p => p.AccountCode == accountcode && 
                   p.MaterialCode == materialcode)))
                    .OrderByDescending(c=> c.CreatedDate);
            return result;
        }
    }
}