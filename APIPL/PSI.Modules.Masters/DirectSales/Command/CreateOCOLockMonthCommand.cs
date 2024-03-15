using Core.BaseUtility.Utility;
using MediatR;

namespace PSI.Modules.Backends.DirectSales.Command
{
    public class CreateOCOLockMonthCommand : IRequest<Result>
    {
        public CreateOCOLockMonthCommand(List<OCOLockMonthCommand> oCOLockMonth, SessionData session)
        {
            OCOLockMonths = oCOLockMonth;
            Session = session;
        }
        public SessionData Session { get; set; }
        public List<OCOLockMonthCommand> OCOLockMonths { get; set; }
    }
}
