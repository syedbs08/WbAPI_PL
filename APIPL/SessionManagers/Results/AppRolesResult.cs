using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SessionManagers.Results
{
    public class AppRolesResult
    {
         public Guid Id { get; set; }
        public Guid BackendId { get; set; }
        public bool IsEnabled { get; set; }
        public IList<string>AllowedMemberTypes { get; set; }
        public string Description { get; set; }
        public string DisplayName { get; set; }
        public string Value { get; set; }
        public string AppRoleId { get; set; }
        public string RoleAssignmentId { get; set; }
        public string BackendRoleAssignmentId { get; set; }


    };
    
}
