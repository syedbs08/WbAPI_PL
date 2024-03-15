using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;


namespace PSI.Modules.Backends.Transmission.Repository
{
    public partial interface IDashTransmitRepository : IBaseRepository<DashTransmit>
    {
    }
    public partial class DashTransmitRepository : BaseRepository<DashTransmit>, IDashTransmitRepository
    {
        public DashTransmitRepository(): base(new PSIDbContext()) { }
    }
}
