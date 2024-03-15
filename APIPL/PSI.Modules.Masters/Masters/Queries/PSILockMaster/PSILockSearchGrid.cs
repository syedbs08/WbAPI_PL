using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Queries.PSILockMaster
{
    public class PSILockSearchGrid
    {
        public string? UserIds { get; set; }
        public string? SubcategoryId { get; set; }
        public string? CustomerId { get; set; }

    }

    public class PSILockSearchItems
    {
        public string UserIds { get; set; }
        public string SubcategoryCodes { get; set; }
        public string CustomerCodes { get; set; }

    }
}
