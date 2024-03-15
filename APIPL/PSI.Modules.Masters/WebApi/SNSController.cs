using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PSI.Modules.Backends.Constants;
using PSI.Modules.Backends.SNS;
using PSI.Modules.Backends.SNS.Command;
using PSI.Modules.Backends.SNS.Queries;
using PSI.Modules.Backends.SNS.Results;
using SessionManagers.AuthorizeService.services;
using System.Net;
using static PSI.Modules.Backends.SNS.Command.SNSPlanningCommentCommand;


namespace PSI.Modules.Backends.WebApi
{
    [Authorize]
    [Route("api/v1/sns")]
    public class SNSController : SessionServiceBase
    {
        
        readonly private ISNSService _snservice;
        

        public SNSController( ISNSService snsservice)
        {
            
            _snservice = snsservice;
           
        }


        #region archive data
        [HttpPost]
        [Route("archive/{month}/{type}")]
        public async Task<IActionResult> Archived(int? month, string? type)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            SNSArchiveData command = new SNSArchiveData();
            command.Month = Convert.ToString(month);
            command.Type = type;
            var result = await _snservice.Archive(new SNSArchiveCommand(command, SessionMain));
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok(result);
        }
        [Authorize]
        [HttpPost]
        [Route("archive-data")]
        public async Task<IActionResult> Archivedata(DataSourceLoadOptions loadOptions, SNSArchiveSearch obj)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }

            var result = await _snservice.ArchiveData(loadOptions, obj);
            return Ok(result);

        }
        #endregion
        #region SNS Entry Upload

        [HttpPost, DisableRequestSizeLimit]
        [Route("upload-sns-entry")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UploadFiles(SNSEntryDetails snsentrydetails)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _snservice.UploadFiles(new SNSEntryUploadCommand(snsentrydetails, SessionMain));
            return Ok(result);
        }

        #endregion
        #region SN-Price
        [HttpPost, DisableRequestSizeLimit]
        [Route("upload-sns-price")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> SNS_PriceUploadFiles(SNS_Price sSN_Price)
        {

            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = await _snservice.SNSUploadFiles(new SNS_PriceCommand(sSN_Price, SessionMain));
            return Ok(result);
        }
        [HttpPost]
        [Route("run-price-process/{month}")]
        public async Task<IActionResult> SNS_RunPriceProcess(int? month)
        {
            var result = await _snservice.RunPriceProcess(new RunPriceProcessCommand(Convert.ToString(month)));
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok(result);
        }


        [HttpPost]
        [Route("download-sns-entry")]
        public async Task<IActionResult> DownloadFile(SNSEntryDownload snsentrydownload)
        {

            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = await _snservice.GetOrDownloadSNSEntry(new SNSEntryDownloadCommand(snsentrydownload, SessionMain));

            if (result.IsSuccess)
            {
                var fileResponse = ((Core.BaseUtility.Utility.Result<SNSEntryDownloadFileResult>)result).Value;
                return File(fileResponse.FileContent, Contants.EXCEL_MEDIA_TYPE, fileResponse.FileName + fileResponse.FileExtension);
            }
            else
            {
                return BadRequest(result);
            }
        }

        [HttpPost]
        [Route("get-sns-summary")]
        public async Task<IActionResult> GetSNSSummary(SNSEntryDownload snsentrydownload)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = await _snservice.GetOrDownloadSNSEntry(new SNSEntryDownloadCommand(snsentrydownload, SessionMain));


            return Ok(result);
        }

        #endregion

        #region sns planning comment
        [HttpPost]
        [Route("sns-planning-comment")]
        public async Task<IActionResult> CreateSNSComment([FromBody] SNSComment command)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _snservice.CreateSNSComment(new SNSPlanningCommentCommand(command, SessionMain));
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok();
        }


        [HttpPost]
        [Route("get-planning-comment")]
        public async Task<IActionResult> getPlanningComment([FromBody] SNSComment snsComment)
        {
            var result = await _snservice.GetPlanningComment(snsComment.MaterialCode, snsComment.OACAccountCode);
            return Ok(result);
        }
        #endregion

        #region SNS-Planning
        [HttpPost]
        [Route("get-sns-planning")]
        public async Task<IActionResult> GetSNSPlanning([FromBody] SNSPlanning snsPlanning)
        {

            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = await _snservice.GetSNSPlanning(new SNSPlanningCommand(snsPlanning, SessionMain));
            return Ok(result);
        }

        [HttpPost]
        [Route("update-sns-planning")]
        public async Task<IActionResult> UpdateSNSPlanning([FromBody] UpdateSNSPlanning updateSNSPlanning)
        {

            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = await _snservice.UpdateSNSPlanning(new UpdateSNSPlanningCommand(updateSNSPlanning, SessionMain));
            return Ok(result);
        }


        [HttpPost]
        [Route("get-planned-customer")]
        public async Task<IActionResult> GetPlannedCustomer([FromBody] PlannedCusotmerCommand command)
        {
            var result = _snservice.GetPlannedCustomer(command.AccountCode, command.MaterialCode);
            return Ok(result);
        }
        #endregion


        #region monthclosing

        [HttpGet]
        [Route("trigger-month-closing/{type}")]
        public async Task<IActionResult> TriggerClosing(string type)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }

            var result = await _snservice.TriggerMonthClosing(type, SessionMain.ADUserId);
          
            return Ok(result);

        }
        [HttpGet]
        [Route("rollingInventory-sns-bp/{accountCode}")]
        public async Task<IActionResult> TriggerRollingInventorySnsBP(string accountCode)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            RollingInventorySnsBPCommand command = new RollingInventorySnsBPCommand(SessionMain.ADUserId, accountCode);
            var result = await _snservice.TriggerRollingInventorySnsBP(command);
            return Ok(result);

        }
        [HttpGet]
        [Route("trigger-result-purchase")]
        public IActionResult ResultPurchase()
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }

            var result =  _snservice.SaveResultPurchase(SessionMain.ADUserId);
            return Ok(result);

        }

        [HttpPost]
        [Route("update-consignee/{accountCode?}")]
        public async Task<IActionResult> UpdateConsignee(string accountCode)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }

            var result =await  _snservice.UpdateConsinee(new UpdateConsineeCommand(accountCode,SessionMain));
            return Ok(result);

        }

        [Obsolete]
        [HttpGet]
        [Route("test-sap")]
        public async Task<IActionResult> testSapConnection()
        {
            //var resultMonth = new ResultMonthSales();

            //resultMonth.TestSapConnectivity();

            return Ok();

        }

        [HttpPost]
        [Route("add-snsMapping")]
        public async Task<IActionResult> AddAccount([FromBody] SNSMapping command)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);

            }
            var result = await _snservice.AddSNSMapping(new SNSMappingCommand(command, SessionMain));
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok();
        }
        [HttpGet]
        [Route("sns-mapping")]
        public async Task<IActionResult> GetSNSMapping(DataSourceLoadOptions loadOptions)
        {
            var result = await _snservice.GetSNSMapping(loadOptions);
            return Ok(result);
        }
       
        #endregion

        [HttpGet]
        [Route("rollingInventory/{accountCode}")]
        public async Task<IActionResult> RollingInventory(string accountCode)
        {
            var result = _snservice.RollingInventory(accountCode);
            return Ok(result);
        }

        [HttpGet]
        [Route("map-model/{accountCode}")]
        public async Task<IActionResult> MapSNSModel(string accountCode)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            var result = await _snservice.MapSNSModel(accountCode, SessionMain.ADUserId);
            return Ok(result);
        }
    }
}
