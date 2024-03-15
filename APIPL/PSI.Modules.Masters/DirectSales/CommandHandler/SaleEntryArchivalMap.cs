using AutoMapper;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.DirectSales.CommandHandler
{
    public class SaleEntryArchivalMap : Profile
    {
        public SaleEntryArchivalMap()
        {
            CreateMap<SaleEntryArchivalHeader, SalesEntry>()
                .ForMember(opt => opt.SalesEntryId, pts => pts.MapFrom(ps => ps.SaleTypeId));
        }
    }
}
