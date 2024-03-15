using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.SNS.Repository
{
    public partial interface ISNSEntryQtyPriceRepository 
    {
        List<SNSEntryQtyPrice> Get(List<int> snsEntryIds);
        IEnumerable<SNSEntryQtyPrice> GetSNSEntryQtyPricesByIds(List<int?> snsEntryQtyIds);
    }
    public partial class SNSEntryQtyPriceRepository
    {
        public List<SNSEntryQtyPrice> Get(List<int> snsEntryIds)
        {
            var result = Get(Query.WithFilter(Filter<SNSEntryQtyPrice>
                   .Create(p =>
                   snsEntryIds.Contains(p.SNSEntryId.Value)
                   ))).ToList();
            if (result.Any()) return result;
            return new List<SNSEntryQtyPrice>();
        }

        public IEnumerable<SNSEntryQtyPrice> GetSNSEntryQtyPricesByIds(List<int?> snsEntryQtyIds)
        {
            var result = Get(Query.WithFilter(Filter<SNSEntryQtyPrice>
                   .Create(p => snsEntryQtyIds.Contains(p.SNSEntryQtyPriceId))));
            return result;
        }
    }
   
}
