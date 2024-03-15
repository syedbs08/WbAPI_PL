﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using Core.BaseUtility;
using System;
using System.Collections.Generic;

namespace PSI.Domains.Entity
{
    public partial class TransmissionData:BaseEntity
    {
        public int ID { get; set; }
        public string CustomerCode { get; set; }
        public string MaterialCode { get; set; }
        public int? ResultMonth { get; set; }
        
        public int? CurrentMonthYear { get; set; }
        public int? LockMonthYear { get; set; }
        public int? MonthYear { get; set; }
        public int? ModeOfTypeID { get; set; }
        public int? Qty { get; set; }
        public long? Amount { get; set; }
        public long? SaleValue { get; set; }
        public string Plan { get; set; }
        public string SaleType { get; set; }
        public string SaleSequenceType { get; set; }
        public string SalesSequenceTypeText { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public string EDIStatus { get; set; }
        public string Status { get; set; }
        public int? PlanTypeCode { get; set; }
        public string? PlanTypeName { get; set; }
        public string? SaleSubType { get; set; }

    }
}