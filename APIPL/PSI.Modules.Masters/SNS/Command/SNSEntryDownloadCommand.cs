using Core.BaseUtility.Utility;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.SNS.Command
{
    public class SNSEntryDownloadCommand : IRequest<Result>
    {
        public SNSEntryDownloadCommand(SNSEntryDownload snsentrydownload, SessionData sessionData)
        {
            SNSEntryDownload = snsentrydownload;
            SessionData = sessionData;
        }
        public SNSEntryDownload SNSEntryDownload { get; set; }
        public SessionData SessionData { get; set; }
    }
    public partial class SNSEntryDownload
    {
        public string? CompanyCode { get; set; }
        public string? CountryCode { get; set; }
        public string? OACCode { get; set; }
        public string? CustomerCode { get; set; }
        public string? ProductCategoryId { get; set; }
        public string? ProductSubCategoryId { get; set; }
        public string? SaleSubType { get; set; }
        public bool IsDownload { get; set; } = false;
        public int? FromMonth { get; set; }
        public int? ToMonth { get; set; }
    }
}