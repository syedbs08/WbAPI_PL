using Core.BaseUtility.Utility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SessionManagers.AuthorizeService
{
    public class BaseAuthoriseService
    {
        private readonly string[] _roles;
        private readonly string[] _users;
        private readonly string[] _ips;
        public BaseAuthoriseService(string[] roles, string[]users,string[] ips)
        {
            _roles = roles;
            _users = users;
            _ips = ips;
        }
        public bool IsAuthorizedByRole(SessionData session)
        {
            if (_roles.Length > 0 && session.Roles.Any(x => _roles.Contains(x.Trim())))
            {
                return true;
            }
            return false;
        }
    }
}
