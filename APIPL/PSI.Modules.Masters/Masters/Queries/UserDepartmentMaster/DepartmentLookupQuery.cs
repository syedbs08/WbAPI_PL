using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Command.Department;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Queries.DepartmentMaster
{
    public class DepartmentLookupQuery : IRequest<IEnumerable<DepartmentLookupCommand>>
    {
    }
}
