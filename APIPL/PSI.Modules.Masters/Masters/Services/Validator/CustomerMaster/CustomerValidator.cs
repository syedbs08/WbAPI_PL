using FluentValidation;
using PSI.Modules.Backends.Masters.Command.CustomerMaster;
using PSI.Modules.Backends.Masters.Command.CustomerMaster;
using PSI.Modules.Backends.Masters.Repository.CustomerMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Services.Validator.CustomerMaster
{
    public class CustomerValidator : AbstractValidator<CustomerCommand>
    {
        private readonly ICustomerRepository _customerRepository;
        public CustomerValidator(ICustomerRepository customerRepository)
        {
            _customerRepository = customerRepository;
            RuleFor(x => x.CustomerCode).NotEmpty().
              Must((x, CustomerCode) => CheckCustomer(x)).
               WithMessage("Entered customer code or emailid already exists");
            RuleFor(x => x.CustomerCode).NotEmpty();
            RuleFor(x => x.CustomerName).NotEmpty();
            RuleFor(x => x.EmailId).NotEmpty();
            RuleFor(x => x.CountryId).NotEmpty();
            RuleFor(x => x.CustomerShortName).NotEmpty();
            RuleFor(x => x.SalesTypeIds).NotEmpty();
            RuleFor(x => x.IsActive).NotEmpty();
        }
        private bool CheckCustomer(CustomerCommand command)
        {
            var Customer = _customerRepository.GetCustomer(command.CustomerId, command.CustomerCode,
                 command.EmailId
           );
            if (Customer == null) return true;
            return false;
        }
    }
}
