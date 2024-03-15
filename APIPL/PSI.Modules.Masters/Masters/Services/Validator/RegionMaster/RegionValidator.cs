using FluentValidation;
using PSI.Modules.Backends.Masters.Command.RegionMaster;
using PSI.Modules.Backends.Masters.Repository.RegionMaster;


namespace PSI.Modules.Backends.Masters.Services.Validator.RegionMaster
{
    internal class RegionValidator : AbstractValidator<RegionCommand>
    {
        private readonly IRegionRepository _regionRepository;
        public RegionValidator(IRegionRepository regionRepository)
        {
            _regionRepository = regionRepository;
            RuleFor(x => x.RegionCode).NotEmpty().
                Must((x, RegionCode) => CheckRegion(x)).
                WithMessage("Entered region code or name already exists");
            RuleFor(x => x.RegionName).NotEmpty();
            RuleFor(x => x.RegionShortDescription).NotEmpty();
        }
        private bool CheckRegion(RegionCommand command)
        {
                var Region = _regionRepository.GetRegion(command.RegionCode,
                command.RegionName, command.RegionShortDescription, command.RegionId);
                if (Region == null) return true;
                return false;
        }
    }
}
