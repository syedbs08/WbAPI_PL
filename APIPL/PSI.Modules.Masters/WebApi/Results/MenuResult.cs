

namespace PSI.Modules.Backends.WebApi.Results
{
    public class MenuResult
    {
        public MenuResult()
        {
            Children = new List<MenuResult>();
        }
        public string Title { get; set; }
        public string Icon { get; set; }
        public string Path { get; set; }
        public string Type { get; set; }
        public bool Active { get; set; }
        public string Roles { get; set; }
        public int Order { get; set; }
        public List<MenuResult> Children { get; set; }
    }
}
