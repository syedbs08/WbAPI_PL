
using Core.BaseUtility;

namespace PSI.Domains.Entity
{
    public partial class GlobalConfig: BaseEntity
    {
        public int GlobalConfigId { get; set; }
        public string? ConfigKey { get; set; }
        public string? ConfigValue { get; set; }
        public string? ConfigType { get; set; }
        
    }
}
