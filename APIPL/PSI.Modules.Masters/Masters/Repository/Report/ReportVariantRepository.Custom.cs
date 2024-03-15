using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.AccountMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.Report
{
    public partial interface IReportVariantRepository
    {
        ReportVariant GetVariant(string userId, string reportType, string variantName);
        List<ReportVariant> GetReportVariantByName(string? variantName);

    }
    public partial class ReportVariantRepository
    {
        public ReportVariant GetVariant(string userId, string reportType, string variantName)
        {
            var result = FirstOrDefault(Query.WithFilter(Filter<ReportVariant>
                   .Create(p => p.UserId == userId && p.ReportType==reportType && p.VariantName== variantName
                   )));
            return result;
        }
        public List<ReportVariant> GetReportVariantByName(string? variantName)
        {
            var filterExpression = Filter<ReportVariant>.Create(p => p.VariantName == variantName);
            var result = Get(Query.WithFilter(filterExpression));
            return result.ToList();
        }
    }
}
