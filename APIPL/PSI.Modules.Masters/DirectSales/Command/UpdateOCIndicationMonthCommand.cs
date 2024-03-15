using Core.BaseUtility.Utility;
using MediatR;

namespace PSI.Modules.Backends.DirectSales.Command
{
    public class UpdateOCIndicationMonthCommand : IRequest<Result>
    {
        public UpdateOCIndicationMonthCommand(OCIndicationMonthCommand command, SessionData session)
        {
            OCIndicationMonthCommand = command;
            Session=session;
        }
        public SessionData Session { get; set; }
        public OCIndicationMonthCommand OCIndicationMonthCommand { get; set; }
    }
}
