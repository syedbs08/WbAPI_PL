


using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;

namespace AttachmentService.Repository
{
    public partial interface IVW_AttachmentRepository : IBaseRepository<VW_ATTACHMENT>
    {
    }
    public partial class VW_AttachmentRepository : BaseRepository<VW_ATTACHMENT>, IVW_AttachmentRepository
    {
        public VW_AttachmentRepository() : base(new PSIDbContext()) { }
    }

}