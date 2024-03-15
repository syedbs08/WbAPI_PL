using Core.BaseEntitySql.BaseRepository;
using Microsoft.Extensions.Azure;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.GlobalConfigMaster
{
    public partial interface IGlobalConfigRepository
    {
        string GetGlobalConfigByKey(string? type);
    }
    public partial class GlobalConfigRepository
    {
        public string GetGlobalConfigByKey(string? type)
        {
            var result = FirstOrDefault(Query.WithFilter(Filter<GlobalConfig>.Create(p => p.ConfigKey == type)));
            return result == null ? "": result.ConfigValue;
        }
    }
}
