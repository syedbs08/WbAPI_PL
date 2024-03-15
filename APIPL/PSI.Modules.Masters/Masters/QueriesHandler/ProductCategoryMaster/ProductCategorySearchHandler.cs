using Core.BaseUtility.TableSearchUtil;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.ProductCategoryMaster;
using PSI.Modules.Backends.Masters.Queries.RegionMaster;
using PSI.Modules.Backends.Masters.Repository.ProductCategoryMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.QueriesHandler.ProductCategoryMaster
{
    public class ProductCategorySearchHandler
    {
        private readonly IProductCategoryRepository _productCategoryRepository;
        public ProductCategorySearchHandler(IProductCategoryRepository productCategoryRepository)
        {
            _productCategoryRepository = productCategoryRepository;

        }
    }
}
