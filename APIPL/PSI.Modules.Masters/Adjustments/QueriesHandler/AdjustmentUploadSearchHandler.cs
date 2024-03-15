using AttachmentService.Repository;
using DevExtreme.AspNet.Data.ResponseModel;
using DevExtreme.AspNet.Data;
using MediatR;
using PSI.Domains;
using PSI.Modules.Backends.Constants;
using PSI.Modules.Backends.DirectSales.Queries;
using PSI.Modules.Backends.DirectSales.Results;
using PSI.Modules.Backends.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static PSI.Modules.Backends.Constants.Contants;
using PSI.Modules.Backends.Adjustments.Queries;
using Microsoft.EntityFrameworkCore;

namespace PSI.Modules.Backends.Adjustments.QueriesHandler
{
    internal class AdjustmentUploadSearchHandler : IRequestHandler<AdjustmentUploadSearchQuery, LoadResult>
    {
        private readonly PSIDbContext _context;
      
        public AdjustmentUploadSearchHandler()
        {
            _context = new PSIDbContext();
          
        }
        public async Task<LoadResult> Handle(AdjustmentUploadSearchQuery request, CancellationToken cancellationToken)
        {
            try
            {
                var searchCommand = request.AdjustmentUploadSearch;
                searchCommand.ProductCategoryId1 = searchCommand.ProductCategoryId1 == "null" ? null : searchCommand.ProductCategoryId1;
                searchCommand.ProductCategoryId2 = searchCommand.ProductCategoryId2 == "null" ? null : searchCommand.ProductCategoryId2;
                var data = _context.SP_AdjustmentSearch.FromSql($"SP_ADJUSTMENTSEARCH  {searchCommand.CountryId}, {searchCommand.CustomerId}, {searchCommand.ProductCategoryId1},{searchCommand.ProductCategoryId2},{searchCommand.FromMonth},{searchCommand.ToMonth}").AsNoTracking().ToList();
                var loadOptions = request?.LoadOptions;
                var result = DataSourceLoader.Load(data, loadOptions);
                return result;
            }
            catch(Exception ex)
            {
                return null;
            }
        }
      
    }

}
