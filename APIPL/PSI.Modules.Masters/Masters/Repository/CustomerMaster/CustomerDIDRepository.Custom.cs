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
    public partial interface ICustomerDIDRepository
    {
        CustomerDID GetCustomer(int customerId, int oacAccountId);
        bool ValidateSNSCustomer(int customerId, int oacAccountId);
        CustomerDID ValidateANDGetSaleTypeID(int customerId, int oacAccountId);

    }
    public partial class CustomerDIDRepository
    {
      
        public CustomerDID GetCustomer(int customerId, int oacAccountId)
        {
            var result = FirstOrDefault(Query.WithFilter(Filter<CustomerDID>
                            .Create(p => (p.CustomerId == customerId || p.AccountId == oacAccountId))
                            ));
            return result;
        }

        public bool ValidateSNSCustomer(int customerId, int oacAccountId)
        {
            var result = FirstOrDefault(Query.WithFilter(Filter<CustomerDID>
                            .Create(p => (p.CustomerId == customerId && p.AccountId == oacAccountId))
                            ));

            return result != null ? true : false;

           
        }

        public CustomerDID ValidateANDGetSaleTypeID(int customerId, int oacAccountId)
        {
            var result = FirstOrDefault(Query.WithFilter(Filter<CustomerDID>
                            .Create(p => (p.CustomerId == customerId && p.AccountId == oacAccountId))
                            ));
            return result;
        }

    }
} 
