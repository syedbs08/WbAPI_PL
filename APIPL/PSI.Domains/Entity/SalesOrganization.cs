using Core.BaseUtility;
using System;
using System.Collections.Generic;

namespace PSI.Domains.Entity;

public partial class SalesOrganization:BaseEntity
{
    public int SalesOrganizationId { get; set; }

    public string? SalesOrganizationCode { get; set; }

    public string? SalesOrganizationName { get; set; }

    public bool? IsActive { get; set; }
}
