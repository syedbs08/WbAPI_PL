using Core.BaseUtility.Utility;
using MediatR;
using PSI.Modules.Backends.SNS.Command;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Transmission.Command
{

    public class CreateTransmissionListCommand : IRequest<Result>
    {
        public CreateTransmissionListCommand(TransmissionListCommand transmissionListCommand, SessionData sessionData)
        {
            TransmissionListCommand = transmissionListCommand;
            SessionData= sessionData;
        }
        public TransmissionListCommand TransmissionListCommand { get; set; }
        public SessionData SessionData { get; set; }
    }
}
