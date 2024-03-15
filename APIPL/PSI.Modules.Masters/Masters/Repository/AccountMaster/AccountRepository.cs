

using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;

namespace PSI.Modules.Backends.Masters.Repository.AccountMaster
{
    public partial interface IAccountRepository : IBaseRepository<Account>
    {
    }
    public partial class AccountRepository : BaseRepository<Account>, IAccountRepository
    {
        public AccountRepository() : base(new PSIDbContext()) { }
    }
}
