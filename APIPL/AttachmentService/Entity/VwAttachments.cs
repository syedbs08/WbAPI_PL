
using Core.BaseUtility;


namespace AttachmentService.Entity
{
    public partial class VwAttachments : BaseEntity
    {
        public int Id { get; set; }
        public string AttachmentKey { get; set; }
        public string Extension { get; set; }
        public string DocumentName { get; set; }
        public bool? IsActive { get; set; }
        public string DocumentPath { get; set; }
        public string Base64Url { get; set; }
        public string DrivePath { get; set; }
        public int? UploadedBy { get; set; }
        public DateTime? UploadedOn { get; set; }
        public int? FileTypeId { get; set; }
        public string VirtualFileName { get; set; }
        
    }
}
