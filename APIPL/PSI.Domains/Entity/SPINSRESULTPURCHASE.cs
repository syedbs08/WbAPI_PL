using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public class SPINSRESULTPURCHASE:BaseEntity
    {
        public int MST_ResultPurchaseId { get; set; }
        public int? MonthYear { get; set; }
        public string MaterialCode { get; set; }
        public string AccountCode { get; set; }
        public int? Quantity { get; set; }
        public decimal? Amount { get; set; }
        public int? DistributorChaneltId { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? UpdateDate { get; set; }
        public string? UpdateBy { get; set; }
        public string? ATP_CASE { get; set; }
        public string? Plant { get; set; }
    }
}
