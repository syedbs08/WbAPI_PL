using Core.BaseUtility;
using System;
using System.Collections.Generic;

namespace PSI.Domains.Entity;

public partial class UserProfileView:BaseEntity
{
    public int UserDeparmentMappId { get; set; }
    public string? UserId { get; set; }
    public int DepartmentId { get; set; }
    public string? DepartmentCode { get; set; }
    public string? DepartmentName { get; set; }
    public int? ProductId { get; set; }
    public string? ProductCode { get; set; }
    public string? ProductName { get; set; }
    public int CountryId { get; set; }
    public string? CountryCode{ get; set; }
    public string? CountryName { get; set; }
}
