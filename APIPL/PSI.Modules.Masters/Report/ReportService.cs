using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.EntityFrameworkCore;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Report.Queries;
using PSI.Modules.Backends.SNS.Command;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Report
{

    public class ReportService: IReportService
    {
        private IMediator _mediator;
        private readonly PSIDbContext _context;
        public ReportService(IMediator mediator)
        {
            _mediator = mediator;
            _context = new PSIDbContext();
        }
        public async Task<Result> GetConsolidatedReport(ConsolidatedReportSearchQuery query)
        {
            var result = await _mediator.Send(query);
            return result;
        }
        public async Task<Result> GetAccurencyReport(AccurencyReportSearchQuery query)
        {
            var result = await _mediator.Send(query);
            return result;
        }
        public async Task<Result> GetNonConsolidatedReport(NonConsolidatedReportSearchQuery query)
        {
            var result = await _mediator.Send(query);
            return result;
        }
        public async Task<List<ReportVariant>> GetReportVariant(string userId, string? reportType)
        {
            var result = await _context.ReportVariant.Where(x=>x.UserId==userId && x.ReportType== reportType).AsNoTracking().ToListAsync();
            return result;
        }
    }
}
