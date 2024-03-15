using Core.BaseUtility.Utility;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.SNS.Command
{
    public class RunPriceProcessCommand : IRequest<Result>
    {
        public string? CurrentMonth{ get; set; }
        public RunPriceProcessCommand(string currentMonth)
        {
            CurrentMonth=currentMonth;
        }
    }
}
