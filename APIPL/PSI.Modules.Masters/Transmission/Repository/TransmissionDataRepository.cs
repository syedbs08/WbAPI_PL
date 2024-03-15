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
    public partial interface ITransmissionDataRepository : IBaseRepository<TransmissionData>
    {
    }
    public partial class TransmissionDataRepository : BaseRepository<TransmissionData>, ITransmissionDataRepository
    {
        public TransmissionDataRepository(): base(new PSIDbContext()) { }
    }
}
