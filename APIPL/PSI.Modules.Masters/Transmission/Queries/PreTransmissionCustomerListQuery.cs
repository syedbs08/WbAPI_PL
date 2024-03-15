using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using NPOI.SS.Formula.Functions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Transmission.Queries
{

    public class PreTransmissionCustomerSearch
    {
        public string? Type { get; set; }
    }
    public class PreTransmissionCustomerListQuery : IRequest<LoadResult>
    {
        public PreTransmissionCustomerListQuery(DataSourceLoadOptions loadOptions, PreTransmissionCustomerSearch preTransmissionCustomerSearch)
        {
            LoadOptions = loadOptions;
            PreTransmissionCustomerSearch = preTransmissionCustomerSearch;
        }
        public DataSourceLoadOptions LoadOptions;
        public PreTransmissionCustomerSearch PreTransmissionCustomerSearch { get; set; }
    }
}