using Core.BaseUtility.MapperProfiles;
using Core.BaseUtility.Utility;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Command.CompanyMaster;
using PSI.Modules.Backends.Masters.Repository.CompanyMaster;


namespace PSI.Modules.Backends.Masters.CommandHandler.CompanyMaster
{
    public class CreateCompanyCommandHandler : IRequestHandler<CreateCompanyCommand, Result>
    {
        private readonly ICompanyRepository _companyRepository;
        public CreateCompanyCommandHandler(ICompanyRepository companyRepository)
        {
            _companyRepository =companyRepository;
        }
        public async Task<Result> Handle(CreateCompanyCommand request, CancellationToken cancellationToken)
        {
            try
            {
                //update operatio will be seperated later
                if (request.Company.CompanyId > 0)
                {
                    var Company = await _companyRepository.GetById(request.Company.CompanyId);
                    if (Company == null)
                    {
                        return Result.Failure($"Company not found to update {request.Company.CompanyId}");
                    }
                    Company.CompanyName = request.Company.CompanyName;
                    Company.CompanyCode = request.Company.CompanyCode;
                    Company.IsActive = request.Company.IsActive;

                    var updateResult = _companyRepository.Update(Company);
                    if (updateResult == null)
                    {
                        Log.Error($"Company update: Error occured while updating {request.Company}");
                        return Result.Failure("Seems input value is not correct,Failed to update Company");
                    }
                    return Result.Success;
                }

                var CompanyObject = MappingProfile<CompanyCommand, Company>.Map(request.Company);
                if (CompanyObject == null)
                {
                    Log.Error($"Company Add: operation failed due to invalid mapping{request.Company}");
                    return Result.Failure("Seems input value is not correct,Failed to add Company");
                }
                var result = await _companyRepository.Add(CompanyObject);
                if (result == null)
                {
                    Log.Error($"Company Add:Db operation failed{result}");
                    return Result.Failure("Error in adding Company,contact to support team");
                }
                return Result.Success;

            }
            catch (Exception ex)
            {

                Log.Error($"Execption occured while adding Company {request.Company}", ex.Message);
                return Result.Failure("Problem in adding Company ,try later");

            }
        }
    }
}
