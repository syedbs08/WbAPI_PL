using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.DirectSales.Repository
{
    public partial interface ISalesEntryPriceQuantityRepository
    {
        IEnumerable<SalesEntryPriceQuantity> GetSalesEntryPriceQuantityByIds(List<int> ids);
    }
    public partial class SalesEntryPriceQuantityRepository
    {
        public IEnumerable<SalesEntryPriceQuantity> GetSalesEntryPriceQuantityByIds(List<int> ids)
        {
            var result = Query.WithFilter(Filter<SalesEntryPriceQuantity>.Create(p =>ids.Contains((int)p.SalesEntryPriceQuantityId)));
            return Get(result);
        }
    }
}
