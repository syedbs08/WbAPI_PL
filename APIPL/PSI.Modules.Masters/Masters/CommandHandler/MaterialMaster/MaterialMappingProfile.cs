using AutoMapper;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Results;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.CommandHandler.MaterialMaster
{
    public class MaterialMappingProfile: Profile
    {
        public MaterialMappingProfile()
        {
            CreateMap<MaterialView, DropDownResult>()
                .ForMember(x => x.Id, y => y.MapFrom(z => z.MaterialId))
                .ForMember(x => x.Name, y => y.MapFrom(z => z.MaterialCode));
        }
    }
}
