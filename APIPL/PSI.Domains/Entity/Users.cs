using Core.BaseUtility;

namespace PSI.Domains.Entity
{
    public partial class Users:BaseEntity
    {
        public string UserId { get; set; }
        public string PrincipalId { get; set; }
        public string Name { get; set; }
        public bool? IsActive { get; set; }
    }
}
