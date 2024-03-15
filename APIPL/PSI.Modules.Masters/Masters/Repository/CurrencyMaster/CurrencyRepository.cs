using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Domains;


namespace PSI.Modules.Backends.Masters.Repository.CurrencyMaster
{
    public partial interface ICurrencyRepository : IBaseRepository<Currency>
    {
    }
    public partial class CurrencyRepository : BaseRepository<Currency>, ICurrencyRepository
    {
        public CurrencyRepository() : base(new PSIDbContext()) { }
    }
}
