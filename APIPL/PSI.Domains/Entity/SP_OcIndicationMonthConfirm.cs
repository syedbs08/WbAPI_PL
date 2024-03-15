using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class SP_OcIndicationMonthConfirm
    {
        public int? CustomerId { get; set; }
        public string? MonthYear { get; set; }
       public int? SalesEntryId { get; set; }
        public int? CompanyId { get; set; }
        public int? CountryId { get; set; }
        public string? CustomerCode { get; set; }
        public string? CustomerName { get; set; }
        public string? MaterialCode { get; set; }
        public int? ProductCategoryId1 { get; set; }
        public int? ProductCategoryId3 { get; set; }
        public string? Mg { get; set; }
        public string? Mg1 { get; set; }
        public int? OrderQunatity { get; set; }
        public int? SNSQunatity { get; set; }
        public int? TotalQunatity { get; set; }
        public decimal? OrderPrice { get; set; }
        public decimal? SNSPrice { get; set; }
        public decimal? TotalPrice { get; set; }
        public bool? IsSNS { get; set; }
        public string? Reason { get; set; }
        public string? Remarks { get; set; }
        public string? OcIndicationMonthStatus { get; set; }
        public string? OcIndicationMonthAttachmentIds { get; set; }
    }
}
