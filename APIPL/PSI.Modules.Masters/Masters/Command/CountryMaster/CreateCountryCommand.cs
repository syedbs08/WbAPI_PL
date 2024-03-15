using Core.BaseUtility.Utility;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Command.CountryMaster
{
    public class CreateCountryCommand : IRequest<Result>
    {
        public CreateCountryCommand(CountryCommand command)
        {
            Country = command;
        }
        public CountryCommand Country { get; set; }
    }
}
