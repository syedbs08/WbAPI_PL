using MediatR;
using PSI.Domains.Entity;


namespace PSI.Modules.Backends.Masters.Queries.AccountMaster
{
    public class AccountSingleQuery : IRequest<Account>
    {
        public AccountSingleQuery(string accountName,
            string accountCode)
        {
            AccountCode = accountCode;
            AccountName = accountName;
        }
        public string AccountName { get; }
        public string AccountCode { get; }
    }
}