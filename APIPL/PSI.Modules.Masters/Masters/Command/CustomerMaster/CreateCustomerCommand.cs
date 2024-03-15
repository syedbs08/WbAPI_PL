using Core.BaseUtility.Utility;
using MediatR;
using PSI.Modules.Backends.Masters.Command.CustomerMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Command.CustomerMaster
{
    public class CreateCustomerCommand : IRequest<Result>
    {
        public CreateCustomerCommand(CustomerCommand command)
        {
            Customer = command;
        }
        public CustomerCommand Customer { get; set; }
    }
}