using Core.BaseUtility;
using System;
using System.Collections.Generic;

namespace PSI.Domains.Entity;

public partial class Material: BaseEntity
{
    public int MaterialId { get; set; }

    public string? MaterialCode { get; set; }

    public string? MaterialShortDescription { get; set; }
    public int? CompanyId { get; set; }

    public string? BarCode { get; set; }

    public bool? InSap { get; set; }

    public decimal? Weight { get; set; }

    public decimal? Volume { get; set; }

    public int? SeaPortId { get; set; }

    public int? AirPortId { get; set; }

    public int? ProductCategoryId1 { get; set; }

    public int? ProductCategoryId2 { get; set; }

    public int? ProductCategoryId3 { get; set; }

    public int? ProductCategoryId4 { get; set; }

    public int? ProductCategoryId5 { get; set; }

    public int? ProductCategoryId6 { get; set; }
    public int? SupplierId { get; set; }
    public bool? IsActive { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string? CreatedBy { get; set; }

    public DateTime? UpdateDate { get; set; }

    public string? UpdateBy { get; set; }


}
