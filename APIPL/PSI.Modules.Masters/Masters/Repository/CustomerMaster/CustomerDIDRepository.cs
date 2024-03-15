using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.CustomerMaster
{
    public partial interface ICustomerDIDRepository:IBaseRepository<CustomerDID>
    {
    }
    public partial class CustomerDIDRepository:BaseRepository<CustomerDID>, ICustomerDIDRepository
    {
        public CustomerDIDRepository():base(new PSIDbContext()){ }
    }

}
