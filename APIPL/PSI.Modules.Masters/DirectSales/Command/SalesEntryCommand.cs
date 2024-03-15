
namespace PSI.Modules.Backends.DirectSales.Command
{
     public class SalesEntryCommand
    {
       // public int SaleEntryHeaderId { get; set; }
        public int SaleEntryId { get;set; }
        public string ItemCode { get; set; } = string.Empty;
        public string ModelNo { get; set; } = string.Empty;
        public string TypeCode { get; set; } = string.Empty;
        public List<SalesEntryPriceQuantityCommand>? SalesEntryPriceQuantity { get; set; }
    }

    public class SalesEntryPriceQuantityCommand
    {
        public string PriceMonthName { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public string QtyMonthName { get; set; } = string.Empty;   
        public int Qty { get; set; }
        public string? Currency { get; set; }   
        public string MonthYear { get; set; } = string.Empty;  
    }
    public class SalesEntryCommandBP
    {
        // public int SaleEntryHeaderId { get; set; }
        public int SaleEntryId { get; set; }
        public string ItemCode { get; set; } = string.Empty;
        public string ModelNo { get; set; } = string.Empty;
        public string TypeCode { get; set; } = string.Empty;
        public string PriceMonthName { get; set; } = string.Empty;
        public decimal? Price { get; set; }
        public string QtyMonthName { get; set; } = string.Empty;
        public int? Qty { get; set; }
        public int? AttachmentId { get; set; }
        public string? Currency { get; set; }
        public string MonthYear { get; set; } = string.Empty;
    }
}
