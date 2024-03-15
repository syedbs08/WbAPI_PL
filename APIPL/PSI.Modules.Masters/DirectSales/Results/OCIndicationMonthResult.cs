using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.DirectSales.Results
{
    public class OCIndicationMonthResult
    {
        public int? SalesEntryId { get; set; }
        public int? CustomerId { get; set; }
        public int? SalesEntryPriceQuantityId { get; set; }
        public int? CompanyId { get; set; }
        public string? MonthYear { get; set; }
        public int? CountryId { get; set; }
        public string? CustomerCode { get; set; }
        public string? CustomerName { get; set; }
        public string? MaterialCode { get; set; }
        public int? ProductCategoryId1 { get; set; }
        public int? ProductCategoryId2 { get; set; }
        public string? Mg { get; set; }
        public string? Mg1 { get; set; }
        public int? OrderQunatity { get; set; }
        public int? SNSQunatity { get; set; }
        public int? TotalQunatity { get; set; }
        public decimal? OrderPrice { get; set; }
        public decimal? SNSPrice { get; set; }
        public decimal? TotalPrice { get; set; }
        public decimal? Order_Amount { get; set; }
        public decimal? SNSAmount { get; set; }
        public decimal? Amount { get; set; }
        public bool? IsSNS { get; set; }
        public string? Reason { get; set; }
        public string? Remarks { get; set; }
        public string? OcIndicationMonthStatus { get; set; }
        public List<AttachementResult> Attachements { get; set; }
    }
    public class AttachementResult
    {
        public string OcIndicationMonthAttachmentIdFile { get; set; }
        public string OcIndicationMonthAttachmentIdBlobFile { get; set; }
    }
  
}
