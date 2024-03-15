using Core.BaseUtility;

namespace PSI.Domains.Entity;

public partial class Department:BaseEntity
{
    public int DepartmentId { get; set; }
    public string? DepartmentName { get; set; }
    public string? DepartmentCode { get; set; }
    public bool? IsActive { get; set; }
    public string? DepartmentDescription { get; set; }
    public bool? IsDeleted { get; set; }
    public string? CountryId { get; set; }
    public string? CompanyId { get; set; }
    public DateTime? CreatedDate { get; set; }
    public string? CreatedBy { get; set; }
    public DateTime? UpdateDate { get; set; }
    public string? UpdateBy { get; set; }
}
