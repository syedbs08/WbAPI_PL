

using System.ComponentModel.DataAnnotations;

namespace SessionManagers.Commands
{
    public class AssignRoleCommand
    {
        [Required]
        public string[] RoleIds { get; set; }
        [Required]
        public string[] BackendRoleId { get; set; }
        [Required]
        public string PrincipalId { get; set; }
        public string[] DeletedRoles { get; set; }
        public string[] DeletedBackendRoleIds { get; set; }
    }
}
