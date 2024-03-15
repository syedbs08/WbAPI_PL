using Core.BaseUtility;
using System;
using System.Collections.Generic;

namespace PSI.Domains.Entity;

public partial class MaterialCountryMapping:BaseEntity
{
    public int MaterialCountryMappingId { get; set; }

    public int? MaterialId { get; set; }

    public int? CountryId { get; set; }
    public DateTime? CreatedDate { get; set; }

    public string? CreatedBy { get; set; }

    public DateTime? UpdateDate { get; set; }

    public string? UpdateBy { get; set; }
}
