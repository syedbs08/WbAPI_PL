using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using PSI.Modules.Backends.DirectSales.Command;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Queries.PSILockMaster
{
    public class PSILockSearchGridQuery : IRequest<LoadResult>
    {
        public PSILockSearchGridQuery(DataSourceLoadOptions loadOptions, PSILockSearchItems pSILockSearcQuery)
        {
            LoadOptions = loadOptions;
            PSILockSearcQuery = pSILockSearcQuery;
        }
        public DataSourceLoadOptions LoadOptions;
        public PSILockSearchItems PSILockSearcQuery { get; set; }
    }
    
}
