using Core.BaseUtility.Utility;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Command.Department
{
    public class CreateDepartmentCommand : IRequest<Result>
    {
        public CreateDepartmentCommand(DepartmentCommand command)
        {
            Department = command;
        }
        public DepartmentCommand Department { get; set; }
    }
}
