using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class sp_ConsolidateReport : BaseEntity
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
        public Int64? Qty { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? Amount { get; set; }
       

        [System.ComponentModel.DefaultValue(0)]
        public decimal? Frt_AMT { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? Cst_AMT { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? Fob_AMT { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? Cog_AMT { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? Gp_AMT { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? Gp_Percentage { get; set; }




        [System.ComponentModel.DefaultValue(0)]
        public Int64? Bp_QTY { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? Bp_AMT { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? BpFrt_AMT { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? BpCst_AMT { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? BpFob_AMT { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? BpCog_AMT { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? BpGp_AMT { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? BpGp_Percentage { get; set; }




        [System.ComponentModel.DefaultValue(0)]
        public Int64? Lm_QTY { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? Lm_AMT { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? LmFrt_AMT { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? LmCst_AMT { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? LmFob_AMT { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? LmCog_AMT { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? LmGp_AMT { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? LmGp_Percentage { get; set; }




        [System.ComponentModel.DefaultValue(0)]
        public Int64? Ly_QTY { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? Ly_AMT { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? LyFrt_AMT { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? LyCst_AMT { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? LyFob_AMT { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? LyCog_AMT { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? LyGp_AMT { get; set; }

        [System.ComponentModel.DefaultValue(0)]
        public decimal? LyGp_Percentage { get; set; }
    }
}
