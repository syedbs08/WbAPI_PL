using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.AspNetCore.Http;
using PSI.Domains.Entity;

namespace PSI.Modules.Backends.DirectSales.Command
{
    public class SSDForecastUpload
    {
        public int FileTypeId { get; set; }
        public IFormFile? File { get; set; }
        public string FolderPath { get; set; } = string.Empty;
    }

    public class SSDForecastUploadCommand : IRequest<Result>
    {
        public SSDForecastUploadCommand(SSDForecastUpload ssdForecastUpload,SessionData sessionData)
        {
            SSDForecastUpload = ssdForecastUpload;
            SessionData = sessionData;
        }
        public SSDForecastUpload SSDForecastUpload { get; set; }
        public SessionData SessionData { get; set; }
    }


    public class SSDEntryData
    {
        public SSDEntryData()
        {
            SSDEntryRows = new List<SSDEntryRow>();
            SSDQtyPriceInfos = new List<SSDQtyPriceInfo>();
            ResponseList = new List<SP_Insert_SSD_Entries>();
            IsValidSheet = false;
        }
        public List<SSDEntryRow> SSDEntryRows { get; set; }
        public List<SSDQtyPriceInfo> SSDQtyPriceInfos { get; set; }
        public List<SP_Insert_SSD_Entries> ResponseList { get; set; }
        public bool IsValidSheet { get; set; }
    }

    public class SSDEntryRow
    {
        public int RowIndex { get; set; }
        public string UploadFlag { get; set; } = string.Empty;
        public string CustomerCode { get; set; } = string.Empty;
        public string MaterialCode { get; set; } = string.Empty;
        public string TypeCode { get; set; } = string.Empty;
    }

    public class SSDQtyPriceInfo
    {
        public int RowIndex { get; set; }
        public int ColIndex { get; set; }
        public int MonthYear { get; set; } = 0;
        public int Qty { get; set; } = 0;
        public  decimal Price { get; set; } = 0;
    }
}