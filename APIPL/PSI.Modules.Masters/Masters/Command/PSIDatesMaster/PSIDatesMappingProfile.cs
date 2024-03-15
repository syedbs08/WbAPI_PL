using AutoMapper;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Results;
using PSI.Modules.Backends.WebApi.Results;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Command.PSIDatesMaster
{
    public class PSIDatesMappingProfile : Profile
    {
        public PSIDatesMappingProfile()
        {
            CreateMap<PSIDates, PSIDatesResult>()
              .ForMember(pts => pts.TransmitDate, opt => opt.MapFrom(ps => ps.TransmitDate.ToString("MM/dd/yyyy")))
            .ForMember(pts => pts.ATPDate, opt => opt.MapFrom(ps => ps.ATPDate.ToString("MM/dd/yyyy")))
            .ForMember(pts => pts.PODate, opt => opt.MapFrom(ps => ps.PODate.ToString("MM/dd/yyyy")));

        }
    }
}

