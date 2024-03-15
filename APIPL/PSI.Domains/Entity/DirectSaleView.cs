using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class DirectSaleView
    {
        public int? SalesEntryId { get; set; }
        //public int? SalesEntryPriceQuantityId { get; set; }
        public string? MonthYear { get; set; }
        public int? ModeOfTypeId { get; set; }
        public int? Quantity { get; set; }
        public decimal? Price { get; set; }
        public string? CurrentMonthYear { get; set; }
        public int? CustomerId { get; set; }
        public int? CompanyId { get; set; }
        public int? CountryId { get; set; }
        public string? CustomerCode { get; set; }
        public string? CustomerName { get; set; }
        public string? MaterialCode { get; set; }
        public int? ProductCategoryId1 { get; set; }
        public int? ProductCategoryId2 { get; set; }
        public string? Mg { get; set; }
        public string? Mg1 { get; set; }
        
    }
}
