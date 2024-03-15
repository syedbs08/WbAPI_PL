using Core.BaseUtility.Utility;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Report.Queries;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Report
{

    public interface IReportService
    {
        Task<Result> GetConsolidatedReport(ConsolidatedReportSearchQuery query);
        Task<Result> GetAccurencyReport(AccurencyReportSearchQuery query);
        Task<Result> GetNonConsolidatedReport(NonConsolidatedReportSearchQuery query);
        Task<List<ReportVariant>> GetReportVariant(string userId, string? reportType);
    }
}
