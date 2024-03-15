using Core.BaseUtility.MapperProfiles;
using Core.BaseUtility.Utility;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Command.ProductCategoryMaster;
using PSI.Modules.Backends.Masters.Repository.ProductCategoryMaster;
using static PSI.Modules.Backends.Constants.Contants;

namespace PSI.Modules.Backends.Masters.CommandHandler.ProductCategoryMaster
{
    public class CreateProductCategoryCommandHandler : IRequestHandler<CreateProductCategoryCommand, Result>
    {
        private readonly IProductCategoryRepository _productCategoryRepository;
        public CreateProductCategoryCommandHandler(IProductCategoryRepository productCategoryRepository)
        {
            _productCategoryRepository = productCategoryRepository;
        }
        public async Task<Result> Handle(CreateProductCategoryCommand request, CancellationToken cancellationToken)
        {
            try
            {
                //update operatio will be seperated later
                if (request.ProductCategory.ProductCategoryId > 0)
                {
                    var ProductCategory = await _productCategoryRepository.GetById(request.ProductCategory.ProductCategoryId);
                    if (ProductCategory == null)
                    {
                        return Result.Failure($"ProductCategory not found to update {request.ProductCategory.ProductCategoryId}");
                    }
                    ProductCategory.ProductCategoryName = request.ProductCategory.ProductCategoryName;
                    ProductCategory.ParentCategoryId = request.ProductCategory.ParentCategoryId==null?null: request.ProductCategory.ParentCategoryId;
                    ProductCategory.CategoryLevel = request.ProductCategory.CategoryLevel;
                    ProductCategory.IsActive = request.ProductCategory.IsActive;
                    ProductCategory.UpdateBy = request.ProductCategory.UpdateBy;
                    ProductCategory.UpdateDate = DateTime.Now;
                    var updateResult = _productCategoryRepository.Update(ProductCategory);
                    if (updateResult == null)
                    {
                        Log.Error($"ProductCategory update: Error occured while updating {request.ProductCategory}");
                        return Result.Failure("Seems input value is not correct,Failed to update ProductCategory");
                    }
                    return Result.Success;
                }

                var ProductCategoryObject = MappingProfile<ProductCategoryCommand, ProductCategory>.Map(request.ProductCategory);
                if (ProductCategoryObject == null)
                {
                    Log.Error($"ProductCategory Add: operation failed due to invalid mapping{request.ProductCategory}");
                    return Result.Failure("Seems input value is not correct,Failed to add ProductCategory");
                }
                ProductCategoryObject.CreatedBy = request.ProductCategory.CreatedBy;
          
                ProductCategoryObject.CreatedDate = DateTime.Now;
                ProductCategoryObject.ParentCategoryId = request.ProductCategory.ParentCategoryId == null? null : request.ProductCategory.ParentCategoryId;
                var result = await _productCategoryRepository.Add(ProductCategoryObject);
                if (result == null)
                {
                    Log.Error($"ProductCategory Add:Db operation failed{result}");
                    return Result.Failure("Error in adding ProductCategory,contact to support team");
                }
                return Result.Success;

            }
            catch (Exception ex)
            {

                Log.Error($"Execption occured while adding ProductCategory {request.ProductCategory}", ex.Message);
                return Result.Failure("Problem in adding ProductCategory ,try later");

            }
        }

    }
}
