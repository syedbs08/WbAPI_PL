using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class sp_NonConsolidateReport : BaseEntity
    {
        public string? Department { get; set; }
        public string? CustomerCode { get; set; }
        public string? Country { get; set; }
        public string? SalesOffice { get; set; }
        public string? SalesType { get; set; }
        public string? Consignee { get; set; }
        public string? Group_Desc { get; set; }
        public string? SubGroup { get; set; }
        public string? Type { get; set; }
        public string? MaterialCode { get; set; }
        public int? MonthYear { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? O_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? P_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? S_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? I_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? TotalO_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? MPO_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? ADJ_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? O_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? P_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? S_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? I_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? MPO_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? ADJ_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? TotalO_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? StockDays_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? StockDays_Amt { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? BPO_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? BPP_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? BPS_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? BPI_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? BPO_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? BPP_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? BPS_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? BPI_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? BPTotalO_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? BPMpo_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? BPAdj_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? BPMpo_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? BPAdj_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? BPTotalO_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]

        public int? BP_STK_DAYS_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? BP_STK_DAYS_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]

        public int? LYO_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? LYP_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? LYS_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? LYI_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? LYO_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? LYP_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? LYS_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? LYI_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? LYTotalO_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? LYMpo_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? LYAdj_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? LYMpo_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? LYAdj_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? LYTotalO_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]

        public int? LY_STK_DAYS_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? LY_STK_DAYS_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? LM_STK_DAYS_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? LM_STK_DAYS_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]

        public int? LMO_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? LMP_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? LMS_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? LMI_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? LMO_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? LMP_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? LMS_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? LMI_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? LMTotalO_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? LMMpo_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? LMAdj_QTY { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? LMMpo_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? LMAdj_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? LMTotalO_AMT { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? Age30 { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? Age60 { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? Age90 { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? Age120 { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? Age150 { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? Age180 { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public int? Age180Greatherthan { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? Age30Amt { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? Age60Amt { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? Age90Amt { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? Age120Amt { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? Age150Amt { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? Age180Amt { get; set; }
        [System.ComponentModel.DefaultValue(0)]
        public decimal? Age180greatherthanAmt { get; set; }


    }
}
