using Core.BaseUtility.Utility;
using Microsoft.AspNetCore.Mvc;
using PSI.Modules.Backends.BWIntegration;
using SessionManagers.AuthorizeService.services;

namespace PSI.Modules.Backends.WebApi
{
    [Route("api/v1/bwintegration")]
    public class BWIntegrationController : SessionServiceBase
    {
        private readonly IBWIntegrationService _bwService;
        public BWIntegrationController(IBWIntegrationService bwService)
        {
            _bwService = bwService;
        }
        [HttpGet]
        [Route("trigger-bw")]
        public IActionResult SendBWData()
        {
            Log.Information($"triggered BW integration job at {DateTime.Now}");
            var result = _bwService.SaveBWData();
            return Ok(result);

        }
    }
}
