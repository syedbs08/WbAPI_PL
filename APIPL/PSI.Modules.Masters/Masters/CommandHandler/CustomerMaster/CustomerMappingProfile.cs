using AutoMapper;
using NPOI.SS.Formula.PTG;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Results;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.CommandHandler.CustomerMaster
{
    public class CustomerMappingProfile : Profile
    {
        public CustomerMappingProfile()
        {
            CreateMap<CustomerView, CustomerListResult>()
              .ForMember(pts => pts.CustomerCode, opt => opt.MapFrom(ps => ps.CustomerCode))
            .ForMember(pts => pts.CustomerName, opt => opt.MapFrom(ps => ps.CustomerName))
            .ForMember(pts => pts.CustomerId, opt => opt.MapFrom(ps => ps.CustomerId));
            CreateMap<Customer, CustomerListResult>()
             .ForMember(pts => pts.CustomerCode, opt => opt.MapFrom(ps => ps.CustomerCode))
           .ForMember(pts => pts.CustomerName, opt => opt.MapFrom(ps => ps.CustomerName))
           .ForMember(pts => pts.CustomerId, opt => opt.MapFrom(ps => ps.CustomerId));
        }
       
    }
}
