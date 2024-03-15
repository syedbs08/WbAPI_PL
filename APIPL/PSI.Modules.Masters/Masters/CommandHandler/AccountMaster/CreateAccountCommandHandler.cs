
using Core.BaseUtility.MapperProfiles;
using Core.BaseUtility.Utility;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Command.AccountMaster;
using PSI.Modules.Backends.Masters.Repository;
using PSI.Modules.Backends.Masters.Repository.AccountMaster;

namespace PSI.Modules.Backends.Masters.CommandHandler.AccountMaster
{
    public class CreateAccountCommandHandler : IRequestHandler<CreateAccountCommand, Result>
    {
        private readonly IAccountRepository _accountRepository;

        public CreateAccountCommandHandler(IAccountRepository accountRepository)
        {
            _accountRepository = accountRepository;

        }
        public async Task<Result> Handle(CreateAccountCommand request, CancellationToken cancellationToken)
        {
            try
            {
                //update operatio will be seperated later
                if (request.Account.AccountId > 0)
                {
                    var account = await _accountRepository.GetById(request.Account.AccountId);
                    if (account == null)
                    {
                        return Result.Failure($"Account not found to update {request.Account.AccountId}");
                    }
                    account.AccountName = request.Account.AccountName;
                    account.AccountCode = request.Account.AccountCode;
                    account.IsActive = request.Account.IsActive;

                    var updateResult = _accountRepository.Update(account);
                    if (updateResult == null)
                    {
                        Log.Error($"Account update: Error occured while updating {request.Account}");
                        return Result.Failure("Seems input value is not correct,Failed to update account");
                    }
                    return Result.Success;
                }

                var accountObject = MappingProfile<AccountCommand, Account>.Map(request.Account);
                if (accountObject == null)
                {
                    Log.Error($"Account Add: operation failed due to invalid mapping{request.Account}");
                    return Result.Failure("Seems input value is not correct,Failed to add account");
                }
                var result = await _accountRepository.Add(accountObject);
                if (result == null)
                {
                    Log.Error($"Account Add:Db operation failed{result}");
                    return Result.Failure("Error in adding account,contact to support team");
                }
                return Result.Success;

            }
            catch (Exception ex)
            {

                Log.Error($"Execption occured while adding account {request.Account}", ex.Message);
                return Result.Failure("Problem in adding account ,try later");

            }
        }
    }

}
