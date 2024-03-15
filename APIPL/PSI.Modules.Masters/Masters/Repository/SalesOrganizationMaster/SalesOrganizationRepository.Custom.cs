using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;

namespace PSI.Modules.Backends.Masters.Repository.SalesOrganizationMaster
{
    public partial interface ISalesOrganizationRepository
    {
        IEnumerable<SalesOrganization> GetAllSalesOrganization();
    }
    public partial class SalesOrganizationRepository
    {
        public IEnumerable<SalesOrganization> GetAllSalesOrganization()
        {
            return Get(Query.WithFilter(Filter<SalesOrganization>.Create(x=>x.IsActive==true))).AsEnumerable();
        }
    }
}
