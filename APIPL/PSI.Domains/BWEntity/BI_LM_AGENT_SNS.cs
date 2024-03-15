namespace PSI.Domains.BWEntity
{
    public class BI_LM_AGENT_SNS
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
        public string CREATEDMONTH { get; set; }
        public string? SALES_TYPE { get; set; }
        public string? PSI_CONS_CODE { get; set; }
        public int? PSI_YYYYMM { get; set; }
        public string? PSI_ITEM_CODE { get; set; }
        public int? LM_QTY { get; set; }
        public decimal? LM_AMT { get; set; }

        public DateTime? CREATEDON { get; set; }
        public DateTime? UPDATEDON { get; set; }
    }
}
