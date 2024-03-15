using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.AirPortMaster
{
    public partial interface IAirPortRepository:IBaseRepository<AirPort>
    {
    }
    public partial class AirPortRepository:BaseRepository<AirPort>, IAirPortRepository
    {
        public AirPortRepository():base(new PSIDbContext())
        {

        }
    }
}
