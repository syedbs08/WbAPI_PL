using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class SP_SNSEntryDownload : BaseEntity
    {

        public int SNSEntryId { get; set; }
        public int? CustomerId { get; set; }
        public string? CustomerCode { get; set; }
        public int? MaterialId { get; set; }

        public string? MaterialCode { get; set; }
        public int? CategoryId { get; set; }
        public string? CategoryCode { get; set; }
        public int? AttachmentID { get; set; }
        public int? MonthYear { get; set; }
        public string? OACCode { get; set; }

        public string? SaleSubType { get; set; }

    }

    


}
