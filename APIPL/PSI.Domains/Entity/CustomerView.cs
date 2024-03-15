using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public class CustomerView:BaseEntity
    {
        public int CustomerId { get; set; }
        public string? CustomerCode { get; set; }
        public string? CustomerName { get; set; }
        public string? CustomerShortName { get; set; }
        public string? EmailId { get; set; }
        public int? RegionId { get; set; }
        public string? RegionName { get; set; }
        public string? RegionCode { get; set; }
        public int? DepartmentId { get; set; }
        public string? DepartmentName { get; set; }
        public string? DepartmentCode { get; set; }
        public int? CountryId { get; set; }
        public string? CountryName { get; set; }
        public string? CountryCode { get; set; }
        public int? SalesOfficeId { get; set; }
        public string? SalesOfficeName { get; set; }
        public string? SalesOfficeCode { get; set; }
        public string? PersonInChargeId { get; set; }
        public string? PersonInChargeName { get; set; }
        public bool? IsBP { get; set; }
        public bool? IsPSI { get; set; }=false;
        public bool? IsActive { get; set; } = true;
        public bool? IsCollabo { get; set; } 
        public string? SalesTypeIds { get; set; }
        public string? SalesTypeNames { get; set; }
        public int? AccountId { get; set; }
        public string? SalesOrganizationCode { get; set; }
        public string? CreatedDate { get; set; }
        public string? UpdateDate { get; set; }
        public string? UpdateDate1 { get; set; }
        public string? CreatedDate1 { get; set; }
        public string? UpdateBy { get; set; }
        public string? CreatedBy { get; set; }
        public string? AccountCode { get; set; }
       

    }
}
