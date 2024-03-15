using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Command.MaterialMaster
{
    public class MaterialCommand
    {
        public int MaterialId { get; set; }
        public string? MaterialCode { get; set; }
        public string? MaterialShortDescription { get; set; }
        public int? CompanyId { get; set; }
        public string? BarCode { get; set; }
        public bool? InSap { get; set; }
        public decimal? Weight { get; set; }
        public decimal? Volume { get; set; }
        public int? SeaPortId { get; set; }
        public int? AirPortId { get; set; }
        public int? SupplierId { get; set; }
        public int?[] CountryIds { get; set; }
        public int? ProductCategoryId1 { get; set; }
        public int? ProductCategoryId2 { get; set; }
        public int? ProductCategoryId3 { get; set; }
        public int? ProductCategoryId4 { get; set; }
        public int? ProductCategoryId5 { get; set; }
        public int? ProductCategoryId6 { get; set; }
        public bool? IsActive { get; set; }
        public string? CreatedBy { get; set; }
        public string? UpdateBy { get; set; }
    }
    

}
