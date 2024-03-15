using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using PSI.Modules.Backends.SNS.Queries;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Transmission.Queries
{
    public class TransmissionListQuery : IRequest<LoadResult>
    {
        public TransmissionListQuery(DataSourceLoadOptions loadOptions)
        {
            LoadOptions = loadOptions;
        }
        public DataSourceLoadOptions LoadOptions;
    }
}