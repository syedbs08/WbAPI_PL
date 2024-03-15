using Core.BaseUtility;
using System;
using System.Collections.Generic;

namespace PSI.Domains.Entity;

public partial class SalesOffice:BaseEntity
{
    public int SalesOfficeId { get; set; }

    public string? SalesOfficeName { get; set; }

    public string? SalesOfficeCode { get; set; }

    public string? CompanyCode { get; set; }

    public int? RegionId { get; set; }

    public bool? IsActive { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string? CreatedBy { get; set; }

    public DateTime? UpdateDate { get; set; }

    public string? UpdateBy { get; set; }
}
