using Core.BaseUtility;
using System;
using System.Collections.Generic;

namespace PSI.Domains.Entity;

public partial class Customer:BaseEntity
{
    public int CustomerId { get; set; }

    public string? CustomerCode { get; set; }

    public string? CustomerName { get; set; }

    public string? CustomerShortName { get; set; }

    public string? EmailId { get; set; }

    public int? SalesOfficeId { get; set; }

    public int? RegionId { get; set; }

    public int? CountryId { get; set; }

    public int? DepartmentId { get; set; }

    public string? PersonInChargeId { get; set; }

    public bool? IsCollabo { get; set; }

    public bool? IsActive { get; set; }
    public bool? IsPsi { get; set; }
    public bool? IsBp { get; set; }
    public DateTime? CreatedDate { get; set; }

    public string? CreatedBy { get; set; }

    public DateTime? UpdateDate { get; set; }

    public string? UpdateBy { get; set; }
    public string? CurrencyCode { get; set; }
}
