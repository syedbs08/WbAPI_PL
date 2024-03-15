using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class SNSEntryArchive:BaseEntity
    {
        public int ID { get; set; }
        public int? SNSEntryID { get; set; }
        public int? SaleTypeId { get; set; }
        public int? CustomerId { get; set; }
        public string? CustomerCode { get; set; }
        public int? MaterialId { get; set; }
        public string? MaterialCode { get; set; }
        public int? CategoryId { get; set; }
        public int? AttachmentId { get; set; }
        public int? MonthYear { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string? CreatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string? UpdatedBy { get; set; }
        public int? ModeofTypeId { get; set; }
        public DateTime? ArchiveDate { get; set; }
        public string? ArchiveBy { get; set; }
        public string? ArchiveStatus { get; set; }
    }
}
