using Core.BaseUtility.Utility;
using MediatR;

namespace PSI.Modules.Backends.Masters.Command.CompanyMaster
{
    public class CreateCompanyCommand : IRequest<Result>
    {
        public CreateCompanyCommand(CompanyCommand command)
        {
            Company = command;
        }
        public CompanyCommand Company { get; set; }
    }
}
