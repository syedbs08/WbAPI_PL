using Core.BaseUtility.Utility;
using PSI.Modules.Backends.WebApi.Results;
using System.Xml;
using static PSI.Modules.Backends.Constants.Contants;
using PSI.Modules.Backends.AccessManagement;
using Microsoft.Azure.ActiveDirectory.GraphClient;
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using ClientCredential = Microsoft.IdentityModel.Clients.ActiveDirectory.ClientCredential;
using AuthenticationResult = Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationResult;
using AppRole = Microsoft.Azure.ActiveDirectory.GraphClient.AppRole;
using Core.BaseUtility.TableSearchUtil;
using System.Data;
using System.Net.NetworkInformation;
using System;
using DevExtreme.AspNet.Data.ResponseModel;
using DevExtreme.AspNet.Data;
using NPOI.POIFS.Crypt.Dsig;

namespace PSI.Modules.Backends.Services
{
    public class MenuService : IMenuService
    {

        public IEnumerable<MenuResult> GetMenu(SessionData user)
        {
            XmlDocument xMenu = new XmlDocument();
            string baseUrl = "";
            string pathToMenuItemFile = ConfigHelper.GetPathToConfigurationFile("xquery\\site.xml");

            xMenu.Load(Path.Combine(pathToMenuItemFile));
            List<MenuResult> menuItems = new List<MenuResult>();

            foreach (XmlNode xn in xMenu.FirstChild.ChildNodes)
            {
                XmlAttribute allow = xn.Attributes["allow"];
                if (allow.Value.ToUpper() == MenuEnum.ALL.ToString())
                {
                    menuItems.Add(CreateMenuItem(user.Roles, baseUrl, xn, 1));
                }
                else
                {
                    if (IsAllowed(user.Roles, xn))
                    {
                        menuItems.Add(CreateMenuItem(user.Roles, baseUrl, xn, 1));
                    }
                }
            }
            return menuItems.OrderBy(x=>x.Order);


        }

        private MenuResult CreateMenuItem(List<string> roles, string baseUrl,
            XmlNode menuNode, int level)
        {

            var menu = new MenuResult();
            menu.Path = menuNode.Attributes["url"]?.Value;
            menu.Icon = menuNode.Attributes["icon"]?.Value;
            menu.Title = menuNode.Attributes["title"]?.Value;
            menu.Type = menuNode.Attributes["type"]?.Value;
            menu.Order = Convert.ToInt32(menuNode.Attributes["order"]?.Value);
            menu.Active = Convert.ToBoolean(menuNode.Attributes["active"]?.Value);
            foreach (XmlNode xTab in menuNode.ChildNodes)
            {
                if (IsAllowed(roles, xTab))
                {
                    menu.Children.Add(CreateMenuItem(roles, baseUrl, xTab, level + 1));
                }
            }
            return menu;
        }

        private bool IsAllowed(List<string> roles, XmlNode xMenuNode)
        {

            bool valid = false;
            XmlAttribute allow = xMenuNode.Attributes?["allow"];
            XmlAttribute deny = xMenuNode.Attributes?["deny"];
            if ((allow != null))
            {
                string sallow = allow.Value;

                foreach (var role in roles)
                {
                    string[] values = sallow.Split(',');
                    foreach (string value in values)
                    {
                        if (role.Trim() == value.Trim())
                        {
                            valid = true;
                        }
                    }
                }
            }
            else
            {
                valid = true;
            }

            if ((deny != null))
            {
                string sdeny = deny.Value;

                foreach (var role in roles)
                {
                    string[] values = sdeny.Split(',');

                    foreach (string value in values)
                    {
                        if (role.Trim() == value.Trim())
                        {
                            valid = false;
                        }
                    }
                }
            }

            return valid;
        }


