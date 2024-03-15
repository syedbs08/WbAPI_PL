using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using PSI.Modules.Backends.DirectSales.Command;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Adjustments.Queries
{
    public class AdjustmentUploadSearch
    {
        public string? CountryId { get; set; }
        public string? CustomerId { get; set; }
        public string? ProductCategoryId1 { get; set; }
        public string? ProductCategoryId2 { get; set; }
        public int? FromMonth { get; set; }
        public int? ToMonth { get; set; }

    }
    public class AdjustmentUploadSearchQuery : IRequest<LoadResult>
    {
        public AdjustmentUploadSearchQuery(DataSourceLoadOptions loadOptions, AdjustmentUploadSearch adjustmentUploadSearch)
        {
            LoadOptions = loadOptions;
            AdjustmentUploadSearch = adjustmentUploadSearch;
        }
        public DataSourceLoadOptions LoadOptions;
        public AdjustmentUploadSearch AdjustmentUploadSearch { get; set; }
    }
}