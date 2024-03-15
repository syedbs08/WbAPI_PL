using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Domains;
using PSI.Modules.Backends.DirectSales.Command;
using NPOI.SS.Formula.Functions;

namespace PSI.Modules.Backends.DirectSales.Repository
{

    public partial interface ISalesEntryRepository
    {
       // List<SalesEntry> Get(int saleEntryHeaderId);
        IEnumerable<SalesEntry> GetSalesEntryBySalesEntryIds(List<int> ids);
        IEnumerable<SalesEntry> GetSaleEntries(DirectSalesDownload directSalesDownload);
        List<SalesEntry> Get(List<int> salesEntryIds, int fromMonth, int toMonth);
    }
    public partial class SalesEntryRepository 
    {
        public IEnumerable<SalesEntry> GetSalesEntryBySalesEntryIds(List<int> ids)
        {
            var result = Query.WithFilter(Filter<SalesEntry>.Create(p => ids.Contains((int)p.SalesEntryId)));
            return Get(result);
        }
        //public List<SalesEntry> Get(int saleEntryHeaderId)
        //{
        //    return GetAll().Where(x => x.SaleEntryHeaderId == saleEntryHeaderId).ToList();
        //}
        public IEnumerable<SalesEntry> GetSaleEntries(DirectSalesDownload directSalesDownload)
        {
            return GetAll().Where(x => x.CustomerId == directSalesDownload.CustomerId && x.ProductCategoryId1 == Convert.ToInt32(directSalesDownload.ProductCategoryId) && x.SaleTypeId == directSalesDownload.SaleTypeId && x.SaleSubType == directSalesDownload.SaleSubType
            && Convert.ToInt32(x.MonthYear) >= directSalesDownload.FromMonth && Convert.ToInt32(x.MonthYear) <= directSalesDownload.ToMonth).OrderByDescending(x => x.SalesEntryId);
        }
        public List<SalesEntry> Get(List<int> salesEntryIds, int fromMonth, int toMonth)
        {
            var result = Get(Query.WithFilter(Filter<SalesEntry>
                   .Create(p => Convert.ToInt32(p.MonthYear) >= fromMonth && Convert.ToInt32(p.MonthYear) <= toMonth &&
                   salesEntryIds.Contains(p.SalesEntryId)
                   ))).ToList();
            if (result.Any()) return result;
            return new List<SalesEntry>();
        }

    }
}
