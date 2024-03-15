using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public class Sp_TransmissionListCustomer : BaseEntity
    {
        public string? CustomerName { get; set; }
        public string? CustomerCode { get; set; }
    }
}
