using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Modules.Backends.DirectSales.Command;

namespace PSI.Modules.Backends.DirectSales.Repository
{

    public partial interface ISaleEntryHeaderRepository
    {
        //SaleEntryHeader? Get(DirectSalesDownload directSalesDownload);
        //IEnumerable<SaleEntryHeader> GetByIds(List<int> ids);
        //IEnumerable<SaleEntryHeader> GetSaleEntries(DirectSalesDownload directSalesDownload);
    }
    public partial class SaleEntryHeaderRepository
    {
        //public IEnumerable<SaleEntryHeader> GetByIds(List<int> ids)
        //{
        //    var result = Query.WithFilter(Filter<SaleEntryHeader>.Create(p => ids.Contains(p.SaleEntryHeaderId)));
        //    return Get(result);
        //}
        //public SaleEntryHeader? Get(DirectSalesDownload directSalesDownload)
        //{
        //   return GetAll().Where(x => x.CustomerId == directSalesDownload.CustomerId && x.ProductCategoryId1 == directSalesDownload.ProductCategoryId && x.ProductCategoryId2 == directSalesDownload.ProductSubCategoryId && x.SaleTypeId == directSalesDownload.SaleTypeId && x.SaleSubType == directSalesDownload.SaleSubType).OrderByDescending(x => x.SaleEntryHeaderId).FirstOrDefault();
        //}

        //public IEnumerable<SaleEntryHeader> GetSaleEntries(DirectSalesDownload directSalesDownload)
        //{
        //        return GetAll().Where(x => x.CustomerId == directSalesDownload.CustomerId && x.ProductCategoryId1 == directSalesDownload.ProductCategoryId  && x.SaleTypeId == directSalesDownload.SaleTypeId && x.SaleSubType == directSalesDownload.SaleSubType).OrderByDescending(x => x.SaleEntryHeaderId);
        //}
          
    }
}
