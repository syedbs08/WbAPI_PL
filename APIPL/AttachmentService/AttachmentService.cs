using AttachmentService.Command;
using AttachmentService.Repository;
using AttachmentService.Result;
using AutoMapper;
using Azure.Storage.Blobs;
using Core.BaseUtility.Exceptions;
using Core.BaseUtility.MapperProfiles;
using Core.BaseUtility.Utility;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.StaticFiles;
using Microsoft.Extensions.Configuration;
using Microsoft.WindowsAzure.Storage.Blob;
using PSI.Domains.Entity;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;
using System.Net;
using System.Text;
using result= Core.BaseUtility.Utility;
namespace AttachmentService
{
    public class AttachmentService : IAttachmentService
    {

        private IAttachmentsRepository _attachmentRepository;
        private readonly IVW_AttachmentRepository _vwAttachmentRepository;
        private readonly IConfiguration _configuration;
        private readonly IGlobalConfigRepository _globalConfig;

        public AttachmentService(
            IAttachmentsRepository attachmentRepository,
           IConfiguration configuration,
           IGlobalConfigRepository globalConfig,
            IVW_AttachmentRepository vwAttachmentRepository
             )
        {

            _attachmentRepository = attachmentRepository;
            _configuration = configuration;
            _globalConfig = globalConfig;
            _vwAttachmentRepository = vwAttachmentRepository;
        }
        public async Task<FileUploadResult> UploadFile(FileCommand command, SessionData session)
        {
            try
            {
                if (command.File == null || command.File.Length == 0)
                {
                    throw new HttpStatusCodeException(StatusCodes.Status400BadRequest, "File has not been selected");
                }

                return await UploadFiles(command, session);

            }
            catch (Exception ex)
            {
                Log.Error($"Error in uploading file with {ex}");
            }
            return null;


        }
        public async Task<IList<FileUploadResult>> UploadFile(FileCommand command, SessionData session, bool addBytes = false)
        {
            try
            {
                var fileResults = new List<FileUploadResult>();
                if (!command.Files.Any() || string.IsNullOrEmpty(command.FolderPath))
                {
                    throw new HttpStatusCodeException(StatusCodes.Status400BadRequest, "File has not been selected");
                }

                foreach (var item in command.Files)
                {
                    var fileCommand = new FileCommand { File = item, FileTypeId = command.FileTypeId, FolderPath = command.FolderPath };
                    fileResults.Add(UploadFiles(fileCommand, session, addBytes)?.Result);

                }
                return await Task.FromResult(fileResults);

            }
            catch (Exception ex)
            {
                Log.Error($"Error in uploading file with {ex}");
            }
            return null;

        }
   
        public async Task<FileUploadResult> UploadFiles(FileCommand command, SessionData session, bool addBytes = false)
        {

            if (session == null || string.IsNullOrWhiteSpace(session.ADUserId))
            {
                throw new HttpStatusCodeException(StatusCodes.Status401Unauthorized, "Unauthorized User");
            }        
            var currentMonth = _globalConfig.GetGlobalConfigByKey("Current_Month");
            if (currentMonth == null)
            {
                throw new HttpStatusCodeException(StatusCodes.Status400BadRequest, "Not a valid current month found in config table");
            }
            string fileName;
            byte[] fileInBytes;
            var file = command.File;
            fileName = Guid.NewGuid() + "_" + currentMonth?.ConfigValue + Path.GetExtension(file.FileName);
            fileInBytes = GetBytes(file);
            if (fileInBytes == null || fileInBytes.Length == 0)
            {
                Log.Error("No File Found to upload");
                return null;
            }
            if (string.IsNullOrEmpty(command.FolderPath))
            {
                throw new HttpStatusCodeException(StatusCodes.Status400BadRequest, "Folder Path must be entered");
            }
            if (!string.IsNullOrEmpty(command.FolderPath) && !Array.Exists(AttachmentConstant.FolderNames, x => x == command.FolderPath))
            {

                throw new HttpStatusCodeException(StatusCodes.Status400BadRequest, "Valid folder path must be entered");
            }
            try
            {
                BlobServiceClient blobServiceClient = new BlobServiceClient(_configuration["AppConfig:BlobEndpoint"]);

                var blobContainerClient = blobServiceClient.GetBlobContainerClient($"{_configuration["AppConfig:AzureBlobContainer"]}");

                blobContainerClient.CreateIfNotExists();
                using (MemoryStream stream = new MemoryStream(fileInBytes))
                {
                    var result = await blobContainerClient.UploadBlobAsync($"{command.FolderPath}/{fileName}", stream);
                }
                var downloadPath = blobContainerClient.Uri;
                var attachment = new Attachment
                {
                    Base64String = "",
                    CreatedBy = session.ADUserId,
                    CreatedDate = DateTime.Now,
                    FileTypeName = "",
                    DocumentName = file.FileName,
                    Extension = Path.GetExtension(fileName),
                    DocumentPath = PrepareAzurePath(downloadPath.ToString()),
                    VirtualFileName = fileName,
                    FileTypeId = command.FileTypeId,
                    FolderName = command.FolderPath,
                    DocumentMonth = currentMonth?.ConfigValue,
                    IsActive=false

                };
                var uploadedFile = _attachmentRepository.Add(attachment).Result;
                var returnResult = MappingProfile<Attachment, FileUploadResult>.Map(uploadedFile);
                if (addBytes)
                {
                    returnResult.FileBytes = fileInBytes;
                }
                return returnResult;

            }
            catch (Exception ex)
            {
                Log.Error("can't use storage account! " + ex.Message);
                throw new HttpStatusCodeException(StatusCodes.Status400BadRequest, "Can't upload file storage account");

                // return null;
            }

        }

