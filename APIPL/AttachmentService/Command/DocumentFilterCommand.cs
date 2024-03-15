using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AttachmentService.Command
{
    public class DocumentFilterCommand
    {
        public string DocumentMonth { get; set; }
        public string CreatedBy { get; set; }
    }
}
