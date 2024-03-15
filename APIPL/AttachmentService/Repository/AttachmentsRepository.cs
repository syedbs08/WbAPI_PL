


using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;

namespace AttachmentService.Repository
{
    public partial interface IAttachmentsRepository : IBaseRepository<Attachment>
    {
    }
    public partial class AttachmentsRepository : BaseRepository<Attachment>, IAttachmentsRepository
    {
        public AttachmentsRepository() : base(new PSIDbContext()) { }
    }

}