using FluentValidation;
using PSI.Modules.Backends.Masters.Command.ProductCategoryMaster;
using PSI.Modules.Backends.Masters.Repository.ProductCategoryMaster;


namespace PSI.Modules.Backends.Masters.Services.Validator.ProductCategoryMaster
{
    internal class ProductCategoryValidator : AbstractValidator<ProductCategoryCommand>
    {
        private readonly IProductCategoryRepository _productCategoryRepository;
        public ProductCategoryValidator(IProductCategoryRepository productCategoryRepository)
        {
            _productCategoryRepository = productCategoryRepository;
            RuleFor(x => x.ProductCategoryName).NotEmpty().
              Must((x, ProductCategoryName) => CheckProductCategory(x)).
               WithMessage("Entered product Category name or code already exists");
           RuleFor(x => x.ProductCategoryCode).NotEmpty();
           RuleFor(x => x.IsActive).NotEmpty();
        }
        private bool CheckProductCategory(ProductCategoryCommand command)
        {
            var ProductCategory = _productCategoryRepository.GetProductCategory(command.ParentCategoryId,
            command.ProductCategoryName, command.CategoryLevel, command.ProductCategoryId,command.ProductCategoryCode);
            if (ProductCategory == null) return true;
            return false;
        }
    }
}
 