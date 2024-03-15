using Core.BaseUtility.TableSearchUtil;
using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Results;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Queries.TurnoverDaysMaster
{
    public class TurnoverDaysSearchQuery : IRequest<LoadResult>
    {
        public TurnoverDaysSearchQuery(DataSourceLoadOptions loadOptions
         )
        {
            LoadOptions = loadOptions;

        }

        public DataSourceLoadOptions LoadOptions;

    }
}