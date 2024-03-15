
using Microsoft.AspNetCore.Http;


namespace AttachmentService.Command
{
  public class FileCommand
    {
        public int FileTypeId { get; set; }
        //use only for single
        public IFormFile File { get; set; }
        public string FolderPath { get; set; }

        //pass value if u need to add multiple files
        public IList<IFormFile> Files { get; set; }
      
    }
}
