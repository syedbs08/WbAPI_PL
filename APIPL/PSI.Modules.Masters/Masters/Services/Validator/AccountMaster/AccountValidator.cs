
using FluentValidation;
using PSI.Modules.Backends.Masters.Command.AccountMaster;
using PSI.Modules.Backends.Masters.Repository.AccountMaster;

namespace PSI.Modules.Backends.Masters.Services.Validator.AccountMaster
{
    public class MenuValidator : AbstractValidator<AccountCommand>
    {
        private readonly IAccountRepository _accountRepository;
        public MenuValidator(IAccountRepository accountRepository)
        {
            _accountRepository = accountRepository;


            RuleFor(x => x.AccountCode).NotEmpty().
                Must((x, AccountCode) => CheckAccount(x)).
                WithMessage("Entered account code or name already exists");
            RuleFor(x => x.AccountName).NotEmpty();
        }
        private bool CheckAccount(AccountCommand command)
        {
            var account = _accountRepository.GetAccount(command.AccountCode,
                command.AccountName);
            if (account == null) return true;           
            return false;
        }
    }
}
