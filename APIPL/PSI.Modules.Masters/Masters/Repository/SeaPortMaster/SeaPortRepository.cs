using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.SeaPortMaster
{
    public partial interface  ISeaPortRepository:IBaseRepository<SeaPort>
    {
    }
    public partial class SeaPortRepository:BaseRepository<SeaPort>, ISeaPortRepository
    {
        public SeaPortRepository():base(new PSIDbContext()) { }
    }
}
