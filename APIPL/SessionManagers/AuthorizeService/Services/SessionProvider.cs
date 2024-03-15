

using Core.BaseUtility.Extensions;
using Core.BaseUtility.Utility;
using System.Security.Claims;
namespace SessionManagers.AuthorizeService.services
{
    public class SessionProvider
    {
        public static SessionData? GetSessionUser()
        {
            
            var httpContext = HttpContextHandler.Current;
            if (httpContext.User == null)
            {
                return null;

            }
            //get current month=
            return new SessionData
            {

                Name = httpContext.User.FindFirstValue("name"),
                Email = UserClaims.GetClaimByForContext(httpContext, "upn"),
                Roles = GetUserClaimsByPrincipal(AddRoleClaimFromAzureClaim()),
                ADUserId = UserClaims.GetClaimByForContext(httpContext, "objectidentifier"),
                UserIdentifier = UserClaims.GetClaimByForContext(httpContext, "nameidentifier")
                
                
                //old logic
                //ADUserId = UserClaims.GetClaimByForContext(httpContext, "nameidentifier"),
                //UserIdentifier = UserClaims.GetClaimByForContext(httpContext, "objectidentifier"),
            };
        }
        public static IEnumerable<Claim> AddRoleClaimFromAzureClaim()
        {
            var userClaims = HttpContextHandler.Current.User.Claims.ToList();
            if (UserClaims.GetClaimByForContext(HttpContextHandler.Current, "role")!=null)
            {
                var roles = UserClaims.GetClaimByForContext(HttpContextHandler.Current, "role").Split(",").ToList();

                foreach (var role in roles)
                {
                    userClaims.Add(new Claim(ClaimTypes.Role, role.ToString()));
                }
            }
            return userClaims;
        }
        public static List<string> GetUserClaimsByPrincipal(IEnumerable<Claim> claims)
        {
            return UserClaims.GetUserRoleByClaims(claims);
        }
        public static string? GetUserClaimsByPrincipal(ClaimsPrincipal claimsPrincipal, string claimType)
        {
            return UserClaims.GetUserClaims(claimsPrincipal, claimType)?.FirstOrDefault();

        }
    }
}
