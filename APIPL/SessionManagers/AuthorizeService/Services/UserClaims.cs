using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;

namespace SessionManagers.AuthorizeService.services
{
   public class UserClaims
    {
        public static string[] GetUserClaims(ClaimsPrincipal principal,string claimTypes)
        {
            string claimValue = string.Empty;
            try
            {
               
               
                claimValue = principal.Claims.Where(a => a.Type.ToLower() == claimTypes.Trim().ToLower())?.FirstOrDefault()?.Value;                
            }
            catch (Exception ex)
            {
               // Log.Error("UserHelper:GetClaimValue :: Error message => {error}", ex.Message);

            }

            return new[] { claimValue };

        }
        public static string GetClaimByForContext(HttpContext httpContext, string claimname)
        {
            string claimValue = string.Empty;
            try
            {
                claimValue = httpContext.User.Claims.Where(a => a.Type.ToLower().Contains(claimname.Trim().ToLower()))?.FirstOrDefault()?.Value;
            }
            catch (Exception ex)
            {
               
            }
            return claimValue;
        }
        public static List<string> GetUserRoleByClaims(IEnumerable<Claim> claims)
        {
            List<string> claimValue = new List<string>();
            try
            {
                  claimValue = claims.Where(c => c.Type == ClaimTypes.Role).Select(c => c.Value).ToList();

            }
            catch (Exception ex)
            {
                // Log.Error("UserHelper:GetClaimValue :: Error message => {error}", ex.Message);

            }

            return claimValue;

        }
    }
}
