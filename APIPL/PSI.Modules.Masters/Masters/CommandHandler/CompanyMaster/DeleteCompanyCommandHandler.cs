using Core.BaseUtility.Utility;
using MediatR;
using PSI.Modules.Backends.Masters.Command.CompanyMaster;
using PSI.Modules.Backends.Masters.Repository.CompanyMaster;
using PSI.Modules.Backends.Masters.Repository.DepartmentMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.CommandHandler.CompanyMaster
{
    public class DeleteCompanyCommandHandler : IRequestHandler<DeleteCompanyCommand, Result>
    {
        private readonly ICompanyRepository _companyRepository;
        private readonly IDepartmentMasterRepository _departmentMasterRepository;
        public DeleteCompanyCommandHandler(ICompanyRepository companyRepository, IDepartmentMasterRepository departmentMasterRepository)
        {
            _companyRepository = companyRepository;
            _departmentMasterRepository = departmentMasterRepository;
        }
        public async Task<Result> Handle(DeleteCompanyCommand request, CancellationToken cancellationToken)
        {
            try
            {
                if (request.CompanyId > 0)
                {
                    var company = await _companyRepository.GetById(request.CompanyId);
                    if (company == null)
                    {
                        return Result.Failure($"Company not found to delete {request.CompanyId}");
                    }
                   bool CheckCompanyExistInDepartment = _departmentMasterRepository.CheckCompanyExistInDepartment(Convert.ToString(request.CompanyId));
                    if (CheckCompanyExistInDepartment == false)
                    {
                        company.IsDeleted = true;
                        company.IsActive = false;
                        company.UpdateBy = request.UpdateBy;
                        var updateResult = _companyRepository.Update(company);
                        if (updateResult == null)
                        {
                            Log.Error($"Company delete: Error occured while  {request.CompanyId}");
                            return Result.Failure("Seems input value is not correct,Failed to delete Company");
                        }
                        return Result.Success;
                    }
                    else
                    {
                        return Result.Failure("Company can't be deleted because it's linked to department");
                    }
                }
                return Result.Failure($"Company not found to delete {request.CompanyId}");
            }
            catch (Exception ex)
            {
                Log.Error($"Execption occured while delete company {request.CompanyId}", ex.Message);
                return Result.Failure("Problem in delete ,try later");
            }
        }
    }
}