        public Result CreateMenu(MenuCommand command)
        {
            string pathToMenuItemFile = ConfigHelper.GetPathToConfigurationFile("xquery\\site.xml");
            XmlDocument xMenu = new XmlDocument();
            xMenu.Load(Path.Combine(pathToMenuItemFile));

            if (!string.IsNullOrWhiteSpace(command.Title))
            {
                var parentNode = GetParentNode(xMenu, command.Title);
                if (parentNode != null)
                {
                    RemoveFromParent(parentNode);
                    // xMenu.ParentNode.Attributes.Remove(attribute)
                    //  xMenu.RemoveChild(parentNode);
                    //foreach (var item in command.Children)
                    //{
                    //    var childNode = SetChildNodes(item, xMenu);
                    //    if (childNode != null)
                    //    {
                    //        parentNode.AppendChild(childNode);
                    //    }
                    //}
                }

                var newParentNode = xMenu.DocumentElement.AppendChild(SetParentMenu(command, xMenu));
                if (newParentNode != null)
                {
                    foreach (var item in command.Children)
                    {
                        var childNode = SetChildNodes(item, xMenu);
                        if (childNode != null)
                        {
                            newParentNode.AppendChild(childNode);
                        }
                    }
                }

                xMenu.Save(Path.Combine(pathToMenuItemFile));
            }
            return Result.Success;
        }
        public XmlNode RemoveFromParent(XmlNode node)
        {
            return (node == null) ? null : node.ParentNode.RemoveChild(node);
        }
        private XmlNode GetParentNode(XmlDocument doc, string parentTitle)
        {
            var selectParent = doc.SelectNodes("/root/item[@title='" + parentTitle + "']")[0];
            return selectParent;
        }
        private XmlElement SetChildNodes(MenuCommand childNodes, XmlDocument doc)
        {
            var items = doc.CreateElement("item");
            items.SetAttribute("title", childNodes.Title);
            items.SetAttribute("type", "link");
            items.SetAttribute("url", childNodes.Path);
            items.SetAttribute("icon", "");
            items.SetAttribute("order", 0.ToString());//can be set if required 
            items.SetAttribute("allow", string.Join(",", childNodes.Roles));
            items.SetAttribute("active", "false");
            return items;

        }
        private XmlElement SetParentMenu(MenuCommand parentMenu, XmlDocument doc)
        {
            var items = doc.CreateElement("item");
            items.SetAttribute("title", parentMenu.Title);
            items.SetAttribute("type", "sub");
            items.SetAttribute("url", "");
            items.SetAttribute("icon", parentMenu.Icon);
            items.SetAttribute("order", parentMenu.Order.ToString());
            items.SetAttribute("allow", string.Join(",", parentMenu.Roles));
            items.SetAttribute("active", "false");
            return items;

        }
        public IEnumerable<MenuResult> MenuLookup()
        {
            string pathToMenuItemFile = ConfigHelper.GetPathToConfigurationFile("xquery\\site.xml");
            XmlDocument xMenu = new XmlDocument();
            xMenu.Load(Path.Combine(pathToMenuItemFile));
            var menuList = new List<MenuResult>();
            foreach (XmlNode xn in xMenu.FirstChild.ChildNodes)
            {
                if (xn.Attributes["title"]?.Value.ToUpper() != "HOME")
                {
                    var menu = new MenuResult();
                    menu.Title = xn.Attributes["title"]?.Value;
                    menu.Icon = xn.Attributes["icon"]?.Value;
                    menu.Path = xn.Attributes["url"]?.Value;
                    menu.Roles = xn.Attributes["allow"]?.Value;
                    menu.Type = xn.Attributes["type"]?.Value;
                    menu.Order = Convert.ToInt32(xn.Attributes["order"]?.Value);
                    if (xn.ChildNodes.Count > 0)
                    {
                        foreach (XmlNode xn2 in xn.ChildNodes)
                        {
                            var menuChildItem = new MenuResult();
                            menuChildItem.Title = xn2.Attributes["title"]?.Value;
                            menuChildItem.Icon = xn2.Attributes["icon"]?.Value;
                            menuChildItem.Path = xn2.Attributes["url"]?.Value;
                            menuChildItem.Roles = xn2.Attributes["allow"]?.Value;
                            menuChildItem.Type = xn2.Attributes["type"]?.Value;

                            menu.Children.Add(menuChildItem);
                        }
                    }
                    menuList.Add(menu);
                }
            }
            return menuList;

        }


