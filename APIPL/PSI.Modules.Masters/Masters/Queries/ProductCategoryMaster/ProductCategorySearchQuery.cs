using Core.BaseUtility.TableSearchUtil;
using MediatR;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Queries.ProductCategoryMaster
{
    public class ProductCategorySearchQuery : IRequest<PagingResponse<ProductCategory>>
    {
        public ProductCategorySearchQuery(PagingRequest pagingRequest
         )
        {
            PagingRequest = pagingRequest;
        }
        public PagingRequest PagingRequest { get; set; }
    }
}
