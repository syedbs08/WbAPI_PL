using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.SNS.Command
{

    public class SNSEntryDetails
    {

        public int FileTypeId { get; set; }
        public IFormFile? File { get; set; }
        public string FolderPath { get; set; } = string.Empty;
        public int OACAccountId { get; set; }
        public string SaleSubType { get; set; } = string.Empty;
    }
    public class SNSEntryUploadCommand : IRequest<Result>
    {
        public SNSEntryDetails SNSEntryDetails { get; set; }
        public SessionData SessionData { get; set; }
        public SNSEntryUploadCommand(SNSEntryDetails snsEntryDtails, SessionData sessionData)
        {
            SNSEntryDetails= snsEntryDtails;
            SessionData = sessionData;
        }
    }
}
