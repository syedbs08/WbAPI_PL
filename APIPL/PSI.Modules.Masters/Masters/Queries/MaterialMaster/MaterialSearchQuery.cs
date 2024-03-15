using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Results;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Queries.MaterialMaster
{
    public class MaterialSearchQuery : IRequest<IEnumerable<MaterialView>>
    {
        public MaterialSearchQuery(
          string searchItem = ""
          )
        {
            SearchItem = searchItem;

        }
        public string SearchItem { get; set; }

    }
}
