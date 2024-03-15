using Core.BaseUtility;


namespace PSI.Domains.Entity;

public partial class Company:BaseEntity
{
    public int CompanyId { get; set; }

    public string? CompanyName { get; set; }

    public string? CompanyCode { get; set; }
    public string? CompanyShortName { get; set; }
    public bool? IsActive { get; set; }
    public bool? IsDeleted { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string? CreatedBy { get; set; }

    public DateTime? UpdateDate { get; set; }

    public string? UpdateBy { get; set; }

}
