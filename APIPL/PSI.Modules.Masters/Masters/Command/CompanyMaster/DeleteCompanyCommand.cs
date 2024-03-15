using Core.BaseUtility.Utility;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Command.CompanyMaster
{
    public class DeleteCompanyCommand : IRequest<Result>
    {
        public DeleteCompanyCommand(int companyId, string updateBy)
        {
            CompanyId = companyId;
            UpdateBy = updateBy;
        }


        public int CompanyId { get; set; }
        public string UpdateBy { get; set; }
    }
}
