using Core.BaseUtility;
using System;
using System.Collections.Generic;

namespace PSI.Domains.Entity;

public partial class Product : BaseEntity
{
    public int ProductId { get; set; }

    public string? ProductCode { get; set; }

    public string? ProductDescription { get; set; }

    public bool? IsActive { get; set; }

    public bool? IsDeleted { get; set; }

    public string? ProductName { get; set; }
}
