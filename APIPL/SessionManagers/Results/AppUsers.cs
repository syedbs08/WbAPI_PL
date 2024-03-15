using Microsoft.Graph;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SessionManagers.Results
{
    public class AppUsers
    {
        public AppUsers()
        {
            RoleList = new List<AppRolesResult>();
        }
        public string UserName { get; set; }
        public string UserId { get; set; }
        public string DisplayName { get; set; }
        public string Email { get; set; }
        public string RoleName { get; set; }
        public Guid RoleId { get; set; }
        public Guid RoleIdBackend { get; set; }
        public List<AppRolesResult> RoleList { get; set; }
        public string UserPrincipalName { get; set; }
        public string RoleAssignmentId { get; set; }
        public string RoleAssignmentIdBackend { get; set; }
        public string RolesName { get; set; }

    }

    public  class UserObject
    {
        public string GivenName { get; set; }
        public string SurName { get; set; }
        public string Id { get; set; }        
        public string DisplayName { get; set; }
        public string Email { get; set; }
        public string UserPrincipalName { get; set; }
       
    }

}
