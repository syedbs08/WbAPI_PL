using SessionManagers.Results;
using Microsoft.Extensions.Configuration;
using SessionManagers.AuthorizeService.Helpers;
using Microsoft.Azure.ActiveDirectory.GraphClient;
using Core.BaseUtility.TableSearchUtil;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Graph;
using AppRoleAssignment = Microsoft.Graph.AppRoleAssignment;
using SessionManagers.Commands;
using Core.BaseUtility.Utility;
using Newtonsoft.Json;
using System.Data;
using User = Microsoft.Graph.User;
using PSI.Domains.Entity;
using SessionManagers.Repository;
using Microsoft.Azure.ActiveDirectory.GraphClient.Internal;

namespace SessionManagers.AuthorizeService.Services
{
    public class AzureAppServices : IAzureAppServices
    {
        private readonly IConfiguration _configuration;
        private readonly IMemoryCache _cache;
        private readonly IUserRepository _userRepo;
        public AzureAppServices(IConfiguration configuration, IMemoryCache cache,
            IUserRepository userRepo)
        {
            _configuration = configuration;
            _cache = cache;
            _userRepo = userRepo;
        }

        public IEnumerable<AppRolesResult> GetAppRoles()
        {
            var _roles = new List<AppRolesResult>();
            _roles = _cache.Get<List<AppRolesResult>>(key: "roles");
            if (_roles is null)
            {
                _roles = PublishRoles().ToList();
                _cache.Set("roles", _roles, TimeSpan.FromHours(24));
            }
            return _roles;
        }
        private IEnumerable<AppRolesResult> PublishRoles()
        {

            ActiveDirectoryClient activeDirectoryClient = new ActiveDirectoryClient(
                  new Uri($"https://graph.windows.net/{_configuration["AzureAD:TenantId"]}"),
                 async () => await AzureClientHelper.GetTokenForApplication(_configuration));

            var application = activeDirectoryClient.Applications.GetByObjectId(_configuration["AppConfig:AppObjectId"])
                .ExecuteAsync().GetAwaiter().GetResult();

            if (application == null)
            {
                return null;
            }

            var roles = application.AppRoles.Select(x =>
            new AppRolesResult
            {
                Id = x.Id,
                DisplayName = x.DisplayName,
                Description = x.Description,
                Value = x.Value,
                IsEnabled = x.IsEnabled,
                AllowedMemberTypes = x.AllowedMemberTypes
            }).ToList();

            //get BackendAppRole


            //ActiveDirectoryClient activeDirectoryClientBackend = new ActiveDirectoryClient(
            //    new Uri($"https://graph.windows.net/{_configuration["AzureAD:TenantId"]}"),
            //   async () => await AzureClientHelper.GetTokenForApplicationBackend(_configuration));

            //var applicationBackend = activeDirectoryClientBackend.Applications.GetByObjectId(_configuration["AppConfig:BackendAppObjectId"])
            //    .ExecuteAsync().GetAwaiter().GetResult();

            //if (applicationBackend == null)
            //{
            //    return null;
            //}


            //var rolesBackend = applicationBackend.AppRoles.Select(x =>
            //new AppRolesResult
            //{
            //    Id = x.Id,
            //    DisplayName = x.DisplayName

            //}).ToList();


            //roles.ForEach(x=>x.BackendId = rolesBackend.FirstOrDefault(y=>y?.DisplayName==x.DisplayName).Id);

            return roles;
        }

