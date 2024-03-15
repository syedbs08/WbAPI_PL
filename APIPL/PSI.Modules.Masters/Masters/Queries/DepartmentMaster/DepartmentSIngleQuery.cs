using MediatR;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Queries.DepartmentMaster
{
    public class DepartmentSIngleQuery : IRequest<Department>
    {
        public DepartmentSIngleQuery(string deparmentCode, string departmentName)
        {
            DeparmentCode = deparmentCode;
            DepartmentName = departmentName;
        }
        public string DeparmentCode { get; set; }
        public string DepartmentName { get; set; }
    }
}
