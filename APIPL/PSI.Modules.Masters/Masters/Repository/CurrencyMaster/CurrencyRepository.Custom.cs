using Core.BaseEntitySql.BaseRepository;
using Core.BaseUtility.MapperProfiles;
using Core.BaseUtility.TableSearchUtil;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Command.CompanyMaster;
using PSI.Modules.Backends.Masters.Queries.CurrencyMaster;
using PSI.Modules.Backends.Masters.Results;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;

namespace PSI.Modules.Backends.Masters.Repository.CurrencyMaster
{
    public partial interface ICurrencyRepository
    {
        List<CurrencyResult> GetCurrencies();
        Currency GetCurrency(string currencyCode, string currencyName);
    }
    public partial class CurrencyRepository
    {
        public Currency GetCurrency(string currencyCode, string currencyName)
        {
                var result = FirstOrDefault(Query.WithFilter(Filter<Currency>
                  .Create(p => 
                   p.CurrencyCode == currencyCode
                  || p.CurrencyName == currencyName
                  )));
                return result;
        }
        public List<CurrencyResult> GetCurrencies()
        {
            var result = GetAll();
            var mapResult= MappingProfile<Currency, CurrencyResult>.MapList(result.ToList());
          
            return mapResult;
        }
    }
}
