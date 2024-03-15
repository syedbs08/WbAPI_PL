using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Domains;


namespace PSI.Modules.Backends.Masters.Repository.CountryMaster
{
    public partial interface ICountryRepository : IBaseRepository<Country>
    {
    }
    public partial class CountryRepository : BaseRepository<Country>, ICountryRepository
    {
        public CountryRepository() : base(new PSIDbContext()) { }
    }
}
