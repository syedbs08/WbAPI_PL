using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Repository.MaterialMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.CustomerMaster
{
    public partial interface ICustomerRepository : IBaseRepository<Customer>
    {
    }
    public partial class CustomerRepository : BaseRepository<Customer>, ICustomerRepository
    {
        public CustomerRepository() : base(new PSIDbContext()) { }
    }
}
