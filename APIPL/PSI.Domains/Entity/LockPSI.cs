using Core.BaseUtility;

namespace PSI.Domains.Entity
{
    public partial class LockPSI : BaseEntity
    {
        public int LockPSIId { get; set; }
        public string? UserId { get; set; }
        public string? CustomerCode { get; set; }
        public string? SubCategoryCode { get; set; }
        public bool? OPSI_Upload { get; set; }
        public bool? COG_Upload { get; set; }
        public bool? O_LockMonthConfirm { get; set; }
        public bool? OC_IndicationMonth { get; set; }
        public bool? BP_Upload_DirectSale { get; set; }
        public bool? BP_Upload_SNS { get; set; }
        public bool? BP_COG_Upload { get; set; }
        public bool? ADJ_Upload { get; set; }
        public bool? SSD_Upload { get; set; }
        public bool? SNS_Sales_Upload { get; set; }
        public bool? Forecast_Projection { get; set; }
        public bool? SNS_Planning { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string? CreatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string? UpdatedBy { get; set; }
        
    }
}
