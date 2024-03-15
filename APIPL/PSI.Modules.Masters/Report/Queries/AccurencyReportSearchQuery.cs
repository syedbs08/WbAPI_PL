using Core.BaseUtility.Utility;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Report.Queries
{
    public class AccurencyReportSearchQuery : IRequest<Result>
    {
        public AccurencyReportSearchQuery(AccurencyReportSearch accurencyReport, SessionData sessionData)
        {
            AccurencyReportSearch = accurencyReport;
            SessionData = sessionData;
        }
        public AccurencyReportSearch AccurencyReportSearch { get; set; }
        public SessionData SessionData { get; set; }
    }

    public class AccurencyReportSearch
    {
    

        public List<string?> CustomerCode { get; set; }
        public int? ProductCategoryId1 { get; set; }
        public int? ProductCategoryId2 { get; set; }
        public int? ProductCategoryId3 { get; set; }
        public string? StartMonthYear { get; set; }
        public string? EndMonthYear { get; set; }
        public string? Variant { get; set; }

    }
}