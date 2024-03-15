using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.DirectSales.Command
{
    public class OCIndicationMonthSearchCommand
    {
        public string? CountryId { get; set; }
        public string? CustomerId { get; set; }
        public bool? CustomerTypeId { get; set; }
        public string? ProductCategoryId { get; set; }
        public string? ProductSubCategoryId { get; set; }
        public string? StartMonthYear { get; set; }
        //public string? EndMonthYear { get; set; }
    }
}
