using MediatR;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Queries.UserDepartmentMaster
{
    public class UserDepartmentSingleQuery : IRequest<UserDepartmentMapping>
    {
        public UserDepartmentSingleQuery(int departmentId, string userId)
        {
            DepartmentId = DepartmentId;
            UserId = userId;
        }

        public int? DepartmentId { get; set; }
        public string? UserId { get; set; }
    }
}
