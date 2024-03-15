using PSI.Modules.Backends.WebApi.Results;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.AccessManagement
{
    public class MenuCommand
    {
        public MenuCommand()
        {
            Children = new List<MenuCommand>();
        }

        public bool IsDeleted { get; set; } = false;
        public string Title { get; set; }
        public string Icon { get; set; }
        public string Path { get; set; }
        public string Type { get; set; } = "Sub";
        public bool Active { get; set; } = false;
        public int Order { get; set; }
        public string[] Roles { get; set; }
        public List<MenuCommand> Children { get; set; }
    }
}
