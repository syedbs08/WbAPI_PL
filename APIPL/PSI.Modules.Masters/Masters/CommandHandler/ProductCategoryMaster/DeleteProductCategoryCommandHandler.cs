using Core.BaseUtility.Utility;
using MediatR;
using PSI.Modules.Backends.Masters.Command.ProductCategoryMaster;
using PSI.Modules.Backends.Masters.Command.RegionMaster;
using PSI.Modules.Backends.Masters.Repository.ProductCategoryMaster;

namespace PSI.Modules.Backends.Masters.CommandHandler.ProductCategoryMaster
{
    public class DeleteProductCategoryCommandHandler : IRequestHandler<DeleteProductCategoryCommand, Result>
    {
        private readonly IProductCategoryRepository _productCategoryRepository;
        public DeleteProductCategoryCommandHandler(IProductCategoryRepository productCategoryRepository)
        {
            _productCategoryRepository = productCategoryRepository;
        }
        public async Task<Result> Handle(DeleteProductCategoryCommand request, CancellationToken cancellationToken)
        {
            try
            {
                //update operatio will be seperated later
                if (request.ProductCategoryId > 0)
                {
                    var ProductCategory = await _productCategoryRepository.GetById(request.ProductCategoryId);
                    if (ProductCategory == null)
                    {
                        return Result.Failure($"ProductCategory not found to delete {request.ProductCategoryId}");
                    }
                    ProductCategory.Isdeleted = true;
                    ProductCategory.IsActive = false;
                    ProductCategory.UpdateBy = request.UpdateBy;
                    var updateResult = _productCategoryRepository.Update(ProductCategory);
                    if (updateResult == null)
                    {
                        Log.Error($"ProductCategory delete: Error occured while  {request.ProductCategoryId}");
                        return Result.Failure("Seems input value is not correct,Failed to delete ProductCategory");
                    }
                    return Result.Success;
                }
                return Result.Failure($"ProductCategory not found to delete {request.ProductCategoryId}");
            }
            catch (Exception ex)
            {
                Log.Error($"Execption occured while delete productCategory {request.ProductCategoryId}", ex.Message);
                return Result.Failure("Problem in delete ,try later");
            }
        }
    }
}

