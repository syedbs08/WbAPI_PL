using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Adjustments.Command
{
    public class AdjustmentEntryData
    {
        public List<AdjustmentData> AdjustmentData { get; set; }
        public List<AdjustmentEntryQty> AdjustmentEntryQty { get; set; }
        public List<AdjustmentEntryPrice> AdjustmentEntryPrice { get; set; }
        public List<AdjustmentEntryTotalAmount> AdjustmentEntryTotalAmount { get; set; }

        public List<SP_INSERT_ADJUSTMENT> ResponseList { get; set; }

        public AdjustmentEntryData()
        {
            AdjustmentData = new List<AdjustmentData>();
            AdjustmentEntryQty = new List<AdjustmentEntryQty>();
            AdjustmentEntryPrice = new List<AdjustmentEntryPrice>();
            AdjustmentEntryTotalAmount = new List<AdjustmentEntryTotalAmount>();
            ResponseList = new List<SP_INSERT_ADJUSTMENT>();
        }
    }

    public class AdjustmentData
    {

        public string? CustomerCode { get; set; }
        public string? MaterialCode { get; set; }
        public string? Type { get; set; }
        public int? AttachmentID { get; set; }
        public int? RowNum { get; set; }

      
    }

    public class AdjustmentEntryQty
    {

        public int? AdjustmentEntryID { get; set; }
        public string? MonthYear { get; set; }
        public string? Qty { get; set; }
        public string? Price { get; set; }
        public decimal? TotalAmount { get; set; }
        public int RowNum { get; set; }
       
    }
    public class AdjustmentEntryPrice
    {

        public int? AdjustmentEntryID { get; set; }
        public string? MonthYear { get; set; }
        public string? Price { get; set; }
        public int? CurrencyID { get; set; }
        public int? RowNum { get; set; }
       
    }

    public class AdjustmentEntryTotalAmount
    {

        public int? AdjustmentEntryID { get; set; }
        public string? MonthYear { get; set; }
        public decimal? TotalAmount { get; set; }
        public int? RowNum { get; set; }
       
    }
}

