
using Core.BaseUtility.TableSearchUtil;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PSI.Modules.Backends.AccessManagement;
using PSI.Modules.Backends.Services;
using SessionManagers.AuthorizeService.services;
using SessionManagers.AuthorizeService.Services;
using SessionManagers.Commands;
using System.Net;


namespace PSI.Modules.Backends.WebApi
{

    [Route("api/v1/authentication")]
    public class AuthenticationController : SessionServiceBase
    {
        private readonly IMenuService _menuServices;
        private readonly IAzureAppServices _azureAppServices;
        public AuthenticationController(IMenuService menuServices,
            IAzureAppServices azureAppServices)
        {
            _menuServices = menuServices;
            _azureAppServices = azureAppServices;
        }
        [HttpGet]

        [Route("status")]
        public IActionResult GetStatus()
        {
            return Ok("auth api called sucessfully");
        }
        /// <summary>
        /// get menus
        /// </summary>
        /// <returns></returns>
        // POST: api/v1/authentcation/menus
        [Authorize]
        [HttpGet]
        [Route("menus")]
        public async Task<IActionResult> GetMenus()
        {
            if (SessionMain == null || string.IsNullOrWhiteSpace(SessionMain.ADUserId)
                || !SessionMain.Roles.Any())
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            return await Task.Run(() =>
            {
                var result = _menuServices.GetMenu(SessionMain);
                return Ok(result);
            });
        }
        [HttpGet]
        [Route("menu-lookup")]
        public async Task<IActionResult> GetMenuLookup()
        {
            return await Task.Run(() =>
            {
                var result = _menuServices.MenuLookup();
                return Ok(result);
            });
        }
        [Authorize]
        [HttpPost]
        [Route("manage-menus")]
        public IActionResult WriteMenu([FromBody] MenuCommand command)
        {
            var result = _menuServices.CreateMenu(command);
            if (!result.IsSuccess)
            {
                return BadRequest(string.Join(",", result.Errors));
            }
            return Ok();
        }
        [HttpGet]
        [Route("menu-list")]
        public async Task<IActionResult> GetMenusList(DataSourceLoadOptions loadOptions)
        {
          
                var result =await _menuServices.GetAllMenu(loadOptions);
                return Ok(result);
           
        }

      
        [HttpGet]

        [Route("get-roles")]
        public async Task<IActionResult> GetRoles()
        {
            return await Task.Run(() =>
            {
                var result = _azureAppServices.GetAppRoles();
                return Ok(result);
            });
        }
        [HttpGet]
        [Route("create-roles")]
        public async Task<IActionResult> CreateRoles()
        {
            return await Task.Run(() =>
            {
                _azureAppServices.CreateRoles();
                return Ok();
            });
        }
       
        [HttpPost]
        [Route("map-roles")]
        public async Task<IActionResult> MapUserRoles([FromBody] AssignRoleCommand command)
        {
            var result = await _azureAppServices.MapUserWithRoles(command);
            if (!result.IsSuccess)
            {
                return BadRequest(result.Errors);
            
            }
            return Ok();
        }
        [HttpGet]
        [Route("user-select/{searchItems}")]
        public IActionResult GetUsers(string searchItems)
        {          
            return Ok(_azureAppServices.UserLookUp(searchItems));
        }
        [HttpGet]
        [Route("user-sync")]
        public IActionResult SyncUser()
        {
          var result=  _azureAppServices.SyncUser();
            return Ok(result);
        }
    }
}
