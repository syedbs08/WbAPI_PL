using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.SNS.Command
{
    public class SNSEntryData
    {
        public List<SNSData> SNSData { get; set; }
        public List<SNSEntryQty> SNSEntryQty { get; set; }
        public List<SNSEntryPrice> SNSEntryPrice { get; set; }
        public List<SNSEntryTotalAmount> SNSEntryTotalAmount { get; set; }

        public List<SP_InsertSNSEntryDetails> ResponseList { get; set; }

        public SNSEntryData()
        {
            SNSData = new List<SNSData>();
            SNSEntryQty = new List<SNSEntryQty>();
            SNSEntryPrice = new List<SNSEntryPrice>();
            SNSEntryTotalAmount = new List<SNSEntryTotalAmount>();
            ResponseList = new List<SP_InsertSNSEntryDetails>();
        }
    }

    public class SNSData
    { 
    
        public string? CustomerCode { get; set; }
        public string? CustomerName { get; set; }
        //public int? MaterialID { get; set; }
        //public int? CategoryID { get; set; }
        public string? MaterialCode { get; set; }
        public string? CategoryID { get; set; }
        public string? Category { get; set; }
        public int? AttachmentID { get; set; }
        public int? RowNum { get; set; }

        public int SalesTypeID { get; set; }
        public int ModeTypeID { get; set; }
    }

    public class SNSEntryQty
    { 
    
        public int? SNSEntryID { get; set; }
        public int? MonthYear { get; set; }
        public int? Qty { get; set; }
        public decimal? Price { get; set; }
        public decimal? TotalAmount { get; set; }
         public int RowNum { get; set; }
        //public DateTime CreatedDate { get; set; }
        //public string CreatedBy { get; set; }
        //public DateTime UpdatedDate { get; set; }
        //public 
    }
    public class SNSEntryPrice
    {

        public int? SNSEntryID { get; set; }
        public int? MonthYear { get; set; }
        public decimal? Price { get; set; }
        public int? CurrencyID { get; set; }
        public int? RowNum { get; set; }
        //public DateTime CreatedDate { get; set; }
        //public string CreatedBy { get; set; }
        //public DateTime UpdatedDate { get; set; }
        //public 
    }

    public class SNSEntryTotalAmount
    {

        public int? SNSEntryID { get; set; }
        public string? MonthYear { get; set; }
        public decimal? TotalAmount { get; set; }
        public int? RowNum { get; set; }
        //public DateTime CreatedDate { get; set; }
        //public string CreatedBy { get; set; }
        //public DateTime UpdatedDate { get; set; }
        //public 
    }
}
