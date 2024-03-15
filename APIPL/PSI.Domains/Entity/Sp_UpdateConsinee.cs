using Core.BaseUtility;
namespace PSI.Domains.Entity;

public partial class Sp_UpdateConsinee : BaseEntity
{
    public int RowNo { get; set; }
    public string ResponseCode { get; set; }
    public string ResponseMessage { get; set; }
}
