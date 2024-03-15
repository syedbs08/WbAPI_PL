using Core.BaseEntitySql.BaseRepository;
using Microsoft.Data.SqlClient;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.CustomerMaster
{
    public partial interface ICustomerRepository
    {
        List<Customer> GetCustomers();
        List<Customer> GetCollaboNonCollaboCustomers(bool? customerType);
        Customer GetCustomer(int? customerId, string customerCode, string emailId);
        List<Customer> GetCollaboNonCollaboCustomersByIncharge(bool? customerType);
        IEnumerable<Customer> GetCustomersByIds(List<int?> customerIds);
        IEnumerable<Customer> GetCustomersByCustomerCode(List<string?> customercodes);
      
    }
    public partial class CustomerRepository
    {
        public List<Customer> GetCustomers()
        {
            var result = GetAll().Where(x=>x.IsActive==true);
            return result.OrderBy(x=>x.CustomerName).ToList();
        }
        public List<Customer> GetCollaboNonCollaboCustomers(bool? customerType)
        {
            var result = GetAll().Where(x => x.IsActive == true && x.IsCollabo== customerType);
            return result.OrderBy(x => x.CustomerName).ToList();
        }
        public Customer GetCustomer(int? customerId, string customerCode, string email)
        {

            if (customerId == 0)
            {
                var result = FirstOrDefault(Query.WithFilter(Filter<Customer>
                  .Create(p => (p.CustomerCode == customerCode || p.EmailId == email ))
                  ));
                return result;
            }
            else
            {
                var result = FirstOrDefault(Query.WithFilter(Filter<Customer>
                 .Create(p => p.CustomerId != customerId && ( p.EmailId == email
                 || p.CustomerCode == customerCode )
                 )));
                return result;
            }
        }

        public List<Customer> GetCollaboNonCollaboCustomersByIncharge(bool? customerType)
        {
            var result = Get(Query.WithFilter(Filter<Customer>.Create(c => c.IsActive == true && ((customerType == true && c.IsCollabo == customerType) || (customerType == false && (c.IsCollabo == customerType || c.IsCollabo == null))))));
            return result.OrderBy(x => x.CustomerName).ToList();
        }

        public IEnumerable<Customer> GetCustomersByIds(List<int?> customerIds)
        {
            var result = Get(Query.WithFilter(Filter<Customer>
                   .Create(p => customerIds.Contains(p.CustomerId))))
                   .OrderBy(c=> c.CustomerCode);
            return result;
        }
        public IEnumerable<Customer> GetCustomersByCustomerCode(List<string?> customercodes)
        {
            var result = Get(Query.WithFilter(Filter<Customer>
                   .Create(p => customercodes.Contains(p.CustomerCode))))
                   .OrderBy(c => c.CustomerCode);
            return result;
        }
    }
} 
