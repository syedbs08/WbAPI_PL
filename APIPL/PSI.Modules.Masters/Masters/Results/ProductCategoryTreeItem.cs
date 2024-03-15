using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.WebApi.Results
{
    public class ProductCategoryTreeItem
    {
        
        public string Name { get; set; }
        public string ProductCategoryCode { get; set; }
        public string OldSubCode { get; set; }
        public int Id { get; set; }
        public int Categorylevel { get; set; }
        public string ParentId { get; set; }
        public bool IsActive { get; set; }

    }
}
