using Core.BaseUtility.TableSearchUtil;
using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Queries.PSIDatesMaster
{
    public class PSIDatesSearchQuery : IRequest<LoadResult>
    {
        public PSIDatesSearchQuery(DataSourceLoadOptions loadOptions
         )
        {
            LoadOptions = loadOptions;
        }
        public DataSourceLoadOptions LoadOptions;

    }
}