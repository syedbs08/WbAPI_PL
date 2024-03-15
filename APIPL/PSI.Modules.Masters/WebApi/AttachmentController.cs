
using AttachmentService;
using AttachmentService.Command;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.StaticFiles;
using SessionManagers.AuthorizeService.services;


namespace PSI.Modules.Backends.WebApi
{

    [Route("api/v1/attachment")]
    public class AttachmentController : SessionServiceBase
    {
        private readonly IAttachmentService _attachmentService;
       
        public AttachmentController(IAttachmentService attachmentService
            )
        {
            _attachmentService = attachmentService;
          
        }
        [HttpGet]

        [Route("status")]
        public IActionResult GetStatus()
        {
            return Ok("attachment api called sucessfully");
        }
        [Authorize]
        [HttpPost, DisableRequestSizeLimit]
        [Route("uploads")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UploadFiles(FileCommand command)
        {
            var result = await _attachmentService.UploadFiles(command,SessionMain);
            return Ok(result);
        
        }
        [HttpPost, DisableRequestSizeLimit]
        [Route("uploads-multiple")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UploadFilesMultiple(FileCommand command)
        {
            var result = await _attachmentService.UploadFile(command, SessionMain);
            return Ok(result);

          
        
        }

        [HttpGet]
        [Route("downloads-file/{fileName}/{filePath}")]
        public IActionResult Download(string fileName,string filePath)
        {
            if (string.IsNullOrWhiteSpace(fileName) || string.IsNullOrEmpty(filePath))
            {
                return BadRequest("file path and file name is required");
            }
            var files = _attachmentService.DownloadFile(fileName, filePath).Result;
            if (files == null)
            {
                return BadRequest("file not found");
            
            }
            return File(files.Content, files.ContentType, files.Name);

        }


        [HttpPost]
        [Route("document-folders")]
        public IActionResult DocumentHistory([FromBody] DocumentFilterCommand command)
        {
            if (string.IsNullOrWhiteSpace(command.CreatedBy))
            {
                command.CreatedBy = SessionMain.ADUserId;
            }
            var result = _attachmentService.GetAllAttachments(command);
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok(result.Value);
        }

        [HttpGet]
        [Route("document-months")]
        public IActionResult GetMonths()
        {
            var result = _attachmentService.GetMonths();          
            return Ok(result);
        }
        [Authorize]
        [HttpDelete]
        [Route("delete-files/{folderPath}/{fileName}")]
        public async Task<IActionResult> DeleteFiles(string folderPath,string fileName)
        {
            var result =await _attachmentService.DeleteFileFromBlob(folderPath, fileName);
            return Ok(result);
        }

       

    }
}
