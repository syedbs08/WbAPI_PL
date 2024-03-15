using Core.BaseUtility.Utility;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PSI.Modules.Backends.Constants;
using PSI.Modules.Backends.COG;
using PSI.Modules.Backends.COG.Command;
using SessionManagers.AuthorizeService.services;
using System.Net;
using PSI.Modules.Backends.COG.Queries;

namespace PSI.Modules.Backends.WebApi
{
    [Authorize]
    [Route("api/v1/cog")]
    public class COGController : SessionServiceBase
    {
        readonly private ICOGService _cogservice;

        public COGController(ICOGService cogservice)
        {
            _cogservice = cogservice;
        }

        [HttpPost]
        [Route("cog-upload-data")]
        public async Task<IActionResult> GetCOGUpload(DataSourceLoadOptions loadOptions, COGUploadSearch obj)
        {
            if (SessionMain == null || string.IsNullOrWhiteSpace(SessionMain.ADUserId)
                    || !SessionMain.Roles.Any())
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            bool isSupeAdmin = SessionMain.Roles.Contains(Contants.ADMIN_ROLE);
            var result = await _cogservice.GetCOGUpload(loadOptions, obj, SessionMain.ADUserId, isSupeAdmin);

            return Ok(result);
        }

        #region COG Entry Upload

        [HttpPost, DisableRequestSizeLimit]
        [Route("upload-cog-entry")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UploadFiles(COGEntryDetails cogentrydetails)
        {
            if (SessionMain == null || string.IsNullOrWhiteSpace(SessionMain.ADUserId))
            {
                Log.Error("upload-cog-entry error");
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _cogservice.UploadFiles(new COGEntryUploadCommand(cogentrydetails, SessionMain));
            return Ok(result);
        }


        #endregion


    }
}
