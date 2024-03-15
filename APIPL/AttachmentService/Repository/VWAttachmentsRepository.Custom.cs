

using AttachmentService.Entity;
using Core.BaseEntitySql.BaseRepository;

namespace AttachmentService.Repository
{
    public partial interface IVWAttachmentsRepository
    {
        VwAttachments GetByAttachmentId(long id);
    }
    public partial class VWAttachmentsRepository
    {
        public VwAttachments GetByAttachmentId(long id)
        {
            var query = Query.WithFilter(
                 Filter<VwAttachments>.Create(p => p.Id == id)
                 );
            var result = FirstOrDefault(query);
            return result;
        }
        
    }
}