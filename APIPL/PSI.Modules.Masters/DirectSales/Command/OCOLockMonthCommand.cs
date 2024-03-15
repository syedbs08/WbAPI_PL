namespace PSI.Modules.Backends.DirectSales.Command
{
    public class OCOLockMonthCommand
    {

        public int SalesEntryPriceQuantityId { get; set; }
        public int SalesEntryId { get; set; }
        public int OldSaleEntryHeaderId { get; set; }
        public int OldPriceQtyId { get; set; }
        public int OldSaleEntryId { get; set; }
    }
    
}
