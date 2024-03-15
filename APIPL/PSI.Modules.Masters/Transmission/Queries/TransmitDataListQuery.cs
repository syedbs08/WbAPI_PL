using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Transmission.Queries
{
    public class TransmitDataListQuery : IRequest<LoadResult>
    {
        public TransmitDataListQuery(DataSourceLoadOptions loadOptions)
        {
            LoadOptions = loadOptions;
        }
        public DataSourceLoadOptions LoadOptions;
    }
}