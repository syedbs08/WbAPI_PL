using MediatR;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Queries.ProductCategoryMaster
{
    public class ProductCategorySingleQuery : IRequest<ProductCategory>
    {
        public ProductCategorySingleQuery(int productCategoryId,
             string productCategoryName, string? parentCategoryId, int? categoryLevel,string productCategoryCode)
        {
            ProductCategoryId = productCategoryId;
            ProductCategoryName = productCategoryName;
            ProductCategoryCode = productCategoryCode;
            ParentCategoryId = parentCategoryId;
            CategoryLevel = categoryLevel;
        }
        public int ProductCategoryId { get; set; }

        public string? ProductCategoryName { get; set; }
        public string? ProductCategoryCode { get; set; }

        public string? ParentCategoryId { get; set; }

        public string? ProductCategoryGroup { get; set; }

        public int? CategoryLevel { get; set; }
}
}
