using AttachmentService.Command;
using Core.BaseUtility.Utility;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Command.PSIDatesMaster
{
    public class ImportPSIDatesCommand : IRequest<Result>
    {
        public ImportPSIDatesCommand(FileCommand command,
               SessionData session)
        {
            Command = command;
            Session = session;
        }

        public SessionData Session { get; set; }
        public FileCommand Command { get; set; }
    }
}
