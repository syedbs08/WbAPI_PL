using Core.BaseUtility;

namespace PSI.Domains.Entity
{
    public partial class VW_SNSPlanningComment:BaseEntity
    {
        public int SNS_Planning_CommentId { get; set; }
        public string? MaterialCode { get; set; }
        public string? AccountCode { get; set; }
        public string? Comment { get; set; }
        public string? CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string? CreatedByName { get; set; }
    }
}
