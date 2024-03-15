using Core.BaseUtility.Utility;
using MediatR;

namespace PSI.Modules.Backends.Masters.Command.ProductCategoryMaster
{
    public class CreateProductCategoryCommand : IRequest<Result>
    {
        public CreateProductCategoryCommand(ProductCategoryCommand command)
        {
            ProductCategory = command;
        }
        public ProductCategoryCommand ProductCategory { get; set; }
    }
}
