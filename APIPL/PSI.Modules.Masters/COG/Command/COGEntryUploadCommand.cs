using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.COG.Command
{
    public class COGEntryDetails
    {
        public int FileTypeId { get; set; }
        public IFormFile? File { get; set; }
        public string FolderPath { get; set; } = string.Empty;
        public int SaleTypeId { get; set; }
        public string SaleSubType { get; set; } = string.Empty;
    }
    public class COGEntryUploadCommand : IRequest<Result>
    {
        public COGEntryDetails COGEntryDetails { get; set; }
        public SessionData SessionData { get; set; }
        public COGEntryUploadCommand(COGEntryDetails cogEntryDtails, SessionData sessionData)
        {
            COGEntryDetails = cogEntryDtails;
            SessionData = sessionData;
        }
    }
}
