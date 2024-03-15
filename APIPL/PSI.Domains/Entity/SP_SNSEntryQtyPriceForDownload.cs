using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public  class SP_SNSEntryQtyPriceForDownload : BaseEntity
    {
        public int? Id { get;set; }
        public string? CustomerCode { get;set; }
        public  string? CustomerName { get;set; }
        public string? MaterialCode { get;set; }
        public int? MonthYear { get;set; }
        public int? Quantity { get;set; }
        public decimal? Price { get;set; }
        public decimal? TotalPrice { get; set; }
        public string? ProductCategoryName2 { get; set; }
    }
}
