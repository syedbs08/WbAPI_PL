using System;
using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using Newtonsoft.Json;
using PSI.Modules.Backends.DirectSales.Command;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace PSI.Modules.Backends.COG.Queries
{
    public class COGUploadSearch
    {
        public string? CountryId { get; set; }
        public string? CustomerId { get; set; }
        public string? ProductCategoryId1 { get; set; }
        public string? ProductCategoryId2 { get; set; }
        public int? SalesTypeId { get; set; }
        public string? SalesSubType { get; set; }
        public int? FromMonth { get; set; }
        public int? ToMonth { get; set; }

    }
    public class COGUploadSearchQuery : IRequest<LoadResult>
    {
        public COGUploadSearchQuery(DataSourceLoadOptions loadOptions, COGUploadSearch cogUploadSearch)
        {
            LoadOptions = loadOptions;
            COGUploadSearch = cogUploadSearch;
        }
        public DataSourceLoadOptions LoadOptions;
        public COGUploadSearch COGUploadSearch { get; set; }
    }
}