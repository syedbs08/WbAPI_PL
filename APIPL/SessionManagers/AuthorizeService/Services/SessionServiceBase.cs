
using Core.BaseUtility.Utility;
using Microsoft.AspNetCore.Mvc;

namespace SessionManagers.AuthorizeService.services

{
    public abstract class SessionServiceBase: ControllerBase
    {
        private SessionData? _user;
        public string UserId => SessionMain.EmployeeId;        
        public SessionData? SessionMain
        {            
            get
            {
                _user ??= SessionProvider.GetSessionUser();
                return _user;
            
            }
        }
    }
}
