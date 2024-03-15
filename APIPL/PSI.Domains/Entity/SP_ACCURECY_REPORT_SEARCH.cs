using Core.BaseUtility;
using Microsoft.VisualBasic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class SP_ACCURANCY_REPORT_SEARCH:BaseEntity
    {
       
        public string? DepartmentName { get; set; }
        public string? CountryName { get; set; }
        public string? SalesOfficeName { get; set; }
        public string? Consignee { get; set; }
        public string? SALES_TYPE { get; set; }
        public string? MaterialCode { get; set; }
        public int? MonthYear { get; set; }
        public string? PERIOD { get; set; }
        public int? order_QTY { get; set; }
        public int? purchase_QTY { get; set; }
        public int? sales_QTY { get; set; }
        public int? inventory_QTY { get; set; }
        public decimal? order_AMT { get; set; }
        public decimal? purchase_AMT { get; set; }
        public decimal? sales_AMT { get; set; }
        public decimal? inventory_AMT { get; set; }
        public decimal? sales_FOBAMT { get; set; }
        public int? nextsales_QTY { get; set; }
        public decimal? nextsales_AMT { get; set; }
       
      
    }
}
