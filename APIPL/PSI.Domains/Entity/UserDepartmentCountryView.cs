using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class UserDepartmentCountryView : BaseEntity
    {
        public string? UserId { get; set; }
        public string? UserName { get; set; }
        public int? DepartmentId { get; set; }
        public string? DepartmentName { get; set; }
        public string? CountryId { get; set; }
    }
}
