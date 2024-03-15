using Core.BaseUtility;
using System;
using System.Collections.Generic;

namespace PSI.Domains.Entity;

public partial class Region : BaseEntity
{
    public int RegionId { get; set; }
    public string? RegionName { get; set; }
    public string? RegionCode { get; set; }
    public string? RegionShortDescription { get; set; }
    public bool? IsActive { get; set; }
    public bool? IsDeleted { get; set; }
    public DateTime? CreatedDate { get; set; }
    public string? CreatedBy { get; set; }
    public DateTime? UpdateDate { get; set; }
    public string? UpdateBy { get; set; }
}
