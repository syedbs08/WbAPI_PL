using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using NetTopologySuite.Algorithm;
using NPOI.SS.Formula.Functions;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Constants;
using PSI.Modules.Backends.Helpers;
using PSI.Modules.Backends.Masters.Repository.GlobalConfigMaster;
using PSI.Modules.Backends.Report.Queries;
using PSI.Modules.Backends.Transmission.Results;
using SixLabors.ImageSharp.ColorSpaces;
using System.ComponentModel.DataAnnotations;
using System.Data;
using Log = Core.BaseUtility.Utility.Log;

namespace PSI.Modules.Backends.Report.QueriesHandler
{
    public class ConsolidatedReportHandler : IRequestHandler<ConsolidatedReportSearchQuery, Result>
    {
        private readonly PSIDbContext _context;
        private readonly IGlobalConfigRepository _globalConfig;
        public ConsolidatedReportHandler(IGlobalConfigRepository globalConfig)
        {
            _context = new PSIDbContext();
            _globalConfig = globalConfig;
        }

        public async Task<Result> Handle(ConsolidatedReportSearchQuery request, CancellationToken cancellationToken)
        {
            try
            {
                var summaryResult = new ConsolidatedSummary
                {
                    MonthList = new List<MonthList>(),
                    ConsolidatedData = new List<sp_ConsolidateReport>(),
                    DataFieldList = new List<DataFieldList>()
                };
                string columnType = "";
                var global = _globalConfig.GetAll();
                Int32 psiYear = Convert.ToInt32(global.Where(x => x.ConfigKey == Contants.global_config_psi_year_key).Select(x => x.ConfigValue).FirstOrDefault());
                Int32 bpYear = Convert.ToInt32(global.Where(x => x.ConfigKey == Contants.global_config_BP_year_key).Select(x => x.ConfigValue).FirstOrDefault());
                string resultMonthYear = global.Where(x => x.ConfigKey == Contants.global_config_result_month_key).Select(x => x.ConfigValue).FirstOrDefault();

                if (request.ConsolidatedReportSearch.SalesSubType == "Monthly")
                {
                    columnType = "CM";
                    if (request.ConsolidatedReportSearch.StartMonthYear != "undefined")
                    {
                        var startDate = Helper.GetDateFromMonthYear(request.ConsolidatedReportSearch.StartMonthYear);
                        var lastForecastDate = Helper.GetDateFromMonthYear(request.ConsolidatedReportSearch.EndMonthYear);
                        foreach (var item in Helper.PrepareMonthListYYYYMM(startDate.Value, lastForecastDate.Value))
                        {
                            summaryResult.MonthList.Add(new MonthList()
                            {
                                Month = item,
                                type = "CM"
                            }
                           );
                        }
                    }
                    else
                    {
                        if (psiYear != null)
                        {
                            var startDate = Helper.GetDateFromMonthYear(psiYear + "04");
                            var endDate = Helper.GetDateFromMonthYear(psiYear + 1 + "03");
                            foreach (var item in Helper.PrepareMonthListYYYYMM(startDate.Value, endDate.Value))
                            {
                                summaryResult.MonthList.Add(new MonthList()
                                {
                                    Month = item,
                                    type = "CM"
                                }
                               );
                            }
                        }
                    }
                }
                else if (request.ConsolidatedReportSearch.SalesSubType == "BP")
                {
                    columnType = "BP";
                    if (request.ConsolidatedReportSearch.StartMonthYear != "undefined")
                    {
                        var startDate = Helper.GetDateFromMonthYear(request.ConsolidatedReportSearch.StartMonthYear);
                        var lastForecastDate = Helper.GetDateFromMonthYear(request.ConsolidatedReportSearch.EndMonthYear);
                        foreach (var item in Helper.PrepareMonthListYYYYMM(startDate.Value, lastForecastDate.Value))
                        {
                            summaryResult.MonthList.Add(new MonthList()
                            {
                                Month = item,
                                type = "BP"
                            }
                           );
                        }
                    }
                    else
                    {
                        if (psiYear != null)
                        {
                            var startDate = Helper.GetDateFromMonthYear(bpYear + "04");
                            var endDate = Helper.GetDateFromMonthYear(bpYear + 1 + "03");
                            foreach (var item in Helper.PrepareMonthListYYYYMM(startDate.Value, endDate.Value))
                            {
                                summaryResult.MonthList.Add(new MonthList()
                                {
                                    Month = item,
                                    type = "BP"
                                }
                               );
                            }
                        }
                    }
                }

                if (request.ConsolidatedReportSearch.AdditionalValue!=null)

                {
                    if (request.ConsolidatedReportSearch.SalesSubType == "Monthly")
                    {

                        if (request.ConsolidatedReportSearch.AdditionalValue.Contains("BP"))
                        {
                            columnType = "BP";
                            if (request.ConsolidatedReportSearch.StartMonthYear != null)
                            {
                                var startDate = Helper.GetDateFromMonthYear(request.ConsolidatedReportSearch.StartMonthYear);
                                var lastForecastDate = Helper.GetDateFromMonthYear(request.ConsolidatedReportSearch.EndMonthYear);
                                foreach (var item in Helper.PrepareMonthListYYYYMM(startDate.Value, lastForecastDate.Value))
                                {
                                    summaryResult.MonthList.Add(new MonthList()
                                    {
                                        Month = item,
                                        type = "MonthlyBP"
                                    }
                                   );
                                }
                            }
                            else
                            {
                                var startDate = Helper.GetDateFromMonthYear(psiYear + "04");
                                var endDate = Helper.GetDateFromMonthYear(psiYear + 1 + "03");
                                foreach (var item in Helper.PrepareMonthListYYYYMM(startDate.Value, endDate.Value))
                                {
                                    summaryResult.MonthList.Add(new MonthList()
                                    {
                                        Month = item,
                                        type = "MonthlyBP"
                                    }
                                   );
                                }
                            }
                        }
                        if (request.ConsolidatedReportSearch.AdditionalValue.Contains("LY"))
                        {
                            columnType = "LY";
                            if (request.ConsolidatedReportSearch.StartMonthYear != "undefined")
                            {
                                var startMonthYear = (Convert.ToInt32(request.ConsolidatedReportSearch.StartMonthYear.Substring(0, 4)) - 1) + request.ConsolidatedReportSearch.StartMonthYear.Substring(4, 2);
                                var endMonthYear = (Convert.ToInt32(request.ConsolidatedReportSearch.EndMonthYear.Substring(0, 4)) - 1) + request.ConsolidatedReportSearch.EndMonthYear.Substring(4, 2);

                                var startDate = Helper.GetDateFromMonthYear(startMonthYear);
                                var lastForecastDate = Helper.GetDateFromMonthYear(endMonthYear);
                                foreach (var item in Helper.PrepareMonthListYYYYMM(startDate.Value, lastForecastDate.Value))
                                {
                                    summaryResult.MonthList.Add(new MonthList()
                                    {
                                        Month = item,
                                        type = "MonthlyLY"
                                    }
                                   );
                                }
                            }
                            else
                            {
                                var startDate = Helper.GetDateFromMonthYear(psiYear - 1 + "04");
                                var endDate = Helper.GetDateFromMonthYear(psiYear + "03");
                                foreach (var item in Helper.PrepareMonthListYYYYMM(startDate.Value, endDate.Value))
                                {
                                    summaryResult.MonthList.Add(new MonthList()
                                    {
                                        Month = item,
                                        type = "MonthlyLY"
                                    }
                                   );
                                }
                            }
                        }
                        if (request.ConsolidatedReportSearch.AdditionalValue.Contains("LM"))
                        {
                            columnType = "LM";
                            if (request.ConsolidatedReportSearch.StartMonthYear != "undefined")
                            {
                                var startDate = Helper.GetDateFromMonthYear(request.ConsolidatedReportSearch.StartMonthYear);
                                var endDate = Helper.GetDateFromMonthYear(request.ConsolidatedReportSearch.EndMonthYear);
                                foreach (var item in Helper.PrepareMonthListYYYYMM(startDate.Value, endDate.Value))
                                {
                                    summaryResult.MonthList.Add(new MonthList()
                                    {
                                        Month = item,
                                        type = "MonthlyLM"
                                    }
                                   );
                                };
                               
                            }
                            else
                            {
                                summaryResult.MonthList.Add(new MonthList()
                                {
                                    Month = resultMonthYear,
                                    type = "MonthlyLM"
                                }
                             );
                            }
                        }

                    }
                    else if (request.ConsolidatedReportSearch.SalesSubType == "BP")
                    {
                        if (request.ConsolidatedReportSearch.AdditionalValue.Contains("BP"))
                        {
                            columnType = "BP";
                            if (request.ConsolidatedReportSearch.StartMonthYear != "undefined")
                            {
                                var startMonthYear = (Convert.ToInt32(request.ConsolidatedReportSearch.StartMonthYear.Substring(0, 4)) - 1) + request.ConsolidatedReportSearch.StartMonthYear.Substring(4, 2);
                                var endMonthYear = (Convert.ToInt32(request.ConsolidatedReportSearch.EndMonthYear.Substring(0, 4)) - 1) + request.ConsolidatedReportSearch.EndMonthYear.Substring(4, 2);

                                var startDate = Helper.GetDateFromMonthYear(startMonthYear);
                                var lastForecastDate = Helper.GetDateFromMonthYear(endMonthYear);
                                foreach (var item in Helper.PrepareMonthListYYYYMM(startDate.Value, lastForecastDate.Value))
                                {
                                    summaryResult.MonthList.Add(new MonthList()
                                    {
                                        Month = item,
                                        type = "BPBP"
                                    }
                                   );
                                }
                            }
                            else
                            {
                                var startDate = Helper.GetDateFromMonthYear(bpYear - 1 + "04");
                                var endDate = Helper.GetDateFromMonthYear(bpYear + "03");
                                foreach (var item in Helper.PrepareMonthListYYYYMM(startDate.Value, endDate.Value))
                                {
                                    summaryResult.MonthList.Add(new MonthList()
                                    {
                                        Month = item,
                                        type = "BPBP"
                                    }
                                   );
                                }
                            }
                        }
                        if (request.ConsolidatedReportSearch.AdditionalValue.Contains("LY"))
                        {
                            columnType = "LY";
                            if (request.ConsolidatedReportSearch.StartMonthYear != "undefined")
                            {
                                var startMonthYear = (Convert.ToInt32(request.ConsolidatedReportSearch.StartMonthYear.Substring(0, 4)) - 1) + request.ConsolidatedReportSearch.StartMonthYear.Substring(4, 2);
                                var endMonthYear = (Convert.ToInt32(request.ConsolidatedReportSearch.EndMonthYear.Substring(0, 4)) - 1) + request.ConsolidatedReportSearch.EndMonthYear.Substring(4, 2);

                                var startDate = Helper.GetDateFromMonthYear(startMonthYear);
                                var lastForecastDate = Helper.GetDateFromMonthYear(endMonthYear);
                                foreach (var item in Helper.PrepareMonthListYYYYMM(startDate.Value, lastForecastDate.Value))
                                { 
                                    summaryResult.MonthList.Add(new MonthList()
                                    {
                                        Month = item,
                                        type = "BPLY"
                                    }
                                   );
                                }
                            }
                            else
                            {
                                var startDate = Helper.GetDateFromMonthYear(bpYear - 1 + "04");
                                var endDate = Helper.GetDateFromMonthYear(bpYear + "03");
                                foreach (var item in Helper.PrepareMonthListYYYYMM(startDate.Value, endDate.Value))
                                {
                                    summaryResult.MonthList.Add(new MonthList()
                                    {
                                        Month = item,
                                        type = "BPLY"
                                    }
                                   );
                                }
                            }
                        }
                        if (request.ConsolidatedReportSearch.AdditionalValue.Contains("LM"))
                        {
                            columnType = "LM";
                            if (request.ConsolidatedReportSearch.StartMonthYear != "undefined")
                            {
                                var startDate = Helper.GetDateFromMonthYear(request.ConsolidatedReportSearch.StartMonthYear);
                                var lastForecastDate = Helper.GetDateFromMonthYear(request.ConsolidatedReportSearch.EndMonthYear);
                                foreach (var item in Helper.PrepareMonthListYYYYMM(startDate.Value, lastForecastDate.Value))
                                {
                                    summaryResult.MonthList.Add(new MonthList()
                                    {
                                        Month = item,
                                        type = "BPLM"
                                    }
                                   );
                                }

                            }
                            else
                            {
                                summaryResult.MonthList.Add(new MonthList()
                                {
                                    Month = resultMonthYear,
                                    type = "BPLM"
                                });
                            }
                        }
                    }
                }
                var data = GetConsolidatedData(request.ConsolidatedReportSearch, columnType, summaryResult.MonthList);
                List<string> customers = request.ConsolidatedReportSearch.CustomerCode.ToList();
                data = data.Where(x => customers.Contains(x.CustomerCode) ).ToList();
                summaryResult.ConsolidatedData = data;
               
                List<DataFieldList> dataField = new List<DataFieldList>();

                foreach (var type in summaryResult.MonthList.Select(x => x.type).Distinct())
                {
                    if (type == "CM" || type == "BP")
                    {
                        var res = _context.ReportAdditionalColumn.Where(x => x.ReportType == "Consolidate" && x.ColumnType == "CM").OrderBy(x => x.OrderColumn).AsNoTracking().ToList();
                        foreach (var item in res)
                        {
                            dataField.Add(new DataFieldList()
                            {
                                caption = item.DisplayName,
                                dataField = item.ColumnName,
                                dataType = "number",
                                width = 50,
                                summaryType = (item.ColumnName == "gp_Percentage" ? "custom" : "sum"),
                                area = "data",


                            });
                        }

                    }
                    if (type == "MonthlyBP" || type == "BPBP")
                    {
                        var res = _context.ReportAdditionalColumn.Where(x => x.ReportType == "Consolidate" && x.ColumnType == "BP").OrderBy(x => x.OrderColumn).AsNoTracking().ToList();
                        foreach (var item in res)
                        {
                            dataField.Add(new DataFieldList()
                            {
                                caption = item.DisplayName,
                                dataField = item.ColumnName,
                                dataType = "number",
                                width = 50,
                                summaryType = (item.ColumnName == "bpGp_Percentage" ? "custom" : "sum"),
                                area = "data",


                            });
                        }
                    }
                    else if (type == "BPLM" || type == "MonthlyLM")
                    {
                        var res = _context.ReportAdditionalColumn.Where(x => x.ReportType == "Consolidate" && x.ColumnType == "LM").OrderBy(x => x.OrderColumn).AsNoTracking().ToList();
                        foreach (var item in res)
                        {
                            dataField.Add(new DataFieldList()
                            {
                                caption = item.DisplayName,
                                dataField = item.ColumnName,
                                dataType = "number",
                                width = 50,
                                summaryType = (item.ColumnName == "lmGp_Percentage" ? "custom" : "sum"),
                                area = "data",


                            });
                        }
                    }
                    else if (type == "BPLY" || type == "MonthlyLY")
                    {
                        var res = _context.ReportAdditionalColumn.Where(x => x.ReportType == "Consolidate" && x.ColumnType == "LY").OrderBy(x => x.OrderColumn).AsNoTracking().ToList();
                        foreach (var item in res)
                        {
                            dataField.Add(new DataFieldList()
                            {
                                caption = item.DisplayName,
                                dataField = item.ColumnName,
                                dataType = "number",
                                width = 50,
                                summaryType = (item.ColumnName == "lyGp_Percentage" ? "custom" : "sum"),
                                area = "data",


                            });
                        }
                    }

                }
                if (request.ConsolidatedReportSearch.Variant != null)
                {
                    var variants = await _context.ReportVariant.Where(x => x.UserId == request.SessionData.ADUserId && x.ReportType == Contants.ConsoliReport && x.VariantName == request.ConsolidatedReportSearch.Variant).Select(x => x.ColumnName).AsNoTracking().ToListAsync();
                    if (variants.Count > 0)
                    {
                       var result= dataField.Where(x => !variants.Contains(x.dataField)).ToList();
                        foreach(var item in result)
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
                    area = "row",
                    expanded = false,
                });
                summaryResult.DataFieldList.Add(new DataFieldList()
                {
                    dataField = "materialCode",
                    caption = "Material",
                    width = 80,
                    area = "row",
                    expanded = false,
                });

                summaryResult.DataFieldList.Add(new DataFieldList()
                {
                    dataField = "monthYear",
                    caption = "Month Year",
                    width = 120,
                    area = "column"
                });
                return Result.SuccessWith<ConsolidatedSummary>(summaryResult);
            }
            catch (Exception ex)
            {

                Log.Error($"Error in Consolidated Report with Message - {ex.Message}. StackTrace - {ex.StackTrace}");
                return Result.Failure(Contants.ERROR_MSG);
            }
        }

