using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using PSI.Modules.Backends.DirectSales.Command;
using System.Xml.Linq;

namespace PSI.Modules.Backends.SNS.Queries
{
    public class SNSArchiveSearchQuery : IRequest<LoadResult>
    {
        public SNSArchiveSearchQuery(DataSourceLoadOptions loadOptions, SNSArchiveSearch sNSArchiveSearch)
        {
            LoadOptions = loadOptions;
            SNSArchiveSearch = sNSArchiveSearch;
        }
        public DataSourceLoadOptions LoadOptions;
        public SNSArchiveSearch SNSArchiveSearch { get; set; }
    }
}

