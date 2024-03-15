using FluentValidation;
using PSI.Modules.Backends.Masters.Command.CompanyMaster;
using PSI.Modules.Backends.Masters.Repository.CompanyMaster;
using System.Reflection.Metadata.Ecma335;

namespace PSI.Modules.Backends.Masters.Services.Validator.CompanyMaster
{
    internal class CompanyValidator : AbstractValidator<CompanyCommand>
    {
        private readonly ICompanyRepository _companyRepository;
        public CompanyValidator(ICompanyRepository companyRepository)
        {
            _companyRepository = companyRepository;
            RuleFor(x => x.CompanyCode).NotEmpty().
                Must((x, CompanyCode) => CheckCompany(x)).
                WithMessage("Entered company code or name already exists");
            RuleFor(x => x.CompanyName).NotEmpty();
        }
        private bool CheckCompany(CompanyCommand command)
        {          
            var Company = _companyRepository.GetCompany(command.CompanyCode,
                command.CompanyName,command.CompanyId);
            if (Company == null) return true;
            if (Company.CompanyId != command.CompanyId) return false;            
            return true;
        }
    }
}
