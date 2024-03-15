

using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.AccountMaster;
using PSI.Modules.Backends.Masters.Repository.AccountMaster;

namespace PSI.Modules.Backends.Masters.QueriesHandler.AccountMaster
{
    public class AccountSingleHandler : IRequestHandler<AccountSingleQuery, Account>
    {

        private readonly IAccountRepository _accountRepository;

        public AccountSingleHandler(IAccountRepository accountRepository)
        {
            _accountRepository = accountRepository;
        }

        public async Task<Account> Handle(AccountSingleQuery request, CancellationToken cancellationToken)
        {
            return await Task.Run(() =>
            {
                var result = _accountRepository.GetAccount(request.AccountCode, request.AccountName);

                return result;
            });

        }
    }
}