using AutoMapper;
using Microsoft.Graph;
using PSI.Domains.Entity;
using PSI.Modules.Backends.WebApi.Results;


namespace PSI.Modules.Backends.WebApi.Results
{
    public class ProductCategoryMappingProfile : Profile
    {
        public  ProductCategoryMappingProfile()
        {
            CreateMap<ProductCategory, ProductCategoryTreeItem>()
               .ForMember(pts => pts.Id, opt => opt.MapFrom(ps => ps.ProductCategoryId))
             .ForMember(pts => pts.Name, opt => opt.MapFrom(ps => ps.ProductCategoryName))
             .ForMember(pts => pts.ParentId, opt => opt.MapFrom(ps => ps.ParentCategoryId))
             .ForMember(pts => pts.Categorylevel, opt => opt.MapFrom(ps => ps.CategoryLevel))
             .ForMember(pts => pts.IsActive, opt => opt.MapFrom(ps => ps.IsActive));
        }
    }
}
