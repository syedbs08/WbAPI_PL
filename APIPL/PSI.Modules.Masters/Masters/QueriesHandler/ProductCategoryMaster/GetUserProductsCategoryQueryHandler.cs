using MediatR;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.ProductCategoryMaster;
using PSI.Modules.Backends.Masters.Repository.ProductCategoryMaster;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Security.Cryptography.Xml;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;

namespace PSI.Modules.Backends.Masters.QueriesHandler.ProductCategoryMaster
{
    internal class GetUserProductsCategoryQueryHandler : IRequestHandler<GetAllUserProductsCategoryQuery, IEnumerable<ProductCategory>>
    {
        private readonly IProductCategoryRepository _productCategoryRepository;
        private readonly PSIDbContext _context;
        public GetUserProductsCategoryQueryHandler(IProductCategoryRepository productCategoryRepository)
        {
            _productCategoryRepository = productCategoryRepository;
            _context = new PSIDbContext();
        }
        public async Task<IEnumerable<ProductCategory>> Handle(GetAllUserProductsCategoryQuery request, CancellationToken cancellationToken)
        {
            return await Task.Run(() =>
            {
                var userId = new SqlParameter("@userId", SqlDbType.NVarChar, 100);
                userId.Value = request.UserId ?? string.Empty;
                var param = new SqlParameter[] {
                    userId,
                    };

                var data = _context.ProductCategories.FromSqlRaw("dbo.SP_USER_PRODUCTCATEGORY @userId", param).AsNoTracking().ToList(); ;
                return data;
            });
        }
    }
}
