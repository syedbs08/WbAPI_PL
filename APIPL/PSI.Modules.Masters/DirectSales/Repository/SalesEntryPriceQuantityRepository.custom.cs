using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Domains;

namespace PSI.Modules.Backends.DirectSales.Repository
{

    public partial interface ISalesEntryPriceQuantityRepository
    {
       // List<SalesEntryPriceQuantity> Get(List<int> salesEntryIds,int fromMonth,int toMonth);
    }
    public partial class SalesEntryPriceQuantityRepository
    {
       //public List<SalesEntryPriceQuantity> Get(List<int> salesEntryIds,int fromMonth, int toMonth)
       // {
       //    var result =  Get(Query.WithFilter(Filter<SalesEntryPriceQuantity>
       //           .Create(p =>Convert.ToInt32(p.MonthYear) >= fromMonth && Convert.ToInt32(p.MonthYear)<= toMonth &&
       //           salesEntryIds.Contains(p.SalesEntryId.Value)
       //           ))).ToList();
       //     if(result.Any()) return result;
       //     return new List<SalesEntryPriceQuantity>();
       // }
    }
}
