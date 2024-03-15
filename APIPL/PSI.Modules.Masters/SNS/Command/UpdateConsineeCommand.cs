using Core.BaseUtility.Utility;
using MediatR;

namespace PSI.Modules.Backends.SNS.Command
{
    public class UpdateConsineeCommand : IRequest<Result>
    {

        public UpdateConsineeCommand(string accountCode, SessionData sessionData)
        {
            AccountCode = accountCode;
            SessionData = sessionData;
        }
        public string AccountCode { get; set; }
        public SessionData SessionData { get; set; }
    }
}

