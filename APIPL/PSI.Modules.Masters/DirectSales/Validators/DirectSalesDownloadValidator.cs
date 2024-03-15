using FluentValidation;
using PSI.Modules.Backends.DirectSales.Command;

namespace PSI.Modules.Backends.DirectSales.Validators
{
    public class DirectSalesDownloadValidator : AbstractValidator<DirectSalesDownload>
    {
        public DirectSalesDownloadValidator() 
        { 
            RuleFor(x => x.CustomerId).NotNull().NotEmpty().WithMessage("Customer is required");
            RuleFor(x => x.ProductCategoryId).NotNull().NotEmpty().WithMessage("Product Category is required");
            RuleFor(x => x.ProductSubCategoryId).NotNull().NotEmpty().WithMessage("Product Sub-Category is required");
            RuleFor(x => x.SaleSubType).NotNull().NotEmpty().WithMessage("Sale Sub-Type is required");
        }
    }
}
