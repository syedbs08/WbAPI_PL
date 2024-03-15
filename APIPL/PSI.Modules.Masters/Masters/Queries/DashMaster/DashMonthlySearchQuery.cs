using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;


namespace PSI.Modules.Backends.Masters.Queries.DashMaster
{
    public class DashMonthlySearchQuery : IRequest<LoadResult>
    {
        public DashMonthlySearchQuery(DataSourceLoadOptions loadOptions)
        {
            LoadOptions = loadOptions;

        }

        public DataSourceLoadOptions LoadOptions;
    }
    public class DashMonthlySearch
    { 
        public string ? MaterialCode { get; set; }
        public string? CustomerName { get; set; }
        public string? SupplierCode { get; set; }
        public string? SalesCompany { get; set; }
        public bool? IsActive { get; set; }

        public string? ShipmentMode { get; set; }
        public string? MonthYear { get; set; }
        public string? CreatedBy { get; set; }
        public string? ModifiedBy { get; set; }
        public DateTime? CreateDate { get; set; }
        public DateTime? ModifiedDate { get; set; }
    }

}