        public async Task<LoadResult> GetAllMenu(DataSourceLoadOptions loadOptions)
        {
            string pathToMenuItemFile = ConfigHelper.GetPathToConfigurationFile("xquery\\site.xml");
            XmlDocument xMenu = new XmlDocument();
            xMenu.Load(Path.Combine(pathToMenuItemFile));
            var menuList = new List<MenuResult>();
            foreach (XmlNode xn in xMenu.FirstChild.ChildNodes)
            {
                var menu = new MenuResult();
                menu.Title = xn.Attributes["title"]?.Value;
                menu.Icon = xn.Attributes["icon"]?.Value;
                menu.Path = xn.Attributes["url"]?.Value;
                menu.Roles = xn.Attributes["allow"]?.Value;
                menu.Type = xn.Attributes["type"]?.Value;
                menu.Order = Convert.ToInt32(xn.Attributes["order"]?.Value);
                if (xn.ChildNodes.Count > 0)
                {
                    foreach (XmlNode xn2 in xn.ChildNodes)
                    {
                        var menuChildItem = new MenuResult();
                        menuChildItem.Title = xn2.Attributes["title"]?.Value;
                        menuChildItem.Icon = xn2.Attributes["icon"]?.Value;
                        menuChildItem.Path = xn2.Attributes["url"]?.Value;
                        menuChildItem.Roles = xn2.Attributes["allow"]?.Value;
                        menuChildItem.Type = xn2.Attributes["type"]?.Value;

                        menu.Children.Add(menuChildItem);
                    }
                }
                menuList.Add(menu);
            }
            var result = DataSourceLoader.Load(menuList.OrderBy(x=>x.Order), loadOptions);
             return await Task.FromResult(result);

        }
        public async Task createAppRoles()
        {
            // var _graphClient = await GraphClientHelper.GetGraphApiClient();
            //await _graphClient.DirectoryRoles()
            //var result = await _graphClient.ServicePrincipals.
            //.Request()
            // .AddAsync(new AppRole
            // {
            //     Id = Guid.NewGuid(),
            //     IsEnabled = true,
            //     AllowedMemberTypes = new List<string> { "User" },
            //     Description = "My Role Description..",
            //     DisplayName = "My Custom Role",
            //     Value = "MyCustomRole"
            // });


        }
        public void CreateRoles()
        {
            ActiveDirectoryClient activeDirectoryClient = new ActiveDirectoryClient(new Uri("https://graph.windows.net/312ca928-514b-41d6-9b98-496fe46e422c"),
                async () => await GetTokenForApplication());
            IApplication application = activeDirectoryClient.Applications.GetByObjectId("9b84066b-ce02-4e74-bb56-defa90afc39c").ExecuteAsync().GetAwaiter().GetResult();

            AppRole NewRole = new AppRole
            {
                Id = Guid.NewGuid(),
                IsEnabled = true,
                AllowedMemberTypes = new List<string> { "User" },
                Description = "My Role Description..",
                DisplayName = "My Custom Role",
                Value = "MyCustomRole"
            };

            application.AppRoles.Add(NewRole as AppRole);
            application.UpdateAsync().Wait();

        }



        public static async Task<string> GetTokenForApplication()
        {
            string TokenForApplication = "";

            AuthenticationContext authenticationContext = new AuthenticationContext(
                "https://login.microsoftonline.com/312ca928-514b-41d6-9b98-496fe46e422c",
                false);

            // Configuration for OAuth client credentials 

            ClientCredential clientCred = new ClientCredential("41c26c7a-e4bd-4467-be53-6969f4d151bd",
                "ou48Q~.nGS4_vPI30T187g.FtF~S~Hfp3rdR3bnM"
                );
            AuthenticationResult authenticationResult =
                await authenticationContext.AcquireTokenAsync("https://graph.windows.net", clientCred);
            TokenForApplication = authenticationResult.AccessToken;

            return TokenForApplication;
        }


    }

}
