using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.ProductCategoryMaster;
using PSI.Modules.Backends.Masters.Repository.ProductCategoryMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.QueriesHandler.ProductCategoryMaster
{
    public class ProductCategorySingleHandler : IRequestHandler<ProductCategorySingleQuery, ProductCategory>
    {
        private readonly IProductCategoryRepository _productCategoryRepository;
        public ProductCategorySingleHandler(IProductCategoryRepository productCategoryRepository)
        {
            _productCategoryRepository = productCategoryRepository;
        }

        public async Task<ProductCategory> Handle(ProductCategorySingleQuery request, CancellationToken cancellationToken)
        {
            return await Task.Run(() =>
            {
                var result = _productCategoryRepository.GetProductCategory(request.ParentCategoryId, request.ProductCategoryName, request.CategoryLevel, request.ProductCategoryId,request.ProductCategoryCode);

                return result;
            });

        }
    }
}
