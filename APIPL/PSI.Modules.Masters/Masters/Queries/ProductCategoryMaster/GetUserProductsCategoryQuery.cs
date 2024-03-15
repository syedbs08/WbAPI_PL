using MediatR;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Queries.ProductCategoryMaster
{
    public class GetAllUserProductsCategoryQuery : IRequest<IEnumerable<ProductCategory>> {
      public GetAllUserProductsCategoryQuery(string userId)
        {
            UserId=userId;
        }
        public string UserId { get; set; }
    }
}
