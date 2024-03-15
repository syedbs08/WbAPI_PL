using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class MaterialView : BaseEntity
    {

        public int MaterialId { get; set; }

        public string? MaterialCode { get; set; }

        public string? MaterialShortDescription { get; set; }
        public int? CompanyId { get; set; }
        public string? CompanyName { get; set; }

        public string? BarCode { get; set; }

        public bool? InSap { get; set; }=false;
        private string _InSap1;
        public string InSap1
        {
            get
            {
                if (InSap==null)
                {
                    _InSap1 = "False";
                }
                else
                {
                    if ((bool)InSap)
                    {
                        _InSap1 = "True";
                    }
                    else
                    {
                        _InSap1 = "False";
                    }
                }
                return _InSap1;
            }
        }

        public decimal? Weight { get; set; }

        public decimal? Volume { get; set; }

        public int? SeaPortId { get; set; }
        public string? SeaPortName { get; set; }

        public int? AirPortId { get; set; }
        public string? AirPortName { get; set; }

        public int? ProductCategoryId1 { get; set; }
        public string? ProductCategoryName1 { get; set; }

        public int? ProductCategoryId2 { get; set; }
        public string? ProductCategoryName2 { get; set; }

        public int? ProductCategoryId3 { get; set; }
        public string? ProductCategoryName3 { get; set; }

        public int? ProductCategoryId4 { get; set; }
        public string? ProductCategoryName4 { get; set; }

        public int? ProductCategoryId5 { get; set; }
        public string? ProductCategoryName5 { get; set; }

        public int? ProductCategoryId6 { get; set; }
        public string? ProductCategoryName6 { get; set; }
        public int? SupplierId { get; set; }
        public string? SupplierName { get; set; }
        public string? CountryIds { get; set; }
        public string? CountryNames { get; set; }

        public bool? IsActive { get; set; } = true;
        private string _IsActive1;
        public string IsActive1
        {
            get
            {
                if ((bool)IsActive)
                {
                    _IsActive1 = "True";
                }
                else
                {
                    _IsActive1 = "False";
                }
                return _IsActive1;
            }
        }

        public string? CreatedDate { get; set; }
        public string? CreatedDate1 { get; set; }

        public string? CreatedBy { get; set; }

        public string? UpdateDate { get; set; }
        public string? UpdateDate1 { get; set; }


        public string? UpdateBy { get; set; }

        public string? ProductCategoryCode1 { get; set; }
        public string? ProductCategoryCode2 { get; set; }
        public string? ProductCategoryCode3 { get; set; }
        public string? ProductCategoryCode4 { get; set; }
        public string? ProductCategoryCode5 { get; set; }
        public string? ProductCategoryCode6 { get; set; }
    }
}