        public List<User> GetUsersFromGraph()
        {
            var appUsers = new List<User>();
            foreach (var item in GetAppRoles().Where(x => x.DisplayName != "all").ToList())
            {
                appUsers.AddRange(GetAllUsersFromGroup(item.Id, item.Value, appUsers).Result);
            }          

            var distinctUser = appUsers.DistinctBy(x => x.UserPrincipalName);

            return distinctUser.ToList();
        }
        public List<AppUsers> GetUsers()
        {
            var roles = GetAppRoles();
            var appUsers = _userRepo.GetAll();
            var distinctUser = appUsers.DistinctBy(x => x.PrincipalId);
            var result = distinctUser.Select(x => new AppUsers
            {
                DisplayName = x.Name,
                RoleList = GetRoleAssignment(x.UserId, roles).ToList(),
                UserPrincipalName = x.Name,
                UserId = x.UserId,
                UserName = x.Name,
                Email = x.PrincipalId
            }).ToList();

            return result;
        }
        private List<AppRolesResult> MapRoles(List<AppUsers> users, string principalName)
        {
            var roles = users.Where(y => y.UserPrincipalName == principalName).ToList();
            return roles.Select(x => new AppRolesResult
            {
                Id = x.RoleId,
                DisplayName = x.RoleName,
                Value = x.RoleName,
                RoleAssignmentId = x.RoleAssignmentId,

                //users.FirstOrDefault(y => y.UserPrincipalName == principalName
                // && x.RoleId == y.RoleId)?.RoleAssignmentId,
                BackendRoleAssignmentId = x.RoleAssignmentIdBackend
                //users.FirstOrDefault(y => y.UserPrincipalName == principalName
                //&& x.RoleId == y.RoleId)?.RoleAssignmentIdBackend,
            }).ToList();
        }

   
        public async Task<List<User>> GetAllUsersFromGroup(Guid appRoleId, string roleName, List<User> appUsers)
        {

            try
            {

                var graphClient = GetGraphClient();
                var appRoleAssignment = new List<AppRoleAssignment>();

                var assignedUsers = graphClient.ServicePrincipals[_configuration["AppConfig:ServicePrincipalId"]]
                                               .AppRoleAssignedTo.Request().GetAsync().Result;
                

                while (assignedUsers.Count > 0)
                {
                    appRoleAssignment.AddRange(assignedUsers.ToList());
                    if (assignedUsers.NextPageRequest != null)
                    {
                        assignedUsers = await assignedUsers.NextPageRequest
                            .GetAsync();
                    }
                    else
                    {
                        break;
                    }
                }
               
                if (appRoleAssignment.Any())
                {
                    var userObjectIds = appRoleAssignment.Where(a => a.AppRoleId == appRoleId && a.PrincipalType == "Group").ToList();
                    foreach (var groups in userObjectIds)
                    {
                        var groupMembers = await graphClient.Groups[groups.PrincipalId.ToString()].Members.Request().GetAsync();

                        appUsers.AddRange(groupMembers.CurrentPage.OfType<User>());
                        // fetch next page
                        while (groupMembers.NextPageRequest != null)
                        {
                            groupMembers = groupMembers.NextPageRequest.GetAsync().Result;
                            appUsers.AddRange(groupMembers.CurrentPage.OfType<User>());
                        }
                    }

                    ///will be removed once all user will be mappled with gorup

                    var userObjectByUser = appRoleAssignment.Where(a => a.AppRoleId == appRoleId && a.PrincipalType == "User").ToList();
                    if (userObjectByUser.Any())
                    {
                        var principalIds = userObjectByUser.Select(x => x.PrincipalId.ToString());
                        var userList = graphClient.Users.Request().Filter($"id in ({BuildInFilterMSGraph(principalIds)})").GetAsync().Result;
                        appUsers.AddRange(userList.CurrentPage.OfType<User>());
                        while (userList.NextPageRequest != null)
                        {
                            userList = userList.NextPageRequest.GetAsync().Result;
                            appUsers.AddRange(userList.CurrentPage.OfType<User>());
                        } 
                    }
                }

            }
            catch (Exception ex)
            {

            }
            return appUsers;
        }
        public List<AppUsers> GetAllUsersInAppRoleByGraph(Guid appRoleId, string roleName, Guid appRoleBackendId)
        {
            var users = new List<AppUsers>();
            try
            {

                var graphClient = GetGraphClient();

                var assignedUsers = graphClient.ServicePrincipals[_configuration["AppConfig:ServicePrincipalId"]]
                                                .AppRoleAssignedTo.Request().GetAsync().Result;

                if (assignedUsers != null)
                {
                    var userObjectIds = assignedUsers.Where(a => a.AppRoleId == appRoleId && a.PrincipalType == "User").ToList();
                    if (userObjectIds.Any())
                    {
                        var principalIds = userObjectIds.Select(x => x.PrincipalId.ToString());
                        users = graphClient.Users.Request()
                            .Filter($"id in ({BuildInFilterMSGraph(principalIds)})")
                            .GetAsync().Result.CurrentPage
                            .Select(x => new AppUsers
                            {
                                UserName = x.GivenName,
                                UserId = x.Id,
                                UserPrincipalName = x.UserPrincipalName,
                                DisplayName = x.DisplayName,
                                RoleName = roleName,
                                Email = x.Mail,
                                RoleId = appRoleId,
                                RoleAssignmentId = userObjectIds.FirstOrDefault(y => y.AppRoleId ==
                                appRoleId && y.PrincipalId == Guid.Parse(x.Id)).Id
                            }).ToList();
                    }

                }

                //BackendApi

                var usersBackend = new List<AppUsers>();
                var graphClientBackend = GetBackendGraphClient();

                var assignedUsersBackend = graphClient.ServicePrincipals[_configuration["AppConfig:ServicePrincipalIdBackend"]]
                                                .AppRoleAssignedTo.Request().GetAsync().Result;

                if (assignedUsersBackend != null)
                {
                    var userObjectIdsBackend = assignedUsersBackend.Where(a => a.AppRoleId == appRoleBackendId && a.PrincipalType == "User").ToList();
                    if (userObjectIdsBackend.Any())
                    {
                        var principalIds = userObjectIdsBackend.Select(x => x.PrincipalId.ToString());
                        usersBackend = graphClientBackend.Users.Request()
                            .Filter($"id in ({BuildInFilterMSGraph(principalIds)})")
                            .GetAsync().Result.CurrentPage
                            .Select(x => new AppUsers
                            {
                                UserName = x.GivenName,
                                UserId = x.Id,
                                UserPrincipalName = x.UserPrincipalName,
                                DisplayName = x.DisplayName,
                                RoleName = roleName,
                                Email = x.Mail,
                                RoleId = appRoleId,
                                RoleAssignmentId = userObjectIdsBackend.FirstOrDefault(y => y.AppRoleId ==
                                appRoleBackendId && y.PrincipalId == Guid.Parse(x.Id)).Id
                            }).ToList();
                    }
                }
                var userback = usersBackend;

                foreach (var item in users)
                {
                    // var roleAssignment = usersBackend.FirstOrDefault(y => y.UserId == item.UserId);
                    item.RoleAssignmentIdBackend = usersBackend.FirstOrDefault(y => y.UserId == item.UserId)?.RoleAssignmentId;
                }

                //users.ForEach(x => x.RoleAssignmentIdBackend = 
                //usersBackend.FirstOrDefault(y => y.UserId == x.UserId)?.RoleAssignmentId);


            }
            catch (Exception ex)
            {

            }
            return users;
        }
        private string BuildInFilterMSGraph(IEnumerable<string> usersIds)
        {
            var returnValue = string.Empty;
            foreach (var item in usersIds)
            {
                returnValue = returnValue + "'{" + item + "}',";
            }
            return returnValue.TrimEnd(',');
        }
        public async Task<Result> MapUserWithRoles(AssignRoleCommand command)
        {
            try
            {
                var graphClient = GetGraphClient();


                foreach (var item in command.RoleIds)
                {
                    var requestBody = new AppRoleAssignment
                    {
                        PrincipalId = Guid.Parse(command.PrincipalId),
                        ResourceId = Guid.Parse(_configuration["AppConfig:ServicePrincipalId"]),
                        AppRoleId = Guid.Parse(item.ToString()),
                    };
                    await graphClient.Users[command.PrincipalId].AppRoleAssignments.Request().AddAsync(requestBody);

                }
                ///
                foreach (var item in command.DeletedRoles)
                {
                    await graphClient.ServicePrincipals[_configuration["AppConfig:ServicePrincipalId"]].
                        AppRoleAssignedTo[item].Request().DeleteAsync();

                }
                //backend
                var grarphClientBackend = GetBackendGraphClient();
                foreach (var item in command.BackendRoleId)
                {
                    var requestBody = new AppRoleAssignment
                    {
                        PrincipalId = Guid.Parse(command.PrincipalId),
                        ResourceId = Guid.Parse(_configuration["AppConfig:ServicePrincipalIdBackend"]),
                        AppRoleId = Guid.Parse(item.ToString()),
                    };
                    await grarphClientBackend.Users[command.PrincipalId].AppRoleAssignments.Request().AddAsync(requestBody);

                }
                ///
                foreach (var item in command.DeletedBackendRoleIds)
                {
                    await grarphClientBackend.ServicePrincipals[_configuration["AppConfig:ServicePrincipalIdBackend"]].
                        AppRoleAssignedTo[item].Request().DeleteAsync();

                }

            }
            catch (Microsoft.Graph.ServiceException ex)
            {
                Log.Error(ex.Message);
                var error = JsonConvert.DeserializeObject<GraphRespnoseMessage>(ex.RawResponseBody);
                return await Task.FromResult(Result.Failure($"{error.error.message}"));
            }

            return await Task.FromResult(Result.Success);

        }
        public IEnumerable<Users> SyncUser()
        {
            var usersList = GetUsersFromGraph();

            var existingUser = _userRepo.GetAll();

           var removedUser= existingUser
                   .Where(x => !usersList.Any(y => y.Id == x.UserId)).ToList();
         
            var newuser = usersList.Where(x => !existingUser.Any(y => y.UserId == x.Id));

            if (newuser.Any())
            {
                var userObj = newuser.Select(x =>
                       new Users
                       {
                           UserId = x.Id,
                           Name = x.DisplayName,
                           PrincipalId = x.UserPrincipalName,
                           IsActive = true
                       }
               );
                _userRepo.AddBulk(userObj.ToList());
            }
            if (removedUser.Any())
            {
                removedUser.ForEach(x => x.IsActive = false);
                _userRepo.UpdateBulk(removedUser.ToList());
            }
            return _userRepo.GetAll();
            ;


        }
        public List<UserObject> UserLookUp(string searchTerm)
        {
            var graphClient = GetGraphClient();

            return graphClient.Users
                   .Request()
                   .Filter(SetFilter(searchTerm))
                   .GetAsync().Result.CurrentPage.Select(x => new UserObject
                   {
                       GivenName = x.GivenName,
                       Id = x.Id,
                       Email = x.Mail,
                       DisplayName = x.DisplayName,
                       SurName = x.Surname,
                       UserPrincipalName = x.UserPrincipalName,
                   }).ToList();
        }

