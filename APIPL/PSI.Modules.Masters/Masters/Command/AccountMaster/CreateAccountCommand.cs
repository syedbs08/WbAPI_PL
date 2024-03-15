
using Core.BaseUtility.Utility;
using MediatR;


namespace PSI.Modules.Backends.Masters.Command.AccountMaster
{
    public class CreateAccountCommand : IRequest<Result>
    {
        public CreateAccountCommand(AccountCommand command)
        {
            Account = command;
        }
        public AccountCommand Account { get; }
    }
}
