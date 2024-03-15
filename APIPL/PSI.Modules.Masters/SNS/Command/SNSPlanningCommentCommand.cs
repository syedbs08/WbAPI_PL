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
    public class SNSPlanningCommentCommand : IRequest<Result>
    {
        public class SNSComment
        {
            public string MaterialCode { get; set; } = string.Empty;
            public string OACAccountCode { get; set; }
            public string Comment { get; set; } = string.Empty;
        }
        public SNSPlanningCommentCommand(SNSComment snsComment, SessionData sessionData)
        {
            SNSComments = snsComment;
            SessionData = sessionData;
        }
        public SNSComment SNSComments { get; set; }
        public SessionData SessionData { get; set; }

    }
}
