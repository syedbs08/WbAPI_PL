using Microsoft.Graph;
using SessionManagers.Results;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Results
{
    public class UserResult
    {
        
        public string? Name { get; set; }
        public string? UserId { get; set; }
        public string? EmailId { get; set; }
        public string? Role { get; set; }
        public string? Department { get; set; }
        public string? Country { get; set; }
        public string? Product { get; set; }
    }
    public class UserDepartmentMappingResult
    {
        public int DepartmentId { get; set; }
        public string? DepartmentCode { get; set; }
        public string? DepartmentName { get; set; }
        public List<string> CountryName { get; set; }

    }
}
