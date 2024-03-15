using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Domains;

namespace PSI.Modules.Backends.Masters.Repository.CompanyMaster
{
    public partial interface ICompanyRepository : IBaseRepository<Company>
    {
    }
    public partial class CompanyRepository : BaseRepository<Company>, ICompanyRepository
    {
        public CompanyRepository() : base(new PSIDbContext()) { }
    }
}
