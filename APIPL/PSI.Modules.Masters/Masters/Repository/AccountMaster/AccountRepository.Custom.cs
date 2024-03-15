
using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;

using PSI.Modules.Backends.Masters.Queries.AccountMaster;

namespace PSI.Modules.Backends.Masters.Repository.AccountMaster
{
    // your custom query goes in here 
    public partial interface IAccountRepository
    {
         Account GetAccount(string accountCode, string accountName);
         IEnumerable<Account> GetAccounts(AccountSearchQuery searchItems);
        string GetAccountCodeById(int id);
    }
    public partial class AccountRepository
    {
        public string GetAccountCodeById(int id)
        {
            var result = FirstOrDefault(Query.WithFilter(Filter<Account>
                   .Create(p => p.AccountId == id
                   ))).AccountCode;
            return result;
        }
        public Account GetAccount(string accountCode,string accountName)
        {
            var result = FirstOrDefault(Query.WithFilter(Filter<Account>
                   .Create(p => p.IsActive == true 
                   && p.AccountCode == accountCode
                   )));
            return result;
        }
        
        public IEnumerable<Account> GetAccounts(AccountSearchQuery searchItems)
        {
            var filterExpression = Filter<Account>.Create(p => p.IsActive == true);

            if (!string.IsNullOrWhiteSpace(searchItems.AccountName))
            {
                filterExpression.And(Filter<Account>
                   .Create(p => p.AccountName.Contains(searchItems.AccountName)));
            }

            if (!string.IsNullOrWhiteSpace(searchItems.AccountCode))
            {
                filterExpression.And(Filter<Account>
                   .Create(p => p.AccountCode.Contains(searchItems.AccountCode)));
            }

            if (!string.IsNullOrWhiteSpace(searchItems.SearchTeam))
            {
                filterExpression.And(Filter<Account>
                   .Create(p => p.AccountCode.Contains(searchItems.SearchTeam)
                   || p.AccountName.Contains(searchItems.SearchTeam)));
                  
            }

            var result = Get(Query.WithFilter(filterExpression), searchItems.PageNumber, searchItems.PageSize);
            return result;

        }

    }
}