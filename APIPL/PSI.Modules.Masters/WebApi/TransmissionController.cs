
using AttachmentService.Command;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PSI.Modules.Backends.Transmission;
using PSI.Modules.Backends.Transmission.Command;
using PSI.Modules.Backends.Transmission.Queries;
using PSI.Modules.Backends.Transmission.Repository;
using SessionManagers.AuthorizeService.services;
using System.Net;

namespace PSI.Modules.Backends.WebApi
{
    [Authorize]
    [Route("api/v1/transmission")]
    public class TransmissionController : SessionServiceBase
    {
        private readonly ITransmissionService _transmissionService;
     
        private readonly IDashTransmitService _dashTransmitService;
        public TransmissionController(ITransmissionService transmissionService,
            IDashTransmitService dashTransmitService)
        {
            _transmissionService = transmissionService;
            _dashTransmitService = dashTransmitService;

        }
        [HttpGet]
        [Route("transmission-plan-type")]
        public async Task<IActionResult> GetTransmissionPlanType()
        {
            var result = await _transmissionService.GetTransmissionPlanType();
            return Ok(result);
        }
        [HttpGet]
        [Route("transmission-list")]
        public async Task<IActionResult> GetTransmissionList(DataSourceLoadOptions loadOptions)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }

            var result = await _transmissionService.GetTransmissionList(loadOptions);
            return Ok(result);

        }
        [HttpPost]
        [Route("add-delete-transmission-list")]
        public async Task<IActionResult> AddTransmissionList([FromBody] TransmissionListCommand command)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            if (SessionMain == null || string.IsNullOrWhiteSpace(SessionMain.ADUserId)
                      || !SessionMain.Roles.Any())
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            var result = await _transmissionService.AddTransmissionList(command, SessionMain);
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok();

        }
        [HttpPost]
        [Route("add-pre-transmission-list")]
        public async Task<IActionResult> AddPreTransmissionList([FromBody] PreTransmissionListCommand command)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            if (SessionMain == null || string.IsNullOrWhiteSpace(SessionMain.ADUserId)
                      || !SessionMain.Roles.Any())
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            var result = await _transmissionService.AddPreTransmissionList(command, SessionMain);
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok();
        }

        [HttpPost]
        [Route("pre-transmission-customer-list")]
        public async Task<IActionResult> GetPreTransmissionCustomerList(DataSourceLoadOptions loadOptions, PreTransmissionCustomerSearch obj)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }

            var result = await _transmissionService.GetPreTransmissionCustomerList(loadOptions, obj);

            return Ok(result);

        }
        [HttpGet]
        [Route("transmission-customer-by-plantype-sale/{planTypeCode}/{saletype}")]
        public async Task<IActionResult> getTransmissionCustomerByPlanTypeBySaleType(string planTypeCode, string saletype)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            var result = await _transmissionService.getTransmissionCustomerByPlanTypeBySaleType(planTypeCode, saletype);
            return Ok(result);
        }
        [HttpGet]
        [Route("transmit/{plantype}/{resultMonth}/{customerCode}/{currentMonth}/{type}")]
        public async Task<IActionResult> Transmit(string plantype, int resultMonth, string customerCode, int currentMonth, string type)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }

            var result = await _transmissionService.WritTramissionFile(Convert.ToInt32(plantype), resultMonth, customerCode, currentMonth, type);
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok(result);

        }
        [HttpGet]
        [Route("transmit-data-list")]
        public async Task<IActionResult> GetTransmitdataList(DataSourceLoadOptions loadOptions)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            var result = await _transmissionService.GetTransmitdataList(loadOptions);
            return Ok(result);

        }
        [HttpPost, DisableRequestSizeLimit]
        [Route("upload-dash-transmit")]
        [Consumes("multipart/form-data")]
        public IActionResult UploadDashTranmit(FileCommand command)
        {
            if (SessionMain == null || string.IsNullOrWhiteSpace(SessionMain.ADUserId))
            {              
                return BadRequest(HttpStatusCode.Unauthorized);
            }
           
            var result =  _dashTransmitService.UploadTransmit(command,SessionMain);
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok();
        }
        [HttpGet]
        [Route("dash-transmit")]
        public IActionResult GetDashTransmit(DataSourceLoadOptions loadOptions)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            var result =  _dashTransmitService.GetDashTransmit(loadOptions);
            return Ok(result);

        }

    }
}
