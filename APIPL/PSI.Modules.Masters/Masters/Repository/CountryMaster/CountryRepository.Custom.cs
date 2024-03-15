using Core.BaseEntitySql.BaseRepository;
using Core.BaseUtility.TableSearchUtil;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.CountryMaster;
using System.Linq;

namespace PSI.Modules.Backends.Masters.Repository.CountryMaster
{
    public partial interface ICountryRepository
    {
        Country GetCountry(string CountryCode, string CountryName);
        IEnumerable<Country> GetAllCountry();
        IEnumerable<Country> GetByIds(int[] ids);
        PagingResponse<Country> GetCountrys(PagingRequest searchItems);
    }
    public partial class CountryRepository
    {
        public IEnumerable<Country> GetAllCountry()
        {            
            return GetAll().Where(p => p.IsDeleted != true);            
        }
        public Country GetCountry(string CountryCode, string CountryName)
        {
            var result = FirstOrDefault(Query.WithFilter(Filter<Country>
                   .Create(p => p.IsActive == true
                   && p.CountryCode == CountryCode
                   || p.CountryName == CountryName
                   )));
            return result;
        }

        public IEnumerable<Country> GetByIds(int[] ids)
        {            
            var result = Query.WithFilter(Filter<Country>.Create(p => ids.Contains(p.CountryId) && p.IsActive == true));
            return Get(result);
        }
        public PagingResponse<Country> GetCountrys(PagingRequest searchItems)
        {
            var filterMain = Filter<Country>.Create(p => p.IsDeleted != true);
            var query = Query.WithFilter(filterMain);
            if (!string.IsNullOrWhiteSpace(searchItems.Search.Value))
            {
                query = Query.WithFilter(filterMain.And(Filter<Country>
                  .Create(p => p.CountryName.Contains(searchItems.Search.Value)
                   || p.CountryCode.Contains(searchItems.Search.Value)
                  )));
            }
            var result = Get(query);
            return PagingDataResult.GetPagingResponse(result, searchItems);
        }
    }
}