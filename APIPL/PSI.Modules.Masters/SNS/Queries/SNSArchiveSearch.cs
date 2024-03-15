using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.SNS.Queries
{
    public class SNSArchiveSearch 
    {
        public string? Month { get; set; }
        public string? DirectSaleIds { get; set; }
        public string? SNSIds { get; set; }
    }
}
