using MediatR;
using PSI.Modules.Backends.Masters.Results;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Queries.CustomerMaster
{
    public class CustomerSearchQuery : IRequest<IEnumerable<CustomerResult>>
    {
        public CustomerSearchQuery(
          string searchItem = ""
          )
        {
            SearchItem = searchItem;

        }
        public string SearchItem { get; set; }

    }
}