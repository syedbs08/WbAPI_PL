using AttachmentService.Command;
using Core.BaseUtility.Utility;
using MediatR;
using PSI.Modules.Backends.Masters.Command.RegionMaster;
using System.ComponentModel.DataAnnotations;

namespace PSI.Modules.Backends.Masters.Command.CurrencyMaster
{
    public class CurrencyCommand 
    {
        public FileCommand FileCommand { get; set; }
       
    }
}
