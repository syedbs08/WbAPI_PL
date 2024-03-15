using Core.BaseUtility.Utility;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Report.Queries
{
    public class NonConsolidatedReportSearchQuery : IRequest<Result>
    {
        public NonConsolidatedReportSearchQuery(NonConsolidatedReportSearch nonConsolidatedReport, SessionData sessionData)
        {
            NonConsolidatedReportSearch = nonConsolidatedReport;
            SessionData = sessionData;
        }
        public NonConsolidatedReportSearch NonConsolidatedReportSearch { get; set; }
        public SessionData SessionData { get; set; }
    }
    public class NonConsolidatedReportSearch
    {
        public List<string?> CustomerCode { get; set; }
        public int? ProductCategoryId1 { get; set; }
        public int? ProductCategoryId2 { get; set; }
        public string? SalesSubType { get; set; }
        public string? StartMonthYear { get; set; }
        public string? EndMonthYear { get; set; }
        public List<string?> AdditionalValue { get; set; }
        public bool? IsUSD { get; set; }
        public string? Variant { get; set; }

    }
}
