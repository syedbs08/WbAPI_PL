

namespace AttachmentService.Result
{
    public class FileUploadResult
    {
        public int Id { get; set; }
        public string Extension { get; set; }
        public string DocumentName { get; set; }
        public DateTime? UploadedOn { get; set; }
        public string UploadedBy { get; set; }
        public bool? IsActive { get; set; }
        public string DocumentPath { get; set; }
        public string VirtualFileName { get; set; }
        public string Base64String { get; set; }
        public int? FileTypeId { get; set; }
        public string FileTypeName { get; set; }
       public byte[] FileBytes { get; set; }
    }
}
