using System;
using System.Threading;
using System.Threading.Tasks;
using AttachmentService.Repository;
using DevExtreme.AspNet.Data;
using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using Microsoft.EntityFrameworkCore;
using PSI.Domains;
using PSI.Modules.Backends.COG.Queries;
using PSI.Modules.Backends.Constants;

namespace PSI.Modules.Backends.COG.QueriesHandler
{
    internal class COGUploadSearchHandler : IRequestHandler<COGUploadSearchQuery, LoadResult>
    {
        private readonly PSIDbContext _context;
        private readonly Contants _myConstants = new Contants();
        public COGUploadSearchHandler()
        {
            _context = new PSIDbContext();
        }
        public async Task<LoadResult> Handle(COGUploadSearchQuery request, CancellationToken cancellationToken)
        {
            var searchCommand = request.COGUploadSearch;
            searchCommand.ProductCategoryId1 = searchCommand.ProductCategoryId1 == "null" ? null : searchCommand.ProductCategoryId1;
            searchCommand.ProductCategoryId2 = searchCommand.ProductCategoryId2 == "null" ? null : searchCommand.ProductCategoryId2;
            searchCommand.SalesSubType = searchCommand.SalesSubType == "null" ? null : searchCommand.SalesSubType;
            var data = _context.SP_COGSearch.FromSql
                ($"SP_COGSearch  {searchCommand.CountryId}, {searchCommand.CustomerId}, {searchCommand.ProductCategoryId1},{searchCommand.ProductCategoryId2}, {searchCommand.SalesTypeId},{searchCommand.SalesSubType},{searchCommand.FromMonth},{searchCommand.ToMonth}")
                .AsNoTracking().ToList();
            var loadOptions = request?.LoadOptions;
            var result = DataSourceLoader.Load(data, loadOptions);
            return result;
        }
    }
}

