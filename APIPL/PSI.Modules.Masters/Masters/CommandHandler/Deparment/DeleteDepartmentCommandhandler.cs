using Core.BaseUtility.Utility;
using MediatR;
using PSI.Modules.Backends.Masters.Command.Department;
using PSI.Modules.Backends.Masters.Repository.DepartmentMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.CommandHandler.Deparment
{
    public class DeleteDepartmentCommandhandler : IRequestHandler<DeleteDepartmentCommand, Result>
    {
         readonly IDepartmentMasterRepository _departmentMasterRepository;
        public DeleteDepartmentCommandhandler(IDepartmentMasterRepository departmentMasterRepository)
        {
            _departmentMasterRepository = departmentMasterRepository;
        }
        public async Task<Result> Handle(DeleteDepartmentCommand request, CancellationToken cancellationToken)
        {
            try
            {
                //update operatio will be seperated later
                if (request.DepartmentId > 0)
                {
                    var department = await _departmentMasterRepository.GetById(request.DepartmentId);
                    if (department == null)
                    {
                        return Result.Failure($"Department not found to delete {request.DepartmentId}");
                    }
                    department.IsDeleted = true;
                    department.IsActive = false;
                    department.UpdateBy = request.UpdateBy;
                    var updateResult = _departmentMasterRepository.Update(department);
                    if (updateResult == null)
                    {
                        Log.Error($"Department delete: Error occured while  {request.DepartmentId}");
                        return Result.Failure("Seems input value is not correct,Failed to delete Department");
                    }
                    return Result.Success;
                }
                return Result.Failure($"Department not found to delete {request.DepartmentId}");
            }
            catch (Exception ex)
            {
                Log.Error($"Execption occured while delete department {request.DepartmentId}", ex.Message);
                return Result.Failure("Problem in delete ,try later");
            }
        }
    }
}
