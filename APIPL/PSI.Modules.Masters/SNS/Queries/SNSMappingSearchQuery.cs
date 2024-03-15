using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace PSI.Modules.Backends.SNS.Queries
{
    public class SNSMappingSearchQuery : IRequest<LoadResult>
    {
        public SNSMappingSearchQuery(DataSourceLoadOptions loadOptions)
        {
            LoadOptions = loadOptions;
        }
        public DataSourceLoadOptions LoadOptions;

    }
}
