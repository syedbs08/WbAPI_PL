using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public class SP_BI_LM_AGENT_OPSI
    {

        public string COMPANY { get; set; }
        public string? PSI_CONS_CODE { get; set; }
        public string? SALESOFFICE { get; set; }
        public string? REGION { get; set; }
        public string? DEPARTMENT { get; set; }
        public string? COUNTRY { get; set; }
        public string? PSI_ITEM_CODE { get; set; }
        public string? PSI_YYYYMM { get; set; }
        public string? SALES_TYPE { get; set; }
        public string? MGGroup { get; set; }
        public string? MG1 { get; set; }
        public string? MG2 { get; set; }
        public string? MG3 { get; set; }
        public string? MG4 { get; set; }
        public string? MG5 { get; set; }
        public int? LM_O_QTY { get; set; }
        public decimal? LM_O_AMT { get; set; }
        public decimal? LM_O_AMT_USD { get; set; }
        public int? LM_P_QTY { get; set; }
        public decimal? LM_P_AMT { get; set; }
        public decimal? LM_P_AMT_USD { get; set; }
        public int? LM_S_QTY { get; set; }
        public decimal? LM_S_AMT { get; set; }
        public decimal? LM_S_AMT_USD { get; set; }
        public int? LM_I_QTY { get; set; }
        public decimal? LM_I_AMT { get; set; }
        public decimal? LM_I_AMT_USD { get; set; }

    }
}
