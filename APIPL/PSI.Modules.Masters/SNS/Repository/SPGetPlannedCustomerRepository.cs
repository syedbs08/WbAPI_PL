using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.SNS.Repository
{
    public partial interface ISPGetPlannedCustomerRepository : IBaseRepository<SP_GET_PLANNEDCUSTOMER>
    {
    }
    public partial class SPGetPlannedCustomerRepository : BaseRepository<SP_GET_PLANNEDCUSTOMER>, ISPGetPlannedCustomerRepository
    {
        public SPGetPlannedCustomerRepository() : base(new PSIDbContext()) { }
    }
   
}
