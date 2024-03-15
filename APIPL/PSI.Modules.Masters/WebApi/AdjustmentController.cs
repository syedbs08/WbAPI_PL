using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PSI.Modules.Backends.Adjustments;
using PSI.Modules.Backends.Adjustments.Command;
using PSI.Modules.Backends.Adjustments.Queries;
using PSI.Modules.Backends.Constants;
using SessionManagers.AuthorizeService.services;
using System.Net;

namespace PSI.Modules.Backends.WebApi
{
    [Authorize]
    [Route("api/v1/adjustment")]
    public class AdjustmentController : SessionServiceBase
    {
        private readonly IAdjustmentService _adjustmentService;
        public AdjustmentController(IAdjustmentService adjustmentService)
        {
            _adjustmentService=adjustmentService;
        }
        #region Adjustment Upload
        [HttpPost]
        [Route("adjustment-upload-data")]
        public async Task<IActionResult> GetAdjustmentUpload(DataSourceLoadOptions loadOptions, AdjustmentUploadSearch obj)
        {
            if (SessionMain == null || string.IsNullOrWhiteSpace(SessionMain.ADUserId)
                    || !SessionMain.Roles.Any())
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            bool isSupeAdmin =SessionMain.Roles.Contains(Contants.ADMIN_ROLE);
            var result = await _adjustmentService.GetAdjustmentUpload(loadOptions, obj, SessionMain.ADUserId, isSupeAdmin);

            return Ok(result);
        }
        [HttpPost, DisableRequestSizeLimit]
        [Route("upload-adjustment-entry")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UploadFiles(AdjustmentEntryDetails adjustmentEntryDetails)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _adjustmentService.UploadFiles(new AdjustmentEntryUploadCommand(adjustmentEntryDetails, SessionMain));
            return Ok(result);
        }

        #endregion

    }
}
