using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class SalesArchivalEntryPriceQuantity : BaseEntity
    {
        public int SalesArchivalEntryPriceQuantityId { get; set; }
        public int? SalesEntryId { get; set; }
        public int? ModeofTypeId { get; set; }
        public int? CurrencyId { get; set; }
        public string? MonthYear { get; set; }
        public decimal? Price { get; set; }
        public int? Quantity { get; set; }
        public string? OrderIndicationConfirmedBySaleTeam { get; set; }
        public DateTime? OrderIndicationConfirmedBySaleTeamDate { get; set; }
        public string? OrderIndicationConfirmedByMarketingTeam { get; set; }
        public DateTime? OrderIndicationConfirmedByMarketingTeamDate { get; set; }
        public string? O_LockMonthConfirmedBy { get; set; }
        public DateTime? O_LockMonthConfirmedDate { get; set; }
        public string? Reason { get; set; }
        public bool? IsSNS { get; set; }
        public bool? IsPO { get; set; }
        public string? TermId { get; set; }
        public int? AttachmentId { get; set; }
        public string? Remarks { get; set; }
        
    }
}
