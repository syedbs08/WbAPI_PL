using FluentValidation;
using PSI.Modules.Backends.DirectSales.Command;

namespace PSI.Modules.Backends.DirectSales.Validators
{
    public class DirectSalesUploadValidator : AbstractValidator<DirectSale>
    {
        public DirectSalesUploadValidator() 
        { 
            RuleFor(x=> x.CustomerType).NotNull().NotEmpty().WithMessage("Customer Type is required");
            RuleFor(x => x.CustomerId).NotNull().NotEmpty().WithMessage("Customer is required");
            RuleFor(x => x.ProductCategoryId).NotNull().NotEmpty().WithMessage("Product Category is required");
            RuleFor(x => x.ProductSubCategoryId).NotNull().NotEmpty().WithMessage("Product Sub-Category is required");
            RuleFor(x => x.File).NotNull().NotEmpty().WithMessage("File is required");
            RuleFor(x => x.FileTypeId).NotNull().NotEmpty().WithMessage("File Type is required");
            RuleFor(x => x.FolderPath).NotNull().NotEmpty().WithMessage("Folder Path is required");
            RuleFor(x => x.SaleSubType).NotNull().NotEmpty().WithMessage("Sale Sub-Type is required");
        }
    }
}
