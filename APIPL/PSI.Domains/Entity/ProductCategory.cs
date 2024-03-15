

using Core.BaseUtility;

namespace PSI.Domains.Entity;

public partial class ProductCategory:BaseEntity
{
    public int ProductCategoryId { get; set; }

    public string? ProductCategoryCode { get; set; }
    public string? OldSubCode { get; set; }
    public string? ProductCategoryName { get; set; }
    public string? ProductCategoryShortName { get; set; }
    public string? ParentCategoryId { get; set; }

    public int? CategoryLevel { get; set; }

    public bool? IsActive { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string? CreatedBy { get; set; }

    public DateTime? UpdateDate { get; set; }

    public string? UpdateBy { get; set; }

    public bool? Isdeleted { get; set; }
}
