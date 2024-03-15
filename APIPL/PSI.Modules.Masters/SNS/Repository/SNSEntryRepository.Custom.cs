using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;

namespace PSI.Modules.Backends.SNS.Repository
{
    public partial interface ISNSEntryRepository
    {
        IEnumerable<SNSEntry> GetSNSEntriesByIds(List<int?> snsEntryIds);
    }
    public partial class SNSEntryRepository
    {
        public IEnumerable<SNSEntry> GetSNSEntriesByIds(List<int?> snsEntryIds)
        {
            var result = Get(Query.WithFilter(Filter<SNSEntry>
                   .Create(p => snsEntryIds.Contains(p.SNSEntryId))));
            return result;
        }
    }
}