using Core.BaseUtility.Utility;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.SNS.Command
{
    public class SNSArchiveCommand : IRequest<Result>
    {
        public SNSArchiveData SNSArchiveData { get; set; }
        public SessionData SessionData { get; set; }
        public SNSArchiveCommand(SNSArchiveData sNSArchiveData, SessionData sessionData)
        {
            SNSArchiveData = sNSArchiveData;
            SessionData = sessionData;
        }

    }
    public class SNSArchiveData
    {
        public string? Month { get; set; }
        public string? Type { get; set; }
    }
}
