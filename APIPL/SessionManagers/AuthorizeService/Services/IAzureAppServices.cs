using Core.BaseUtility.Utility;
using Microsoft.Graph;
using PSI.Domains.Entity;
using SessionManagers.Commands;
using SessionManagers.Results;

namespace SessionManagers.AuthorizeService.Services
{
    public interface IAzureAppServices
    {
        IEnumerable<AppRolesResult> GetAppRoles();
        List<AppUsers> GetUsers();
        Task<Result> MapUserWithRoles(AssignRoleCommand command);
        List<UserObject> UserLookUp(string searchTerm);
        void CreateRoles();
        IEnumerable<Users> SyncUser();
        List<User> GetUsersFromGraph();

    }
}
