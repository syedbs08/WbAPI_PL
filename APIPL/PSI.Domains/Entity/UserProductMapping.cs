using Core.BaseUtility;
using System;
using System.Collections.Generic;

namespace PSI.Domains.Entity;

public partial class UserProductMapping : BaseEntity
{
    public int Id { get; set; }

    public string? UserId { get; set; }

    public int? ProductId { get; set; }
    public DateTime? CreatedDate { get; set; }
    public string? CreatedBy { get; set; }
    public DateTime? UpdateDate { get; set; }
    public string? UpdateBy { get; set; }
}
