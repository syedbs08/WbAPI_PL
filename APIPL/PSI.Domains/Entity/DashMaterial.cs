using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class DashMaterial:BaseEntity
    {
        public int DashMaterialId { get; set; }
        public string? MaterialCode { get; set; }
        public string? CustomerCode { get; set; }
        public string? SalesCompany { get; set; }
        public string? SupplierCode { get; set; }
        public int? ReasonId { get; set; }
        public int? StartMonth { get; set; }
        public int? EndMonth { get; set; }
        public string? TransPortMode { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string? CreatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string? UpdatedBy { get; set; }
        public string? FileName { get; set; }
        public DateTime? RegistrationDateTime { get; set; }
        public string? RegistrationUserCode { get; set; }
        public DateTime? RecordChangeDateTime { get; set; }
        public string? RecordChangeUserCode { get; set; }
        public bool? IsActive { get; set; }
    }
}
