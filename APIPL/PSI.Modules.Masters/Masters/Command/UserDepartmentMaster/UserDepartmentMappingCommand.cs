using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Command.UserDepartmentMaster
{
    public class UserDepartmentMappingCommand
    {
        public int Id { get; set; }
        [Required]
        public int?[] DepartmentId { get; set; }
        [Required]
        public string? UserId { get; set; }
        public int?[] DeletedUserDepartmentMapping { get; set; }
    }
}
