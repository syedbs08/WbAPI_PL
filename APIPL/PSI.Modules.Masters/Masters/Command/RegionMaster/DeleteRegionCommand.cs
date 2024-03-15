using Core.BaseUtility.Utility;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Command.RegionMaster
{
    public class DeleteRegionCommand : IRequest<Result>
    {
        public DeleteRegionCommand(int regionId,string updateBy)
        {
            RegionId = regionId;
            UpdateBy = updateBy;
        }
        public int RegionId { get; set; }
        public string UpdateBy { get; set; }
    }
}
