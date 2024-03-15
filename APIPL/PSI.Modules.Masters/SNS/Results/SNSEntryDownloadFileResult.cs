using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.SNS.Results
{
    public partial class SNSEntryDownloadFileResult
    {
        public byte[] FileContent { get; set; }
        public string FileName { get; set; }
        public string FileExtension { get; set; }
    }
}
