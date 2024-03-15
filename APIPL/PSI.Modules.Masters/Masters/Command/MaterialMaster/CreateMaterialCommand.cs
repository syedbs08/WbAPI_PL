using Core.BaseUtility.Utility;
using MediatR;
using PSI.Modules.Backends.Masters.Command.RegionMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Command.MaterialMaster
{
    public class CreateMaterialCommand : IRequest<Result>
    {
        public CreateMaterialCommand(MaterialCommand command)
        {
            Material=command;
        }
        public MaterialCommand Material { get; set; }
    }
}
