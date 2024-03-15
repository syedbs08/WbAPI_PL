using FluentValidation;
using PSI.Modules.Backends.Transmission.Command;
using PSI.Modules.Backends.Transmission.Repository;

namespace PSI.Modules.Backends.Transmission.Validator
{
    internal class TransmissionListValidator : AbstractValidator<TransmissionListCommand>
    {
        private readonly ITransmissionListRepository _transmissionListRepository;
        public TransmissionListValidator(ITransmissionListRepository transmissionListRepository)
        {
            _transmissionListRepository = transmissionListRepository;

            RuleFor(x => x.PlanTypeCode).NotEmpty().
                Must((x, PlanTypeCode) => CheckTransmissionList(x)).
                WithMessage("Entered plan type,customer or salestype already exists");
            RuleFor(x => x.CustomerCode).NotEmpty();
            RuleFor(x => x.SalesType).NotEmpty();
        }
        private bool CheckTransmissionList(TransmissionListCommand command)
        {
            var data = _transmissionListRepository.GetTransmissionList(command.PlanTypeCode,
                command.CustomerCode, command.SalesType);
            if (data == null) return true;
            return false;
        }

    }
}
