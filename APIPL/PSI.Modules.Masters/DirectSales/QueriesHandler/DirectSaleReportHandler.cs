using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.EntityFrameworkCore;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.DirectSales.Command;
using PSI.Modules.Backends.DirectSales.Queries;
using PSI.Modules.Backends.Report.Queries;
using PSI.Modules.Backends.Transmission.Results;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;

namespace PSI.Modules.Backends.DirectSales.QueriesHandler
{
    public class DirectSaleReportHandler : IRequestHandler<DirectSaleReportSearchQuery, Result>
    {

        private readonly PSIDbContext _context;
        public DirectSaleReportHandler()
        {
            _context = new PSIDbContext();
        }
        public async Task<Result> Handle(DirectSaleReportSearchQuery request, CancellationToken cancellationToken)
        {
            try
            {

                var result = new List<SP_DirectSales_Report>();
                if (request.DirectSaleReport.SaleSubType.ToUpper() == "BP")
                {
                     result = _context.SP_DirectSales_Report.FromSql($"SP_DirectSales_Report_BP  {request.DirectSaleReport.CustomerId},{request.DirectSaleReport.ProductCategoryId},{request.DirectSaleReport.ProductSubCategoryId},{request.DirectSaleReport.SaleSubType}").AsNoTracking().ToList();
                }
                else
                {
                     result = _context.SP_DirectSales_Report.FromSql($"SP_DirectSales_Report  {request.DirectSaleReport.CustomerId},{request.DirectSaleReport.ProductCategoryId},{request.DirectSaleReport.ProductSubCategoryId},{request.DirectSaleReport.SaleSubType}").AsNoTracking().ToList();
                }
                    return Result.SuccessWith<List<SP_DirectSales_Report>>(result);
            }
            catch(Exception ex)
            {
                return null;
            }
        }
    }

}
