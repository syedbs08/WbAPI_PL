
using Core.BaseUtility;

namespace PSI.Domains.Entity
{
    public partial class VW_ATTACHMENT : BaseEntity
    {
        public int Id { get; set; }      
        public string? DocumentName { get; set; }
        public bool? IsActive { get; set; }
        public string? DocumentPath { get; set; }
        public string? DocumentMonth { get; set; }
        public string VirtualFileName { get; set; }
        public string? DisplayName { get; set; }        
        public int? FileTypeId { get; set; }
        public string? FolderName { get; set; }
        public string FileTypeName { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string? CreatedBy { get; set; }
        public string? CreatedMonthYear { get; set; }
        

    }
}