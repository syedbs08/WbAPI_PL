using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.SNS.Command
{
    public class SNSEntriesCommand
    {
        public int SNSEntryId { get; set; }
        public int? SaleTypeId { get; set; }
        public int? CustomerId { get; set; }
        public string? CustomerCode { get; set; }
        public string? CustomerName { get; set; }
        public int? MaterialId { get; set; }
        public string? MaterialCode { get; set; }
        public int? CategoryId { get; set; } 
        public string? Category { get; set; }
        public int? AttachmentId { get; set; }
        public string? MonthYear { get; set; }
        public string? OACCode { get; set; }
        public string? SaleSubType { get; set; }
        public int? RowNum { get; set; }
        //public string? MonthYear { get; set; }
        public string? QtyMonthYear { get; set; }
        public int? Qty { get; set; }
        public decimal? Price { get; set; }
        public string? PriceMonthYear { get; set; }
        public decimal? FinalPrice { get; set; }
        public decimal? TotalAmount { get; set; }
        //public List<SNSEntriesQtyPriceDownload> SNSEntriesQtyPriceDownload { get; set; }

    }
    
    public class SNSEntriesQtyPriceDownload
    {
        public string? MonthYear { get; set; }
        public string? QtyMonthYear { get; set; }
        public int? Qty { get; set; }
        public decimal? Price { get; set; }
        public string? PriceMonthYear { get; set; }
        public decimal? FinalPrice { get; set; }
        public decimal? TotalAmount { get; set; }


    }
}
