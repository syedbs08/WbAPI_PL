using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Adjustments.Queries;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Queries.MaterialMaster
{
    public class MaterialByMgSearchQuery:IRequest<List<SP_MATERIALSEARCH>>
    {
        public MaterialByMgSearchQuery(MaterilSearch materilSearch)
        {
            MaterilSearch = materilSearch;
            
        }
        public MaterilSearch MaterilSearch { get; set; }
       
    }
    public class MaterilSearch
    {
        public List<int> MG1 { get; set; }
        public List<int?> MG2 { get; set; }
    }
    }
