using MediatR;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Queries.CompanyMaster
{
    public class CompanySingleQuery : IRequest<Company>
    {
        public CompanySingleQuery(string companyName,
          string companyCode,int companyId)
        {
            CompanyCode = companyCode;
            CompanyName = companyName;
            CompanyId = companyId;
        }
        public int CompanyId { get; }
        public string CompanyName { get; }
        public string CompanyCode { get; }
    }
}
