﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using Core.BaseUtility;
using System;
using System.Collections.Generic;

namespace PSI.Domains.Entity
{
    public partial class VW_DASHMASTER:BaseEntity
    {
        public string MaterialCode { get; set; }
        public string CustomerCode { get; set; }
        public string SalesCompany { get; set; }
        public string SupplierCode { get; set; }
        public string SupplierName { get; set; }
        public int ReasonId { get; set; }
        public string TransPortMode { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public DateTime? RegistrationDateTime { get; set; }
        public string RegistrationUserCode { get; set; }
        public DateTime? RecordChangeDateTime { get; set; }
        public string RecordChangeUserCode { get; set; }
        public bool? IsActive { get; set; }
        public int? StartMonth { get; set; }
        public int? EndMonth { get; set; }
        public string ReasonName { get; set; }
        public string CustomerName { get; set; }
      
    }
}