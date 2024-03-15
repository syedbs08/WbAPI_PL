using System;
namespace PSI.Domains.Entity
{
    public partial class SP_COGSearch
    {
        public int? CustomerId { get; set; }
        public int? CountryId { get; set; }
        public string? CustomerCode { get; set; }
        public string? CustomerName { get; set; }
        public string? MaterialCode { get; set; }
        public string? MonthYear { get; set; }
        public string? SaleSubType { get; set; }
        public string? SaleTypeName { get; set; }
        public decimal? FRT_Price { get; set; }
        public decimal? CST_Price { get; set; }
        public decimal? FOB_Price { get; set; }
        public decimal? COG_Price { get; set; }
    }
}

