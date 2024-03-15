using FluentValidation;
using PSI.Modules.Backends.Masters.Command.CountryMaster;
using PSI.Modules.Backends.Masters.Repository.CompanyMaster;
using PSI.Modules.Backends.Masters.Repository.CountryMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Services.Validator.CountryMaster
{
    public class CountryValidator :AbstractValidator<CountryCommand>
    {
        private readonly ICountryRepository _countryRepository;
        public CountryValidator(ICountryRepository countryRepository)
        {
            _countryRepository = countryRepository;
            RuleFor(x => x.CountryCode).NotEmpty()
                .Must((x, countryCode) => CheckCountry(x))
                .WithMessage("Entered country code or name already exists");
            RuleFor(x => x.CountryName).NotEmpty();
        }
        private bool CheckCountry(CountryCommand command)
        {
            if (command.CountryId == 0)
            {
                var country = _countryRepository.GetCountry(command.CountryCode,
                    command.CountryName);
                if (country == null) return true;
                return false;
            }
            return true;
        }
    }
}
