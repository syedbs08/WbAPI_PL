using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.DepartmentMaster;
using PSI.Modules.Backends.Masters.Repository.DepartmentMaster;

namespace PSI.Modules.Backends.Masters.QueriesHandler.DepartmentMaster
{
    public class DepartmentSIngleHandle : IRequestHandler<DepartmentSIngleQuery, Department>
    {
        private readonly IDepartmentMasterRepository _deparmentRepository;

        public DepartmentSIngleHandle(IDepartmentMasterRepository deparmentRepository)
        {
            _deparmentRepository = deparmentRepository;
        }
        public async Task<Department> Handle(DepartmentSIngleQuery request, CancellationToken cancellationToken)
        {   
            return await Task.Run(() =>
            {
                var result = _deparmentRepository.GetDepartment(request.DeparmentCode, request.DepartmentName);

                return result;
            });
        }
    }
}
