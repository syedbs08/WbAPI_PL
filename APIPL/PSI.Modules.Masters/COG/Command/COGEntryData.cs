using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.COG.Command
{
    public class COGEntryData
    {
        public List<COGData> COGData { get; set; }
        public List<COGEntryPrice> COGEntryPrice { get; set; }
        public List<SP_InsertCOGEntryDetails> ResponseList { get; set; }
        public int AttachmentID { get; set; }
        public int SaleTypeId { get; set; }
        public string SaleSubType { get; set; }
        public COGEntryData()
        {
            COGData = new List<COGData>();
            COGEntryPrice = new List<COGEntryPrice>();
            ResponseList = new List<SP_InsertCOGEntryDetails>();
        }
    }

    public class COGData
    {
        public string? CustomerCode { get; set; }
        public string? CustomerName { get; set; }
        public string? MaterialCode { get; set; }
        public int? RowNum { get; set; }
    }

    public class COGEntryPrice
    {
        public int? COGEntryID { get; set; }
        public int? MonthYear { get; set; }
        public int? Qty { get; set; }
        public decimal? Price { get; set; }
        public int RowNum { get; set; }
        public string? ChargeType { get; set; }
    }

}
