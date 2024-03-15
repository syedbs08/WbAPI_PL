using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.AspNetCore.Http;
using PSI.Modules.Backends.DirectSales.Command;
using PSI.Modules.Backends.Report.Queries;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.DirectSales.Queries
{
    public class DirectSaleReportSearchQuery : IRequest<Result>
    {
        public DirectSaleReportSearchQuery(DirectSaleReport directSaleReport)
        {
            DirectSaleReport = directSaleReport;
        }
        public DirectSaleReport DirectSaleReport { get; set; }
    }
    public class DirectSaleReport
    {
        public int CustomerId { get; set; }
        public int ProductCategoryId { get; set; }
        public int? ProductSubCategoryId { get; set; }
        public string SaleSubType { get; set; }
    }

}
