// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using Core.BaseUtility;


namespace PSI.Domains.Entity
{
    public partial class SP_Get_Customer_Country_Currency:BaseEntity
    {
        public int CustomerId { get; set; }
        public string? CustomerCode { get; set; }
        public int CountryId { get; set; }
        public string? CountryCode { get; set; }
        public int? CurrencyId { get; set; }
        public string? CurrencyCode { get; set; }
        public decimal? ExchangeRate { get; set; }   
    }
}
