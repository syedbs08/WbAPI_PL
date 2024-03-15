using Core.BaseUtility;


namespace PSI.Domains.Entity
{
    public partial class SP_SalesEntryOCConfirmation:BaseEntity
    {
        public string? OCstatus { get; set; }
        //public int? SalesEntryPriceQuantityId { get; set; }
        public int? SalesEntryId { get; set; }
        public string MonthYear { get; set; }
        public decimal? Price { get; set; }
        public int? CurrentMonthQty { get; set; }
        public int? ConfirmedQty { get; set; }
        public string? CustomerCode { get; set; }
        public string? CustomerName { get; set; }
        public string? MaterialCode { get; set; }
        public string? Mg { get; set; }
        public string? Mg1 { get; set; }  
        public int? Differences { get; set; }
       // public int? SaleEntryHeaderId { get; set; }
       // public int? OldSaleEntryHeaderId { get; set; }
        //public int? OldPriceQtyId { get; set; }
        public int? OldSaleEntryId { get; set; }
        public bool IsCollabo { get; set; }
        public string? ModeofTypeName { get; set; }

    }
}
