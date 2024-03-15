
using MediatR;
using PSI.Domains.Entity;


namespace PSI.Modules.Backends.Masters.Queries.AccountMaster
{
    public class AccountSearchQuery : IRequest<IEnumerable<Account>>
    {
        public AccountSearchQuery(int pageNumber = 0,
            int pageSize = 10,
            string accountCode = "",
            string accountName = "",
            string searchTeam = ""
            )
        {
            PageNumber = pageNumber;
            PageSize = pageSize;
            AccountCode = accountCode;
            AccountName = accountName;
            SearchTeam = searchTeam;
        }
        public string SearchTeam { get; set; } = "";

        public string AccountCode { get; set; } = "";
        public string AccountName { get; set; } = "";
        public int PageNumber { get; set; } = 0;
        public int PageSize { get; set; } = 10;
    }
}