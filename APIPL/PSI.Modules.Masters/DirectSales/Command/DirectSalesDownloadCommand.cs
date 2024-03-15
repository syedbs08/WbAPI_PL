using Core.BaseUtility.Utility;
using MediatR;

namespace PSI.Modules.Backends.DirectSales.Command
{
    public class DirectSalesDownloadCommand : IRequest<Result>
    {
        public DirectSalesDownloadCommand(DirectSalesDownload directSalesDownload, SessionData sessionData)
        {
            DirectSalesDownload = directSalesDownload;
            SessionData = sessionData;
        }
        public DirectSalesDownload DirectSalesDownload { get; set; }
        public SessionData SessionData { get; set; }
    }

    public class DirectSalesDownload
    {
        public int CustomerId { get; set; }
        public string ProductCategoryId { get; set; } = string.Empty;
        public string ProductSubCategoryId { get; set; } = string.Empty;
        public int? SaleTypeId { get; set; } = 1;
        public string SaleSubType { get; set; } = string.Empty;
        public bool IsUSDCurrency { get; set; } = false;
        public bool IsDownload { get; set; } = false;
        public int FromMonth { get; set; }
        public int ToMonth { get; set; }
    }
}
