
namespace PSI.Modules.Backends.DirectSales.Results
{
    public class SalesEntryDownloadResult
    {
        public string ItemCode { get; set; }
        public string ModeOfType { get; set; }
        public string MonthYear { get; set; }
        public int Quantity { get; set; }
        public decimal Price { get; set; }
        public string Currency { get; set; }
        public decimal Amount { get; set; }
    }

    public class SalesEntryDownloadFileResult
    {
        public byte[] FileContent { get; set; }
        public string FileName { get; set; }
        public string FileExtension { get; set; }
    }
}
