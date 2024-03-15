using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class SNSEntryQtyPriceArchive:BaseEntity
    {
        public int ID { get; set; }
        public int? SNSEntryQtyPriceId { get; set; }
        public int? SNSEntryId { get; set; }
        public int? MonthYear { get; set; }
        public int? Qty { get; set; }
        public decimal? Price { get; set; }
        public decimal? TotalAmount { get; set; }
        public int? CurrencyId { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string? CreatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string? UpdatedBy { get; set; }
        public DateTime? ArchiveDate { get; set; }
        public string? ArchiveBy { get; set; }
        public string? ArchiveStatus { get; set; }

    }
}
