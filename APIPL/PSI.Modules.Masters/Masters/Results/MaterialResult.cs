using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Results
{
    public class MaterialResult
    {
        public string? Company { get; set; }
        public string? Material { get; set; }
        public string? Description { get; set; }
        public string? MG { get; set; }
        public string? MG1 { get; set; }
        public string? MG2 { get; set; }
        public string? MG3 { get; set; }
        public string? MG4 { get; set; }
        public string? MG5 { get; set; }
        public string? BarCode { get; set; }
        public decimal? Weight { get; set; }
        public decimal? Volume { get; set; }
        public string? Supplier { get; set; }
        public string SeaPort { get; set; }
        public string? AirPort { get; set; }
        public string Countries { get; set; }
        public string? IsActive { get; set; }
        public string? InSap { get; set; }
        public string? CreatedDate { get; set; }
        public string? CreatedBy { get; set; }
        public string? UpdateDate { get; set; }
        public string? UpdateBy { get; set; }
    }
}
