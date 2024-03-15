
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using SessionManagers.AuthorizeService.services;



namespace SessionManagers.AuthorizeService
{
    public class BaseAuthorizeAttribute : AuthorizeAttribute, IAuthorizationFilter
    {
        private static readonly string[] Empty = new string[0];
        private string[] _rolesSplit = Empty,_userSplit=Empty,_ipSplit=Empty;
        private string _roles,_users,_ips;
        public void OnAuthorization(AuthorizationFilterContext context)
        {
            var baseAuthoriseService = new BaseAuthoriseService
            (_rolesSplit,
            _userSplit,
            _ipSplit);

            var session = SessionProvider.GetSessionUser();
            if (session == null)
            {
                context.Result = new UnauthorizedResult();
            }
           
            if (!baseAuthoriseService.IsAuthorizedByRole(session))
            {
                context.Result = new UnauthorizedResult();
            }
        }
        public new string Roles
        {
            get => _roles ?? string.Empty;
            set
            {
                _roles = value;
                _rolesSplit = SplitString(value);
            }
        }
        public new string Ips
        {
            get => _ips ?? string.Empty;
            set
            {
                _ips = value;
                _ipSplit = SplitString(value);
            }
        }
        public new string Users
        {
            get => _users ?? string.Empty;
            set
            {
                _users = value;
                _userSplit = SplitString(value);
            }
        }
        internal static string[] SplitString(string original)
        {
            if (string.IsNullOrEmpty(original))
            {
                return new string[0];
            }
            return (from piece in original.Split(',')
                    let trimmed = piece.Trim()
                    where !string.IsNullOrEmpty(trimmed)
                    select trimmed).ToArray();

        }
    }

}
