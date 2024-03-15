using Core.BaseUtility;
namespace PSI.Domains.Entity;

public partial class Account:BaseEntity
{
    public int AccountId { get; set; }

    public string? AccountCode { get; set; }

    public string? AccountName { get; set; }

    public bool? IsActive { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string? CreatedBy { get; set; }

    public DateTime? UpdateDate { get; set; }

    public string? UpdateBy { get; set; }
  
}
