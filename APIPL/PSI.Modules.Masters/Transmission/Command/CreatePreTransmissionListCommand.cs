using Core.BaseUtility.Utility;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Transmission.Command
{
    public class PreTransmissionListCommand
    {
        public int? ResultMonth { get; set; }
        public int? CurrentMonth { get; set; }
        public string[] CustomerCode { get; set; }
        public string Type { get; set; }
    }
    public class CreatePreTransmissionListCommand : IRequest<Result>
    {
        public CreatePreTransmissionListCommand(PreTransmissionListCommand preTransmissionListCommand, SessionData sessionData)
        {
            PreTransmissionListCommand = preTransmissionListCommand;
            SessionData = sessionData;
        }
        public PreTransmissionListCommand PreTransmissionListCommand { get; set; }
        public SessionData SessionData { get; set; }
    }
}