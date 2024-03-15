using Core.BaseUtility.TableSearchUtil;
using Core.BaseUtility.Utility;
using DevExtreme.AspNet.Data.ResponseModel;
using PSI.Modules.Backends.AccessManagement;
using PSI.Modules.Backends.WebApi.Results;

namespace PSI.Modules.Backends.Services
{
    public interface IMenuService
    {
        IEnumerable<MenuResult> GetMenu(SessionData user);
        Result CreateMenu(MenuCommand command);
        IEnumerable<MenuResult> MenuLookup();
        Task<LoadResult> GetAllMenu(DataSourceLoadOptions loadOptions);
        void CreateRoles();
    }
}
