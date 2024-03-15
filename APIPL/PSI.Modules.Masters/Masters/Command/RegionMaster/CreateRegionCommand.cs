using Core.BaseUtility.Utility;
using MediatR;

namespace PSI.Modules.Backends.Masters.Command.RegionMaster
{
    public class CreateRegionCommand : IRequest<Result>
    {
        public CreateRegionCommand(RegionCommand command)
        {
            Region = command;
        }
        public RegionCommand Region { get; set; }
    }
}
