
using FluentValidation;
using PSI.Modules.Backends.AccessManagement;
using PSI.Modules.Backends.Masters.Command.AccountMaster;
using PSI.Modules.Backends.Masters.Repository.AccountMaster;
using System;

namespace PSI.Modules.Backends.AccessManagement
{
    public class MenuValidator : AbstractValidator<MenuCommand>
    {
       
        public MenuValidator()
        {         
            
            RuleFor(x => x.Title).NotEmpty().NotEmpty().WithMessage("Title should not be blanked"); ;
            RuleFor(x => x.Roles).Must(x=>x.Length>0);
            RuleFor(x => x.Path).NotEmpty();
            
        }
        
    }
}
