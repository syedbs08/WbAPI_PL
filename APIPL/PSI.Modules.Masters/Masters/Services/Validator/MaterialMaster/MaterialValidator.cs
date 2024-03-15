using FluentValidation;
using PSI.Modules.Backends.Masters.Command.MaterialMaster;
using PSI.Modules.Backends.Masters.Repository.MaterialMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Services.Validator.MaterialMaster
{
    public class MaterialValidator : AbstractValidator<MaterialCommand>
    {
        private readonly IMaterialRepository _materialRepository;
        public MaterialValidator(IMaterialRepository materialRepository)
        {
            _materialRepository = materialRepository;
            RuleFor(x => x.MaterialShortDescription).NotEmpty().
              Must((x, MaterialShortDescription) => CheckMaterial(x)).
               WithMessage("Entered material code or description already exists");
            RuleFor(x => x.MaterialCode).NotEmpty();
            RuleFor(x => x.IsActive).NotEmpty();
        }
        private bool CheckMaterial(MaterialCommand command)
        {
            var Material = _materialRepository.GetMaterial(command.MaterialId, command.MaterialCode,
           (int)command.CompanyId);
            if (Material == null) return true;
            return false;
        }
    }
}