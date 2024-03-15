using Core.BaseEntitySql.BaseRepository;
using Org.BouncyCastle.Crypto;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.CustomerMaster
{
    public partial interface ICustomerViewReopsitory
    {
        String GetAccountCodeByCustomercode(string customerCode);
        IEnumerable<CustomerView> GetCollaboNonCollaboCustomersByInchargeByCountryIds(List<int> countryId, bool? customerType, string personIncharge);
        IEnumerable<CustomerView> GetCustomersByInchargeByCountryIds(List<int> countryId,string personIncharge);
        List<CustomerView> GetCustomersByAccount(int accountId);
    }
    public partial class CustomerViewReopsitory
    {
        public string GetAccountCodeByCustomercode(string customerCode)
        {
            var result = FirstOrDefault(Query.WithFilter(Filter<CustomerView>
                  .Create(p => (p.CustomerCode == customerCode))
                  ));
            return result.AccountCode;
        }
        public IEnumerable<CustomerView> GetCustomersByInchargeByCountryIds(List<int> countryId, string personIncharge)
        {
           
                var result = Query.WithFilter(Filter<CustomerView>.Create(
                    x => x.IsActive == true
                    && countryId.Contains((int)x.CountryId)));
                return Get(result);
            
        }


        public IEnumerable<CustomerView> GetCollaboNonCollaboCustomersByInchargeByCountryIds(List<int> countryId, bool? customerType, string personIncharge)
        {
           
                var result = Query.WithFilter(Filter<CustomerView>.Create(
                    x => x.IsActive == true 
                    && x.IsCollabo == customerType 
                    && countryId.Contains((int)x.CountryId)));
                return Get(result);
            
        }
        public List<CustomerView> GetCustomersByAccount(int accountId)
        {
            var result = Get(Query.WithFilter(Filter<CustomerView>.Create(c => c.IsActive == true && c.AccountId == accountId)));
            return result.OrderBy(x => x.CustomerName).ToList();
        }
    }
}
