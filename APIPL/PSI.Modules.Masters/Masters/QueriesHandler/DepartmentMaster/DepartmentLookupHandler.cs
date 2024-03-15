using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Command.Department;
using PSI.Modules.Backends.Masters.Queries.DepartmentMaster;
using PSI.Modules.Backends.Masters.Repository.CountryMaster;
using PSI.Modules.Backends.Masters.Repository.DepartmentMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.QueriesHandler.DepartmentMaster
{
    public class DepartmentLookupHandler : IRequestHandler<DepartmentLookupQuery, IEnumerable<DepartmentLookupCommand>>
    {
        private readonly IDepartmentMasterRepository _deparmentRepository;
        public DepartmentLookupHandler(IDepartmentMasterRepository  departmentMasterRepository)
        {
            _deparmentRepository = departmentMasterRepository;

        }

        public async Task<IEnumerable<DepartmentLookupCommand>> Handle(DepartmentLookupQuery request, CancellationToken cancellationToken)
        {
            var result = _deparmentRepository.DepartmentLookup().OrderBy(x=>x.DepartmentName).ToList();            
            return await Task.FromResult(result);
        }
    }
}
