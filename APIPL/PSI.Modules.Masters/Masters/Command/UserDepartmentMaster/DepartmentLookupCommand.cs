using Core.BaseUtility.Utility;
using MediatR;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Command.Department
{
    public class DepartmentLookupCommand : IRequest<IEnumerable<Result>>
    {
        public int DepartmentId { get; set; }
        public string? DepartmentCode { get; set; }
        public string? DepartmentName { get; set; }
    }
}
