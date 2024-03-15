using Core.BaseUtility.Utility;
using MediatR;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Command.UserDepartmentMaster
{
    public class CreateUserDepartmentMappingCommand : IRequest<Result>
    {
        public CreateUserDepartmentMappingCommand(UserDepartmentMappingCommand userDepartmentMapping)
        {
            UserDepartmentMapping = userDepartmentMapping;
        }
        public UserDepartmentMappingCommand UserDepartmentMapping { get; set; }
    }
}
