




namespace AttachmentService.Repository
{
    public partial interface IVWAttachmentsRepository : IBaseRepository<VwAttachments>
    {
    }
    public partial class VWAttachmentsRepository : BaseRepository<VwAttachments>, IVWAttachmentsRepository
    {
        public VWAttachmentsRepository() : base(new AttachmentsContext()) { }
    }
}	