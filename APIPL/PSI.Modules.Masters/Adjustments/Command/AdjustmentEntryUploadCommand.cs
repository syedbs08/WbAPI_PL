using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.AspNetCore.Http;
using PSI.Modules.Backends.SNS.Command;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Adjustments.Command
{
    public class AdjustmentEntryDetails
    {

        public int FileTypeId { get; set; }
        public IFormFile? File { get; set; }
        public string FolderPath { get; set; } = string.Empty;

    }
    public class AdjustmentEntryUploadCommand : IRequest<Result>
    {
        public AdjustmentEntryDetails AdjustmentEntryDetails { get; set; }
        public SessionData SessionData { get; set; }
        public AdjustmentEntryUploadCommand(AdjustmentEntryDetails adjustmentEntryDetails, SessionData sessionData)
        {

            AdjustmentEntryDetails = adjustmentEntryDetails;
            SessionData = sessionData;
        }
    }
}

