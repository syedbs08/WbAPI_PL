using Core.BaseUtility.Utility;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.SNS.Command
{
    public class RollingInventorySnsBPCommand : IRequest<Result>
    {
        public RollingInventorySnsBPCommand(string userId,string accountCode)
        {
            UserId = userId;
            AccountCode = accountCode;
        }
        public string UserId { get; set; }
        public string AccountCode { get; set; }
    }
}
