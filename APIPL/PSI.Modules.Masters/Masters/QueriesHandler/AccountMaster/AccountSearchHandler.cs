

using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.AccountMaster;
using PSI.Modules.Backends.Masters.Repository;
using PSI.Modules.Backends.Masters.Repository.AccountMaster;

namespace PSI.Modules.Backends.Masters.QueriesHandler.AccountMaster
{
    public class AccountSearchHandler : IRequestHandler<AccountSearchQuery, IEnumerable<Account>>
    {
        private readonly IAccountRepository _accountRepository;
        public AccountSearchHandler(IAccountRepository accountRepository)
        {
            _accountRepository = accountRepository;

        }
        public async Task<IEnumerable<Account>> Handle(AccountSearchQuery request, CancellationToken cancellationToken)
        {
            var accounts = _accountRepository.GetAccounts(request).ToList();
            return await Task.FromResult(accounts);

        }

    }
}