

using Microsoft.AspNetCore.Http;

namespace PSI.Modules.Backends.Transmission.Command
{
    public class DashTransmitCommand
    {
        public int FileTypeId { get; set; }
        public IFormFile? File { get; set; }
        public string FolderPath { get; set; } = string.Empty;
    }
}
