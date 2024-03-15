using Core.BaseUtility;


namespace PSI.Domains.Entity;

public partial class Currency:BaseEntity
{
    public int CurrencyId { get; set; }
    public string? CurrencyCode { get; set; }
    public string? CurrencyName { get; set; }
    public decimal? ExchangeRate { get; set; }   
    public DateTime? CreatedDate { get; set; }
    public string? CreatedBy { get; set; }
    public DateTime? UpdateDate { get; set; }
    public string? UpdateBy { get; set; }
    public int? AttachmentId { get; set; }

}
