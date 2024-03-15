using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Repository.RegionMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.ProductCategoryMaster
{
    public partial interface IProductCategoryRepository : IBaseRepository<ProductCategory>
    {
    }
    public partial class ProductCategoryRepository : BaseRepository<ProductCategory>, IProductCategoryRepository
    {
        public ProductCategoryRepository() : base(new PSIDbContext()) { }
    }
}
