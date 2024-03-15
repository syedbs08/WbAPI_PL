using FluentValidation;
using PSI.Modules.Backends.Masters.Command.CompanyMaster;
using PSI.Modules.Backends.Masters.Command.Department;
using PSI.Modules.Backends.Masters.Repository.CompanyMaster;
using PSI.Modules.Backends.Masters.Repository.DepartmentMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Services.Validator.DepartmentMaster
{

    public  class DepartmentValidator : AbstractValidator<DepartmentCommand>
    {
        private readonly IDepartmentMasterRepository _departmentMasterRepository;
        public DepartmentValidator(IDepartmentMasterRepository departmentMasterRepository)
        {
            _departmentMasterRepository = departmentMasterRepository;
            RuleFor(x => x.DepartmentCode).NotEmpty().
                Must((x, DepartmentCode) => CheckDepartment(x)).
                WithMessage("Entered department code or name already exists");
            RuleFor(x => x.DepartmentName).NotEmpty();
        }
        private bool CheckDepartment(DepartmentCommand command)
        {
            var department = _departmentMasterRepository.GetDepartmentbyCodeNameId(command.DepartmentCode,
                command.DepartmentName, command.DepartmentId);
            if (department == null) return true;
            if (department.DepartmentId != command.DepartmentId) return false;
            return true;
        }
    }
}
