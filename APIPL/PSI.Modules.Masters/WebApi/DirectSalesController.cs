
using Microsoft.AspNetCore.Mvc;
using PSI.Modules.Backends.DirectSales.Command;
using PSI.Modules.Backends.DirectSales;
using SessionManagers.AuthorizeService.services;
using System.Net;
using PSI.Modules.Backends.Constants;
using PSI.Modules.Backends.DirectSales.Results;
using Core.BaseUtility.Utility;
using PSI.Modules.Backends.DirectSales.Queries;
using Microsoft.AspNetCore.Authorization;

namespace PSI.Modules.Backends.WebApi
{
    [Authorize]
    [Route("api/v1/directsales")]
    public class DirectSaleController : SessionServiceBase
    {
        private readonly IDirectSaleService _directSaleService;
    
        public DirectSaleController(IDirectSaleService directSaleService)
        {
            _directSaleService = directSaleService;
        }
        #region ocIndicationMonth
       
        [HttpPost]
        [Route("get-ocIndication-month")]
        public async Task<IActionResult> GetOCIndicationMonth(DataSourceLoadOptions loadOptions, OCIndicationMonthSearchCommand obj)
        {
            if (SessionMain == null || string.IsNullOrWhiteSpace(SessionMain.ADUserId)
                    || !SessionMain.Roles.Any())
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            bool isSupeAdmin =  SessionMain.Roles.Contains(Contants.ADMIN_ROLE);
            var result = await _directSaleService.GetOcIndicationMonth(loadOptions, obj, SessionMain.ADUserId, isSupeAdmin, SessionMain);

            return Ok(result);
        }
        [HttpPost]
        [Route("update-ocIndication-month")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UpdateOCIndicationMonth(OCIndicationMonthCommand command)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            var result = await _directSaleService.UpdateOCIndicationMonth(command, SessionMain);
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok(result);
        }
        #endregion

        #region Direct Sales Agency Upload
        /// <summary>
        /// Upload Direct Sales File
        /// </summary>
        /// <param name="directSale"></param>
        /// <returns></returns>
        [HttpPost, DisableRequestSizeLimit]
        [Route("upload-agent-direct-sale")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UploadFiles(DirectSale directSale)
        {
            ModelState.Remove("ProductSubCategoryId");
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = await _directSaleService.UploadFiles(new DirectSalesCommand(directSale, SessionMain));
            
            return Ok(result);
        }

        [HttpPost]
        [Route("get-agent-sale-summary")]
        public async Task<IActionResult> GetAgentSaleSummary(DirectSalesDownload directSalesDownload)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _directSaleService.GetOrDownloadAgentSaleSummary(new DirectSalesDownloadCommand(directSalesDownload, SessionMain));
            return Ok(result);
        }

        [HttpPost]
        [Route("download-agent-summary")]
        public async Task<IActionResult> DownloadFile(DirectSalesDownload directSalesDownload)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _directSaleService.GetOrDownloadAgentSaleSummary(new DirectSalesDownloadCommand(directSalesDownload, SessionMain));
            if (result.IsSuccess)
            {
                var fileResponse = ((Core.BaseUtility.Utility.Result<SalesEntryDownloadFileResult>)result).Value;
                return File(fileResponse.FileContent, Contants.EXCEL_MEDIA_TYPE, fileResponse.FileName + fileResponse.FileExtension);
            }
            else
            {
                if (result.Errors.FirstOrDefault() == "No attachment found")

                {
                    return Ok(result);

                }
                else
                {
                    return BadRequest(result);
                }
            }
        }

        #endregion

        #region Direct Sales-OCO-Lock Months
        [HttpPost]
        [Route("oco-Lock-month")]
        public async Task<IActionResult> GetOcoLockmonth(DataSourceLoadOptions loadOptions, OCOLockMonthSearchCommand command)
        {
            if (SessionMain == null || string.IsNullOrWhiteSpace(SessionMain.ADUserId)
                    || !SessionMain.Roles.Any())
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            bool isSupeAdmin =  SessionMain.Roles.Contains(Contants.ADMIN_ROLE);
            var result = await _directSaleService.GetOCOLockMonth(loadOptions, command, SessionMain.ADUserId, isSupeAdmin);
            return Ok(result);
        }

        [HttpPost]
        [Route("update-lockcurrentmonth")]
        public async Task<IActionResult> UpdateLockCurretnMonth([FromBody] List<OCOLockMonthCommand> lockMonths)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }

            var result = await _directSaleService.UpdateSaleEntryStatus(lockMonths, SessionMain);
            return Ok(result);
        }
        #endregion

        #region SSD

        /// <summary>
        /// Upload SSD ForeCast
        /// </summary>
        /// <param name="directSale"></param>
        /// <returns></returns>
        [HttpPost, DisableRequestSizeLimit]
        [Route("upload-ssd-forecast")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UploadSSDForeCast(SSDForecastUpload ssdForecastUpload)
        {
           
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = await _directSaleService.UploadSSDForeCast(new SSDForecastUploadCommand(ssdForecastUpload, SessionMain));
            
            return Ok(result);
        }

        #endregion


        [HttpPost]
        [Route("directsale-report")]
        public async Task<IActionResult> GetDirectSaleReport(DirectSaleReport directSale)
        {
            try
            {
                if (SessionMain == null)
                {
                    return BadRequest(HttpStatusCode.Unauthorized);
                }

                var result = await _directSaleService.GetDirectSaleReport(new DirectSaleReportSearchQuery(directSale));
                return Ok(result);
            }
            catch (Exception ex)
            {
                Log.Error($"Error in GetDirectSaleReport Report with Message - {ex.Message}. StackTrace - {ex.StackTrace}");
                return Ok(Result.Failure(Contants.ERROR_MSG));
            }
        }
    }
}