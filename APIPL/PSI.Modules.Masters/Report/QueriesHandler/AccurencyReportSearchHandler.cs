using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Constants;
using PSI.Modules.Backends.Helpers;
using PSI.Modules.Backends.Report.Queries;
using PSI.Modules.Backends.Report.Results;
using PSI.Modules.Backends.Transmission.Results;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Report.QueriesHandler
{
    public class AccurencyReportSearchHandler : IRequestHandler<AccurencyReportSearchQuery, Result>
    {
        private readonly PSIDbContext _context;
        public AccurencyReportSearchHandler()
        {
            _context = new PSIDbContext();
        }

        public async Task<Result> Handle(AccurencyReportSearchQuery request, CancellationToken cancellationToken)
        {

            var summaryResult = new AccuracySummary
            {
                MonthList = new List<MonthList>(),
                AccurancyData = new List<SP_ACCURANCY_REPORT_SEARCH>(),
                DataFieldList = new List<DataFieldList>()
            };
            try
            {
                var paramStartMonthYear = new SqlParameter("@StartMonthYear", SqlDbType.NVarChar, 1000);
                paramStartMonthYear.Value = request.AccurencyReportSearch.StartMonthYear;

                var paramEndMonthYear = new SqlParameter("@EndMonthYear", SqlDbType.NVarChar, 1000);
                paramEndMonthYear.Value = request.AccurencyReportSearch.EndMonthYear;

                var dtCustomerCodeList = new DataTable();
                dtCustomerCodeList.Columns.Add(new DataColumn("Code", typeof(string)));
                foreach (var customerCode in request.AccurencyReportSearch.CustomerCode)
                {
                    dtCustomerCodeList.Rows.Add(customerCode);
                }
                var tvpCustomerCodeList = new SqlParameter("@tvpCustomerCodeList", SqlDbType.Structured);
                tvpCustomerCodeList.Value = dtCustomerCodeList;
                tvpCustomerCodeList.TypeName = "dbo.TVP_CUSTOMERCODE_LIST";

                var paramMG = new SqlParameter("@MG", SqlDbType.NVarChar, 1000);
                paramMG.Value = request.AccurencyReportSearch.ProductCategoryId1;

                var paramMG1 = new SqlParameter("@MG1", SqlDbType.NVarChar, 1000);
                paramMG1.Value = request.AccurencyReportSearch.ProductCategoryId2;

                var paramMG2 = new SqlParameter("@MG2", SqlDbType.NVarChar, 1000);
                paramMG2.Value = request.AccurencyReportSearch.ProductCategoryId3;

                var param = new SqlParameter[] {
                paramStartMonthYear,
                paramEndMonthYear,
                    tvpCustomerCodeList,
                    paramMG,
                    paramMG1,
                    paramMG2
                };
                var result = _context.SP_ACCURANCY_REPORT_SEARCH.FromSqlRaw("dbo.SP_ACCURANCY_REPORT_SEARCH  @StartMonthYear,@EndMonthYear,@tvpCustomerCodeList,@MG,@MG1,@MG2", param).AsNoTracking().ToList();
                summaryResult.AccurancyData = result;
          
                var res = _context.ReportAdditionalColumn.Where(x => x.ReportType == "Accuracy").OrderBy(x => x.OrderColumn).AsNoTracking().ToList();
                List<DataFieldList> dataField = new List<DataFieldList>();
                foreach (var item in res)
                {
                    dataField.Add(new DataFieldList()
                    {
                        caption = item.DisplayName,
                        dataField = item.ColumnName,
                        dataType = "number",
                        width = 50,
                        summaryType = "sum",
                        area = "data",


                    });
                }
                if (request.AccurencyReportSearch.Variant != null)
                {
                    var variants = await _context.ReportVariant.Where(x => x.UserId == request.SessionData.ADUserId && x.ReportType == Contants.AccurancyReport && x.VariantName == request.AccurencyReportSearch.Variant).Select(x => x.ColumnName).AsNoTracking().ToListAsync();
                    if (variants.Count() > 0)
                    {
                        var resultvariant = dataField.Where(x => !variants.Contains(x.dataField)).ToList();
                        foreach (var item in resultvariant)
                        {
                            item.area = "undefined";
                        }

                    }
                    summaryResult.DataFieldList = dataField;
                }
                else
                {
                    summaryResult.DataFieldList = dataField;
                }
                summaryResult.DataFieldList.Add(new DataFieldList()
                {
                    dataField = "consignee",
                    caption = "Consignee",
                    width = 120,
                    area = "row"
                });
                summaryResult.DataFieldList.Add(new DataFieldList()
                {
                    dataField = "period",
                    caption = "Period",
                    width = 80,
                    area = "row"
                });
                summaryResult.DataFieldList.Add(new DataFieldList()
                {
                    dataField = "monthYear",
                    caption = "Month Year",
                    width = 120,
                    area = "column"
                });
                var startDate = Helper.GetDateFromMonthYear(request.AccurencyReportSearch.StartMonthYear);
                var lastForecastDate = Helper.GetDateFromMonthYear(request.AccurencyReportSearch.EndMonthYear);
                foreach (var item in Helper.PrepareMonthListYYYYMM(startDate.Value, lastForecastDate.Value))
                {
                    summaryResult.MonthList.Add(new MonthList()
                    {
                        Month = item,
                        type = "Monthly"
                    }
                   );
                }
                
                return Result.SuccessWith<AccuracySummary>(summaryResult);
            }
            catch(Exception ex)
            {
                Log.Error($"Error in Accurecy Report with Message - {ex.Message}. StackTrace - {ex.StackTrace}");
                return Result.Failure(Contants.ERROR_MSG);
            }
        }
    }

}