        private List<sp_ConsolidateReport> GetConsolidatedData(ConsolidatedReportSearch consolidatedReportSearch, string columnType, List<MonthList> monthYearList)
        {
            try
            {
                var dtMonthYearList = new DataTable();
                dtMonthYearList.Columns.Add(new DataColumn("MONTHYEAR", typeof(string)));
                dtMonthYearList.Columns.Add(new DataColumn("TYPE", typeof(string)));
                foreach (var row in monthYearList)
                {
                    dtMonthYearList.Rows.Add(row.Month, row.type);
                }
                var tvpMonthYearList = new SqlParameter("tvpMonthYearList", SqlDbType.Structured);
                tvpMonthYearList.Value = dtMonthYearList;
                tvpMonthYearList.TypeName = "dbo.TVP_MONTHYEAR_TYPE";

                var dtCustomerCodeList = new DataTable();
                dtCustomerCodeList.Columns.Add(new DataColumn("Code", typeof(string)));
                foreach (var customerCode in consolidatedReportSearch.CustomerCode)
                {
                    dtCustomerCodeList.Rows.Add(customerCode);
                }
                var tvpCustomerCodeList = new SqlParameter("@tvpCustomerCodeList", SqlDbType.Structured);
                tvpCustomerCodeList.Value = dtCustomerCodeList;
                tvpCustomerCodeList.TypeName = "dbo.TVP_CUSTOMERCODE_LIST";

                var paramMG = new SqlParameter("@MG", SqlDbType.NVarChar, 100);
                paramMG.Value = consolidatedReportSearch.ProductCategoryId1;

                var paramMG1 = new SqlParameter("@MG1", SqlDbType.NVarChar, 100);
                paramMG1.Value = consolidatedReportSearch.ProductCategoryId2;

                var paramSaleType = new SqlParameter("@SalesSubType", SqlDbType.NVarChar, 100);
                paramSaleType.Value = consolidatedReportSearch.SalesSubType;


                var paramColumnType = new SqlParameter("@ColumnType", SqlDbType.NVarChar, 100);
                paramColumnType.Value = columnType;

                var param = new SqlParameter[] {
                    tvpCustomerCodeList,
                    paramMG,
                    paramMG1,
                    paramSaleType,
                    paramColumnType,
                    tvpMonthYearList
                };
                var result = _context.sp_ConsolidateReport.FromSqlRaw("dbo.SP_CONSOLIDATEREPORT  @tvpCustomerCodeList,@MG,@MG1,@SalesSubType,@ColumnType,@tvpMonthYearList", param).AsNoTracking().ToList();
                if (result != null && result.Count() > 0)
                {
                    //to fill 0 for qty for materials which does not has data for corresponding months.
                    //if this is not done then Nan will displayed in report for materials which does not has data for corresponding month

                    var groupedResult = result.GroupBy(r => new { r.CustomerCode , r.MaterialCode});
                    var distinctMonthCount = new List<string>();
                    if(monthYearList.Any( m => m.type.ToLower().ToLower() == "cm")){
                        distinctMonthCount = monthYearList.Where(m => m.type.ToLower() == "cm").Select(m => m.Month).Distinct().ToList();
                    }
                    else if (monthYearList.Any(m => m.type.ToLower().ToLower() == "bp"))
                    {
                        distinctMonthCount = monthYearList.Where(m => m.type.ToLower() == "bp").Select(m => m.Month).Distinct().ToList();
                    }

                    foreach (var group in groupedResult)
                    {
                        var firstItem = group.First();
                        if (group.Count() < distinctMonthCount.Count())
                        {
                            var missedMonths = distinctMonthCount.Except(group.Select(g => g.MonthYear.ToString()).ToList());
                            foreach (var missedMonth in missedMonths)
                            {
                                result.Add(new sp_ConsolidateReport
                                {
                                    Department = firstItem.Department,
                                    CustomerCode = firstItem.CustomerCode,
                                    Country = firstItem.Country,
                                    SalesOffice = firstItem.SalesOffice,
                                    SalesType = firstItem.SalesType,
                                    Consignee = firstItem.Consignee,
                                    Group_Desc = firstItem.Group_Desc,
                                    SubGroup = firstItem.SubGroup,
                                    Type = firstItem.Type,
                                    MaterialCode = firstItem.MaterialCode,
                                    MonthYear = Convert.ToInt32(missedMonth)
                                });
                            }
                        }
                    }
                    return result;
                }
                return new List<sp_ConsolidateReport>();
            }
            catch (Exception ex)
            {
                throw;
            }
        }
    }
}
