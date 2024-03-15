using DevExtreme.AspNet.Data;
using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using Microsoft.EntityFrameworkCore;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.DirectSales.Results;
using PSI.Modules.Backends.Masters.Queries.PSILockMaster;
using PSI.Modules.Backends.Masters.Repository.LockPSIMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.QueriesHandler.PSILockMaster
{
    public class PSILockSearcQueryGridHandler : IRequestHandler<PSILockSearchGridQuery, LoadResult>
    {
        
        private readonly PSIDbContext _context;
        public PSILockSearcQueryGridHandler()
        {
        
            _context = new PSIDbContext();
        }
        public async Task<LoadResult> Handle(PSILockSearchGridQuery request, CancellationToken cancellationToken)
        {
            try
            {
                var searchCommand = request.PSILockSearcQuery;

                var data = _context.SP_GETLOCKPSI.FromSql($"SP_GETLOCKPSI {searchCommand.CustomerCodes},{searchCommand.SubcategoryCodes}, {searchCommand.UserIds}").AsNoTracking().ToList();

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
