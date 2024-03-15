using AttachmentService.Command;
using AttachmentService.Result;
using Core.BaseUtility.Utility;
using PSI.Domains.Entity;

namespace AttachmentService
{
    public interface IAttachmentService
    {
        Task<FileUploadResult> UploadFiles(FileCommand command, SessionData session,
            bool addBytes = false);

        Task<IList<FileUploadResult>> UploadFile(FileCommand command, SessionData session, bool addBytes = false);

        Result<List<VW_ATTACHMENT>> GetAllAttachments(DocumentFilterCommand command);
        List<string> GetMonths();
        Task<BlobFileResult> DownloadFile(string fileName, string filePath);
        string GetContentType(string path);
        Task<MemoryStream> GetFileStream(string fileName, string filePath);
        Task DeleteFiles(int fileId);
        Task ActivateFile(int fileId);
        Task<bool> DeleteFileFromBlob(string folderPath, string fileName);
        Task<string> UploadFiles(string fileName, string data, string folderPath);
    }
}
