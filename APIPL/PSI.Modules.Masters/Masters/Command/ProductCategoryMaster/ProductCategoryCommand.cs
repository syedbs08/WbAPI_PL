using Core.BaseUtility;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Command.ProductCategoryMaster
{
    public partial class ProductCategoryCommand 
    {
        public int ProductCategoryId { get; set; }

        public string? ProductCategoryName { get; set; }
        public string? ProductCategoryCode { get; set; }

        public string? ParentCategoryId { get; set; }

        public string? ProductCategoryGroup { get; set; }

        public int? CategoryLevel { get; set; }

        public bool? IsActive { get; set; }

        public DateTime? CreatedDate { get; set; }

        public string? CreatedBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public string? UpdateBy { get; set; }
        public bool? Isdeleted { get; set; }
    }
}
