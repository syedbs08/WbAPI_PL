using Core.BaseUtility.Utility;
using MediatR;

namespace PSI.Modules.Backends.Masters.Command.UserProductMap
{
    public class CreateUserProductMappingCommand : IRequest<Result>
    {
        public CreateUserProductMappingCommand(UserProductMappingCommand userProductMapping)
        {
            ProductMappingCommand = userProductMapping;
        }
        public UserProductMappingCommand ProductMappingCommand { get; set; }
    }
}
