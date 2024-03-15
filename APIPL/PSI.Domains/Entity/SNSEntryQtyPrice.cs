﻿using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public class SNSEntryQtyPrice : BaseEntity
    {
        public int SNSEntryQtyPriceId { get; set; }
        public int? SNSEntryId { get; set; }
        public string? MonthYear { get; set; }
        public int? Qty { get; set; }
        public decimal? Price { get; set; }
        public decimal? FinalPrice { get; set; }
        public decimal? TotalAmount { get; set; }
        public string? Currency { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string? CreatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string? UpdatedBy { get; set; }
    }
}