        public async Task ActivateFile(int fileId)
        {
            var file = await _attachmentRepository.GetById(fileId);
            if (file == null)
            {
                Log.Error($"File Not found to delete with id {fileId}");
            }

            file.IsActive = true;
            await _attachmentRepository.Update(file);

            /// will implement to delete from blob later


        }

        public async Task DeleteFiles(int fileId)
        { 
            var file=await _attachmentRepository.GetById(fileId);
            if (file == null)
            {
                Log.Error($"File Not found to delete with id {fileId}");
            }

            file.IsActive = false;
            await _attachmentRepository.Update(file);

        /// will implement to delete from blob later
        
        
        }
        public async Task<bool> DeleteFileFromBlob(string folderPath, string fileName)
        {
            BlobServiceClient blobServiceClient = new BlobServiceClient(_configuration["AppConfig:BlobEndpoint"]);
            var blobContainerClient = blobServiceClient.GetBlobContainerClient($"{_configuration["AppConfig:AzureBlobContainer"]}");
           var result=  await blobContainerClient.GetBlobClient($"{ folderPath}/{ fileName}").DeleteIfExistsAsync();
            return result;
        }
        public async Task<BlobFileResult> DownloadFile(string fileName, string filePath)
        {
            BlobServiceClient blobServiceClient = new BlobServiceClient(_configuration["AppConfig:BlobEndpoint"]);

            var blobContainerClient = blobServiceClient.GetBlobContainerClient($"{_configuration["AppConfig:AzureBlobContainer"]}");

            var blob = blobContainerClient.GetBlobClient($"{filePath}/{fileName}");

            if (await blob.ExistsAsync())
            {
                var blobFile = await blob.DownloadAsync();

                //  await blobFile.Value.Content.CopyToAsync(memoryStream);                 
                var blobContent = new BlobFileResult()
                {
                    Content = blobFile.Value.Content,
                    ContentType = blobFile.Value.ContentType,
                    Name = fileName
                };
                return blobContent;

            }
            return null;

        }

        /// <summary>
        /// Get File Stream
        /// </summary>
        /// <param name="filePath"></param>
        /// <returns>FileStream</returns>
        public async Task<MemoryStream> GetFileStream(string fileName, string filePath)
        {
            BlobServiceClient blobServiceClient = new BlobServiceClient(_configuration["AppConfig:BlobEndpoint"]);

            var blobContainerClient = blobServiceClient.GetBlobContainerClient($"{_configuration["AppConfig:AzureBlobContainer"]}");

            var blobClient = blobContainerClient.GetBlobClient($"{filePath}/{fileName}");

            if (await blobClient.ExistsAsync())
            {
                MemoryStream memoryStream = new MemoryStream();
                var blobStream = blobClient.DownloadStreamingAsync();
                await blobClient.DownloadToAsync(memoryStream);
                return memoryStream;
            }
            return null;
        }

        public MemoryStream GetStream(IFormFile formFile)
        {
            using (var memoryStream = new MemoryStream())
            {
                formFile.CopyToAsync(memoryStream);
                return memoryStream;
            }
        }
        private string PrepareAzurePath(string docPath)
        {
            if (!string.IsNullOrWhiteSpace(docPath))
            {
                return docPath + "?sv=" + _configuration["AppConfig:BlobEndpoint"];
            }
            return string.Empty;
        }
        public byte[] GetBytes(IFormFile formFile)
        {
            using (var memoryStream = new MemoryStream())
            {
                formFile.CopyToAsync(memoryStream);
                return memoryStream.ToArray();
            }
        }
        public string GetContentType(string path)
        {
            var provider = new FileExtensionContentTypeProvider();
            string contentType;
            if (!provider.TryGetContentType(path, out contentType))
            {
                contentType = "application/octet-stream";
            }
            return contentType;
        }
        public List<string> GetMonths()
        {
            return _vwAttachmentRepository.AttachmentMonths();
        }
        public Result<List<VW_ATTACHMENT>> GetAllAttachments(DocumentFilterCommand command)
        {
            if (string.IsNullOrWhiteSpace(command.CreatedBy))
            {
                 return result.Result.Failure<List<VW_ATTACHMENT>>("","User must be selected");
            }
            if (string.IsNullOrWhiteSpace(command.DocumentMonth))
            {
                return result.Result.Failure<List<VW_ATTACHMENT>>("", "please select month");
            }
            var docList = _vwAttachmentRepository.GetAttachmentList(command.CreatedBy, command.DocumentMonth);
            return result.Result.SuccessWith(docList.ToList());        
        }

        public async Task<string> UploadFiles(string fileName, string data, string folderPath)
        {
            string message = "Success";
            try
            {
                BlobServiceClient blobServiceClient = new BlobServiceClient(_configuration["AppConfig:BlobEndpoint"]);
                var blobContainerClient = blobServiceClient.GetBlobContainerClient($"{_configuration["AppConfig:AzureBlobContainer"]}");
                byte[] bytes = Encoding.UTF8.GetBytes(data);
                using (MemoryStream stream = new MemoryStream(bytes))
                {
                    var result = await blobContainerClient.UploadBlobAsync($"{folderPath}/{fileName}", stream);
                }
            }
            catch (WebException e)
            {
                message = ((FtpWebResponse)e.Response).StatusDescription;
            }
            return message;

        }

    }
}
