using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Domains;
using PSI.Modules.Backends.Masters.Repository.CustomerMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.CustomerMaster
{
    public partial interface ICustomerViewReopsitory : IBaseRepository<CustomerView>
    {
    }
    public partial class CustomerViewReopsitory : BaseRepository<CustomerView>, ICustomerViewReopsitory
    {
        public CustomerViewReopsitory() : base(new PSIDbContext()) { }

    }
}