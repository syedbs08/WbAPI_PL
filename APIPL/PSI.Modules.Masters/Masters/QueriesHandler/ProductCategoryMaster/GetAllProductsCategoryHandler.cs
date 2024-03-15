using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.ProductCategoryMaster;
using PSI.Modules.Backends.Masters.Repository.ProductCategoryMaster;

namespace PSI.Modules.Backends.Masters.QueriesHandler.ProductCategoryMaster
{
    public class GetAllProductsCategoryHandler : IRequestHandler<GetAllProductsCategoryQuery, IEnumerable<ProductCategory>>
    {
        private readonly IProductCategoryRepository _productCategoryRepository;
        public GetAllProductsCategoryHandler(IProductCategoryRepository productCategoryRepository)
        {
            _productCategoryRepository = productCategoryRepository;
        }
        public async Task<IEnumerable<ProductCategory>> Handle(GetAllProductsCategoryQuery request, CancellationToken cancellationToken)
        {
            return await Task.Run(() =>
            {
                var products = _productCategoryRepository.GetProductCategories();
                return products;
            });
        }
    }
}
