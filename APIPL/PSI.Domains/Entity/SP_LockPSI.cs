using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public class SP_LockPSI:BaseEntity
    {
        public int LockPSIId { get; set; }
        public string? UserId { get; set; }
        public string? Name { get; set; }
        public string? CustomerName { get; set; }
        public string? SubcategoryName { get; set; }
        public string? CountryIds { get; set; }
        public string? CustomerId { get; set; }
        public string? SubcategoryId { get; set; }
        public bool? OPSI { get; set; }
        public bool? COG { get; set; }
        public bool? O_LockMonthConfirm { get; set; }
        public bool? OC_IndicationMonth { get; set; }
        public bool? BP_Upload_DirectSale { get; set; }
        public bool? BP_Upload_SNS { get; set; }
        public bool? BP_COG_Upload { get; set; }
        public bool? ADJ { get; set; }
        public bool? SSD { get; set; }
        public bool? SNS { get; set; }
        public bool? Forecast_Projection { get; set; }
        public bool? SNS_Planning { get; set; }
    }
}
