using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Command.UserProductMap
{
    public class UserProductMappingCommand
    {
        public int Id { get; set; }
        [Required]
        public int?[] ProductIdId { get; set; }
        [Required]
        public string? UserId { get; set; }
        public int?[] DeletedProductId { get; set; }
    }
}
