using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Results
{
    public class CustomerResult
    {
        public string? CustomerCode { get; set; }
        public string? CustomerName { get; set; }
        public string? ShortName { get; set; }
        public string? Region { get; set; }
        public string? Department { get; set; }
        public string? Country{ get; set; }
        public string? SalesOffice { get; set; }
        public string? PIC{ get; set; }
        public bool? PSI { get; set; }
        public bool? BP { get; set; }
        public bool? IsActive { get; set; }
        public bool? IsCollabo { get; set; }
        public string? CreatedBy { get; set; }
        public string? CreatedDate { get; set; }
        public string? UpdateBy { get; set; }
        public string? UpdateDate { get; set; }
        public string? Type { get; set; }
        public string? SalesOrganizationCode { get; set; }

    }
}
