using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class SalesArchivalEntry : BaseEntity
    {
        public int SalesArchivalEntryId { get; set; }
        public int? SaleEntryArchivalHeaderId { get; set; }
        public int? MaterialId { get; set; }
        public int? ProductCategoryId1 { get; set; }
        public int? ProductCategoryId2 { get; set; }
        public int? ProductCategoryId3 { get; set; }
        public int? ProductCategoryId4 { get; set; }
        public int? ProductCategoryId5 { get; set; }
        public int? ProductCategoryId6 { get; set; }
        public string? OCmonthYear { get; set; }
        public string? OCstatus { get; set; }
        public string? OrderStatusCofirmedSource { get; set; }
        public string? OrderConfirmedBySaleTeam { get; set; }
        public DateTime? OrderConfirmedBySaleTeamDate { get; set; }
        public string? OrderConfirmedByProductTeam { get; set; }
        public string? OrderConfirmedByProductDate { get; set; }
        public int? FileInfoId { get; set; }
        public string? O_LockMonthConfirmedStatus { get; set; }
        public string? O_LockMonthConfirmedBy { get; set; }
        public DateTime? O_LockMonthConfirmedDate { get; set; }
    }
}
