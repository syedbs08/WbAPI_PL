
namespace AttachmentService.Result
{
    public class BlobFileResult
    {
        public Stream Content { get; set; }
        public string Name { get; set; }
        public string ContentType
        {
            get; set;
        }
    }

}
