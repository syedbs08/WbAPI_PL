using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Transmission.Repository
{
    public partial interface ITransmissionListRepository: IBaseRepository<TransmissionList>
    {
    }
    public partial class TransmissionListRepository:BaseRepository<TransmissionList>,ITransmissionListRepository
    {
        public TransmissionListRepository(): base(new PSIDbContext()) { }
    }
}
