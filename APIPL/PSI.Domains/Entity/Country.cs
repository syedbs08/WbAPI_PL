using Core.BaseUtility;
using System;
using System.Collections.Generic;

namespace PSI.Domains.Entity;
public partial class Country: BaseEntity
{
    public int CountryId { get; set; }
    public string? CountryName { get; set; }
    public string? CountryCode { get; set; }
    public string? CountryshortName { get; set; }
    public int? CurrencyId { get; set; }
    public bool? IsActive { get; set; }
    public bool? IsDeleted { get; set; }
    public DateTime? CreatedDate { get; set; }
    public string? CreatedBy { get; set; }
    public DateTime? UpdateDate { get; set; }
    public string? UpdateBy { get; set; }
}
