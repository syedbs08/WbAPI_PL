

namespace PSI.Domains.BWEntity
{
    public partial class BI_FORECAST_AGENT_OPSI 
    {
        public string? COMPANY { get; set; }
       
        public string? SALESOFFICE { get; set; }
        public string? REGION { get; set; }
        public string? COUNTRY { get; set; }
        public string? DEPARTMENT { get; set; }

    
        public string? MGGROUP { get; set; }
        public string? MG1 { get; set; }
        public string? MG2 { get; set; }
        public string? MG3 { get; set; }
        public string? MG4 { get; set; }
        public string? MG5 { get; set; }

        public string? SALES_TYPE { get; set; }
        public string? PSI_CONS_CODE { get; set; }
        public int? PSI_YYYYMM { get; set; }
        public string? PSI_ITEM_CODE { get; set; }
    
        public int? O_QTY { get; set; }
        public decimal? O_AMT { get; set; }
        public decimal? O_AMT_USD { get; set; }
        public int? P_QTY { get; set; }
        public decimal? P_AMT { get; set; }
        public decimal? P_AMT_USD { get; set; }
        public int? S_QTY { get; set; }
        public decimal? S_AMT { get; set; }
        public decimal? S_AMT_USD { get; set; }
        public int? I_QTY { get; set; }
        public decimal? I_AMT { get; set; }
        public decimal? I_AMT_USD { get; set; }
        public decimal? PSI_COST_AMT { get; set; }

        public int? LY_O_QTY { get; set; }
        public decimal? LY_O_AMT { get; set; }
      
        public int? LY_P_QTY { get; set; }
        public decimal? LY_P_AMT { get; set; }
      
        public int? LY_S_QTY { get; set; }
        public decimal? LY_S_AMT { get; set; }
       
        public int? LY_I_QTY { get; set; }
        public decimal? LY_I_AMT { get; set; }

        public decimal? LY_O_AMT_USD { get; set; }
        public decimal? LY_P_AMT_USD { get; set; }
        public decimal? LY_S_AMT_USD { get; set; }
        public decimal? LY_I_AMT_USD { get; set; }
        public decimal? NXT_SALE_AMT { get; set; }
        public decimal? NXT_SALE_AMT_USD { get; set; }
        public DateTime? CREATEDON { get; set; }
        public DateTime? UPDATEDON { get; set; }
    }
}