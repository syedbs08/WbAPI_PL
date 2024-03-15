using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;


namespace PSI.Modules.Backends.DirectSales.Repository
{
    public partial interface ISPSalesEntryOCConfirmationRepository : IBaseRepository<SP_SalesEntryOCConfirmation>
    {

    }
    public partial class SPSalesEntryOCConfirmationRepository : BaseRepository<SP_SalesEntryOCConfirmation>, ISPSalesEntryOCConfirmationRepository
    {
        public SPSalesEntryOCConfirmationRepository():base(new PSIDbContext())
        {

        }
    }
}
