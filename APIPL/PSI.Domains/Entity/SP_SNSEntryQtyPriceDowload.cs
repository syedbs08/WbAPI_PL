using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class SP_SNSEntryQtyPriceDowload : BaseEntity
    {
      
        public int SNSEntryQtyPriceId { get; set; }
        public int SNSEntryId { get; set; }
        public string? MonthYear { get; set; }
        public int? Qty { get; set; }
        public decimal? Price { get; set; }
        public decimal? TotalAmount { get; set; }
    }
}