        private string SetFilter(string searchItem)
        {
            if (string.IsNullOrWhiteSpace(searchItem))
            {
                return string.Empty;
            }

            return $"startswith(givenName, '{searchItem}')" +
                   $" or startswith(surname, '{searchItem}')" +
                    $" or startswith(displayName, '{searchItem}')" +
                    $" or startswith(userPrincipalName,'{searchItem}')";

        }
        public async void CreateRoles()
        {
            //var graph = AzureClientHelper.GetGraphApiClientBeta(_configuration, _cache);
            //var applications = await graph.Result.Applications[_configuration["AppConfig:FrontEndClientId"]].Request().GetAsync();
            //AppRole NewRole = new AppRole
            //{
            //    Id = Guid.NewGuid(),
            //    IsEnabled = true,
            //    AllowedMemberTypes = new string[] { "User" },
            //    Description = "My Role Description",
            //    DisplayName = "My Custom Role",
            //    Value = "MyCustomRole"
            //};

            // applicatio;

            //ActiveDirectoryClient activeDirectoryClient = new ActiveDirectoryClient(
            //          new Uri($"https://graph.windows.net/{_configuration["AzureAD:TenantId"]}"),
            //         async () => await AzureClientHelper.GetTokenForApplication(_configuration));

            //var application = activeDirectoryClient.Applications.GetByObjectId(_configuration["AppConfig:FrontEndClientId"])
            //    .ExecuteAsync().GetAwaiter().GetResult();

            //AppRole NewRole = new AppRole
            //{
            //    Id = Guid.NewGuid(),
            //    IsEnabled = true,
            //    AllowedMemberTypes = new string[] { "User"},
            //    Description = "My Role Description",
            //    DisplayName = "My Custom Role",
            //    Value = "MyCustomRole"
            //};

            //application.AppRoles.Add(NewRole as AppRole);
            //application.UpdateAsync().GetAwaiter().GetResult();

        }

