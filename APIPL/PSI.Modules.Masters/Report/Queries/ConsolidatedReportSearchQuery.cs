using Core.BaseUtility.Utility;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Report.Queries
{
    public class ConsolidatedReportSearchQuery : IRequest<Result>
    {
        public ConsolidatedReportSearchQuery(ConsolidatedReportSearch consolidatedReport, SessionData sessionData)
        {
            ConsolidatedReportSearch = consolidatedReport;
            SessionData = sessionData;
        }
        public ConsolidatedReportSearch ConsolidatedReportSearch { get; set; }
        public SessionData SessionData { get; set; }
    }
    public class ConsolidatedReportSearch
    {
        public List<string?> CustomerCode { get; set; }
        public int? ProductCategoryId1 { get; set; }
        public int? ProductCategoryId2 { get; set; }
        public string? SalesSubType { get; set; }
        public string? StartMonthYear { get; set; }
        public string? EndMonthYear { get; set; }
        public List<string?> AdditionalValue { get; set; }
        public string? Variant { get; set; }
    }
}
