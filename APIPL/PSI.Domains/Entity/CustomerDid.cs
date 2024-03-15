using Core.BaseUtility;
using System;
using System.Collections.Generic;

namespace PSI.Domains.Entity;

public partial class CustomerDID:BaseEntity
{
    public int CustomerDIDId { get; set; }
    public int? CustomerId { get; set; }
    public string? CustomerCode { get; set; }
    public string? AccountCode { get; set; }

    public int? SaleTypeId { get; set; }

    public int? AccountId { get; set; }
    public string? SalesOrganizationCode { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string? CreatedBy { get; set; }

    public DateTime? UpdateDate { get; set; }

    public string? UpdateBy { get; set; }
}