        private GraphServiceClient GetBackendGraphClient()
        {
            var graphClient = _cache.Get<GraphServiceClient>(key: "graphServiceClientBackend");
            var token = _cache.Get<TokenResult>(key: "graphAccessTokenBackend");
            if (graphClient == null || token.ExpiresOn < DateTime.UtcNow)
            {
                graphClient = AzureClientHelper.GetGraphClientBackend(_configuration, _cache).Result;
            }
            return graphClient;

        }
        private GraphServiceClient GetGraphClient()
        {
            var graphClient = _cache.Get<GraphServiceClient>(key: "graphServiceClient");
            var token = _cache.Get<TokenResult>(key: "graphAccessToken");
            if (graphClient == null || token.ExpiresOn < DateTime.UtcNow)
            {
                graphClient = AzureClientHelper.GetGraphApiClient(_configuration, _cache).Result;
            }
            return graphClient;


        }
        private IEnumerable<AppRolesResult> GetRoleAssignment(string userId, IEnumerable<AppRolesResult> appRoles)
        {
            if (appRoles.Any() == false)
            {
                return appRoles;
            }
            var graphClient = GetGraphClient();
            var allUserRoles = graphClient.Users[$"{userId}"].AppRoleAssignments.Request().GetAsync().Result;// get all assignment 
            var groupRoles = allUserRoles.Where(a => a.PrincipalType == "Group" || a.PrincipalType == "User").ToList(); // filter only group and user
            var userRole = appRoles.Where(x => groupRoles.Any(y => x.Id == y.AppRoleId)).ToList(); // map role id with assigned role Id to get role details
            return userRole;

        }



    }
}
