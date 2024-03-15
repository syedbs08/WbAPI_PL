using Core.BaseUtility.Utility;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Command.LockPSIMaster
{
    public class CreateLockPSICommand:IRequest<Result>
    {
        public CreateLockPSICommand(LockPSICommand command, SessionData session)
        {
            LockPSI = command;
            Session = session;
        }
        public LockPSICommand LockPSI { get; set; }
        public SessionData Session { get; set; }
    }
}
