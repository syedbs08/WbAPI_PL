using MediatR;
using PSI.Domains.Entity;


namespace PSI.Modules.Backends.Masters.Queries.ProductCategoryMaster
{
    public class GetAllProductsCategoryQuery: IRequest<IEnumerable<ProductCategory>> { }
   
}
