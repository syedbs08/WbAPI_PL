using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.SalesOrganizationMaster
{
    public partial interface ISalesOrganizationRepository:IBaseRepository<SalesOrganization>
    {
    }
    public partial class SalesOrganizationRepository:BaseRepository<SalesOrganization>,ISalesOrganizationRepository
    {
        public SalesOrganizationRepository():base(new PSIDbContext()) { }
    }
}
