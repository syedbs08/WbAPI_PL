using AttachmentService.Command;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.DirectSales.Command
{
    public class OCIndicationMonthCommand
    {
        public string? SalesEntryId { get; set; }
        public string? CustomerId { get; set; }
        public string? MaterialCode { get; set; }
        public string? Reason { get; set; }
        public bool? IsSNS { get; set; }
        public int? TermId { get; set; }
        public bool? IsPO { get; set; } 
        public string? Status { get; set; }
        public string? Remarks { get; set; }
        public string FolderPath { get; set; }
        public IList<IFormFile> files { get; set; }
    } 
}
