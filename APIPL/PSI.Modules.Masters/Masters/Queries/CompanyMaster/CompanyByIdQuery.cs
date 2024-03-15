using MediatR;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Queries.CompanyMaster
{
    public class CompanyByIdQuery : IRequest<Company>
    {
        public CompanyByIdQuery(int id)
        {
            Id = id;
            
        }
        public int Id { get; }
        
    }
}
