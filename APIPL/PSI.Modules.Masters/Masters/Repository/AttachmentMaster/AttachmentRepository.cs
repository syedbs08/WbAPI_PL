

using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;

namespace PSI.Modules.Backends.Masters.Repository.AttachmentMaster
{
    public partial interface IAttachmentRepository : IBaseRepository<Attachment>
    {
    }
    public partial class AttachmentRepository : BaseRepository<Attachment>, IAttachmentRepository
    {
        public AttachmentRepository() : base(new PSIDbContext()) { }
    }
}
