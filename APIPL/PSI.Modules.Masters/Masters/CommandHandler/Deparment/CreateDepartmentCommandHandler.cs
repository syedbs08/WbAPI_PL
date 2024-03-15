using Core.BaseUtility.MapperProfiles;
using Core.BaseUtility.Utility;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Command.Department;
using PSI.Modules.Backends.Masters.Repository.DepartmentMaster;

namespace PSI.Modules.Backends.Masters.CommandHandler.Deparment
{
    public class CreateDepartmentCommandHandler : IRequestHandler<CreateDepartmentCommand, Result>
    {
        private readonly IDepartmentMasterRepository _departmentMasterRepository;
        public CreateDepartmentCommandHandler(IDepartmentMasterRepository departmentMasterRepository)
        {
            _departmentMasterRepository = departmentMasterRepository;
        }
        public async Task<Result> Handle(CreateDepartmentCommand request, CancellationToken cancellationToken)
        {
            try
            {
                //update operatio will be seperated later
                if (request.Department.DepartmentId > 0)
                {
                    var department = await _departmentMasterRepository.GetById(request.Department.DepartmentId);
                    if (department == null)
                    {
                        return Result.Failure($"Deparment not found to update {request.Department.DepartmentId}");
                    }
                    
                    department.DepartmentCode = request.Department.DepartmentCode;
                    department.DepartmentName = request.Department.DepartmentName;
                    department.CountryId= request.Department.CountryId;
                    department.CompanyId = request.Department.CompanyId;
                    department.IsActive = request.Department.IsActive;
                    department.DepartmentDescription = request.Department.DepartmentDescription;                    
                    department.UpdateDate = DateTime.Now;
                    var updateResult = _departmentMasterRepository.Update(department);
                    if (updateResult == null)
                    {
                        Log.Error($"Department update: Error occured while updating {request.Department}");
                        return Result.Failure("Seems input value is not correct,Failed to update Department");
                    }
                    return Result.Success;
                }

                
                var departmentObject = MappingProfile<DepartmentCommand, Department>.Map(request.Department);
                if (departmentObject == null)
                {
                    Log.Error($"Department Add: operation failed due to invalid mapping{request.Department}");
                    return Result.Failure("Seems input value is not correct,Failed to add Department");
                }                
                departmentObject.CreatedDate = DateTime.Now;
                var result = await _departmentMasterRepository.Add(departmentObject);
                if (result == null)
                {
                    Log.Error($"Department Add:Db operation failed{result}");
                    return Result.Failure("Error in adding department,contact to support team");
                }
                return Result.Success;
            }
            catch (Exception ex)
            {
                Log.Error($"Execption occured while adding deparment {request.Department}", ex.Message);
                return Result.Failure("Problem in adding deparment ,try later");
            }
        }
    }
}
