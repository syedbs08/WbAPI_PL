using Core.BaseUtility.Utility;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PSI.Modules.Backends.Constants;
using PSI.Modules.Backends.Report;
using PSI.Modules.Backends.Report.Queries;
using SessionManagers.AuthorizeService.services;
using System.Net;

namespace PSI.Modules.Backends.WebApi
{
    [Authorize]
    [Route("api/v1/report")]
    public class ReportController : SessionServiceBase
    {
        readonly private IReportService _reportService;
        public ReportController(IReportService reportService)
        {
            _reportService = reportService;
        }
        [HttpPost]
        [Route("accurency-report")]
        public async Task<IActionResult> GetAccurencyReport([FromBody] AccurencyReportSearch accurencyReport)
        {
            try
            {
                if (SessionMain == null)
                {
                    return BadRequest(HttpStatusCode.Unauthorized);
                }

                var result = await _reportService.GetAccurencyReport(new AccurencyReportSearchQuery(accurencyReport, SessionMain));
                return Ok(result);
            }
            catch (Exception ex)
            {
                Log.Error($"Error in Consolidated Report with Message - {ex.Message}. StackTrace - {ex.StackTrace}");
                return Ok(Result.Failure(Contants.ERROR_MSG));
            }
        }

        [HttpPost, DisableRequestSizeLimit]
        [Route("consolidated-report")]
        public async Task<IActionResult> GetConsolidatedReport([FromBody] ConsolidatedReportSearch consolidatedReport)
        {

            try
            {
                if (SessionMain == null)
                {
                    return BadRequest(HttpStatusCode.Unauthorized);
                }
                var result = await _reportService.GetConsolidatedReport(new ConsolidatedReportSearchQuery(consolidatedReport, SessionMain));
                return Ok(result);
            }
            catch (Exception ex)
            {
                Log.Error($"Error in Consolidated Report with Message - {ex.Message}. StackTrace - {ex.StackTrace}");
                return Ok(Result.Failure(Contants.ERROR_MSG));
            }
        }

        [HttpPost, DisableRequestSizeLimit]
        [Route("non-consolidated-report")]
        public async Task<IActionResult> GetNonConsolidatedReport([FromBody] NonConsolidatedReportSearch nonConsolidatedReportSearch)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            var result = await _reportService.GetNonConsolidatedReport(new NonConsolidatedReportSearchQuery(nonConsolidatedReportSearch, SessionMain));
            return Ok(result);
        }

        [HttpGet]
        [Route("report-variant/{reportType}")]
        public async Task<IActionResult> getReportVariant(string? reportType)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            var result = await _reportService.GetReportVariant(SessionMain.ADUserId, reportType);
            return Ok(result.Select(x=>x.VariantName).Distinct());

        }
    }
}
