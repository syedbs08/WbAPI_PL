using Core.BaseUtility.Utility;
using MediatR;
using PSI.Modules.Backends.Masters.Command.AccountMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Command.Report
{
    public class CreateReportCommand : IRequest<Result>
    {
        public CreateReportCommand(ReportCommand command)
        {
            report = command;
        }
        public ReportCommand report { get; }
    }
}
