using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.SaleTypeMaster
{
    public partial interface ISaleTypeRepository:IBaseRepository<SaleType>
    {
    }
    public partial class SaleTypeRepository:BaseRepository<SaleType>, ISaleTypeRepository
    {
        public SaleTypeRepository():base(new PSIDbContext()) { }
    }
}
