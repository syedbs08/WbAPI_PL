using Core.BaseUtility.Utility;
using DevExtreme.AspNet.Data;
using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Graph;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.DirectSales.Queries;
using PSI.Modules.Backends.DirectSales.Results;
using PSI.Modules.Backends.SNS.Command;
using PSI.Modules.Backends.SNS.Queries;
using PSI.Modules.Backends.SNS.Results;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.SNS.CommandHandler
{
    public class SNSArchiveHandler : IRequestHandler<SNSArchiveSearchQuery, LoadResult>
    {
        private readonly PSIDbContext _context;
        public SNSArchiveHandler()
        {
            _context = new PSIDbContext();
        }

        public async Task<LoadResult> Handle(SNSArchiveSearchQuery request, CancellationToken cancellationToken)
        {
            request.SNSArchiveSearch.DirectSaleIds = request.SNSArchiveSearch.DirectSaleIds == "null" ? null : request.SNSArchiveSearch.DirectSaleIds;
            request.SNSArchiveSearch.SNSIds = request.SNSArchiveSearch.SNSIds == "null" ? null : request.SNSArchiveSearch.SNSIds;
            var archives = _context.Sp_Get_Direct_SNS_Archive.FromSql($"Sp_Get_Direct_SNS_Archive {request.SNSArchiveSearch.Month},{request.SNSArchiveSearch.DirectSaleIds},{request.SNSArchiveSearch.SNSIds}").AsNoTracking().ToList();
            var loadOptions = request?.LoadOptions;
            var result = DataSourceLoader.Load(archives, loadOptions);
            return result;
        }
    }
}
