using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using NPOI.SS.Formula.Functions;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Constants;
using PSI.Modules.Backends.Helpers;
using PSI.Modules.Backends.Masters.Repository.GlobalConfigMaster;
using PSI.Modules.Backends.Report.Queries;
using PSI.Modules.Backends.Transmission.Results;
using SixLabors.ImageSharp.ColorSpaces;
using System.Data;
using Log = Core.BaseUtility.Utility.Log;

namespace PSI.Modules.Backends.Report.QueriesHandler
{
    public class NonConsolidatedReportHandler : IRequestHandler<NonConsolidatedReportSearchQuery, Result>
    {
        private readonly PSIDbContext _context;
        private readonly IGlobalConfigRepository _globalConfig;
        public NonConsolidatedReportHandler(IGlobalConfigRepository globalConfig)
        {
            _context = new PSIDbContext();
            _globalConfig = globalConfig;
        }

        public async Task<Result> Handle(NonConsolidatedReportSearchQuery request, CancellationToken cancellationToken)
        {
            try
            {
                var summaryResult = new NonConsolidatedSummary
                {
                    MonthList = new List<MonthList>(),
                    NonConsolidatedData = new List<sp_NonConsolidateReport>(),
                    DataFieldList = new List<DataFieldList>()
                };
                string columnType = "";
                var global = _globalConfig.GetAll();
                Int32 psiYear = Convert.ToInt32(global.Where(x => x.ConfigKey == Contants.global_config_psi_year_key).Select(x => x.ConfigValue).FirstOrDefault());
                Int32 bpYear = Convert.ToInt32(global.Where(x => x.ConfigKey == Contants.global_config_BP_year_key).Select(x => x.ConfigValue).FirstOrDefault());
                string resultMonthYear = global.Where(x => x.ConfigKey == Contants.global_config_result_month_key).Select(x => x.ConfigValue).FirstOrDefault();

                if (request.NonConsolidatedReportSearch.SalesSubType == "Monthly")
                {
                    columnType = "CM";
                    if (request.NonConsolidatedReportSearch.StartMonthYear != "undefined")
                    {
                        var startDate = Helper.GetDateFromMonthYear(request.NonConsolidatedReportSearch.StartMonthYear);
                        var lastForecastDate = Helper.GetDateFromMonthYear(request.NonConsolidatedReportSearch.EndMonthYear);
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
                else if (request.NonConsolidatedReportSearch.SalesSubType == "BP")
                {
                    columnType = "BP";
                    if (request.NonConsolidatedReportSearch.StartMonthYear != "undefined")
                    {
                        var startDate = Helper.GetDateFromMonthYear(request.NonConsolidatedReportSearch.StartMonthYear);
                        var lastForecastDate = Helper.GetDateFromMonthYear(request.NonConsolidatedReportSearch.EndMonthYear);
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

                if (request.NonConsolidatedReportSearch.AdditionalValue != null)

                {
                    if (request.NonConsolidatedReportSearch.SalesSubType == "Monthly")
                    {

                        if (request.NonConsolidatedReportSearch.AdditionalValue.Contains("BP"))
                        {
                            columnType = "BP";
                            if (request.NonConsolidatedReportSearch.StartMonthYear != null)
                            {
                                var startDate = Helper.GetDateFromMonthYear(request.NonConsolidatedReportSearch.StartMonthYear);
                                var lastForecastDate = Helper.GetDateFromMonthYear(request.NonConsolidatedReportSearch.EndMonthYear);
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
                        if (request.NonConsolidatedReportSearch.AdditionalValue.Contains("LY"))
                        {
                            columnType = "LY";
                            if (request.NonConsolidatedReportSearch.StartMonthYear != "undefined")
                            {
                                var startMonthYear = (Convert.ToInt32(request.NonConsolidatedReportSearch.StartMonthYear.Substring(0, 4)) - 1) + request.NonConsolidatedReportSearch.StartMonthYear.Substring(4, 2);
                                var endMonthYear = (Convert.ToInt32(request.NonConsolidatedReportSearch.EndMonthYear.Substring(0, 4)) - 1) + request.NonConsolidatedReportSearch.EndMonthYear.Substring(4, 2);

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
                        if (request.NonConsolidatedReportSearch.AdditionalValue.Contains("LM"))
                        {
                            columnType = "LM";
                            if (request.NonConsolidatedReportSearch.StartMonthYear != "undefined")
                            {
                                var startDate = Helper.GetDateFromMonthYear(request.NonConsolidatedReportSearch.StartMonthYear);
                                var endDate = Helper.GetDateFromMonthYear(request.NonConsolidatedReportSearch.EndMonthYear);
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
                        if (request.NonConsolidatedReportSearch.AdditionalValue.Contains("Ageing"))
                        {
                            columnType = "LM";
                            if (request.NonConsolidatedReportSearch.StartMonthYear != "undefined")
                            {
                                var startDate = Helper.GetDateFromMonthYear(request.NonConsolidatedReportSearch.StartMonthYear.ToString());
                                var lastForecastDate = Helper.GetDateFromMonthYear(request.NonConsolidatedReportSearch.EndMonthYear.ToString());
                                foreach (var item in Helper.PrepareMonthListYYYYMM(startDate.Value, lastForecastDate.Value))
                                {
                                    summaryResult.MonthList.Add(new MonthList()
                                    {
                                        Month = item,
                                        type = "MonthlyAgeing"
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
                                        type = "MonthlyAgeing"
                                    }
                                   );
                                }
                            }
                        }

                    }
                    else if (request.NonConsolidatedReportSearch.SalesSubType == "BP")
                    {
                        if (request.NonConsolidatedReportSearch.AdditionalValue.Contains("BP"))
                        {
                            columnType = "BP";
                            if (request.NonConsolidatedReportSearch.StartMonthYear != "undefined")
                            {
                                var startMonthYear = (Convert.ToInt32(request.NonConsolidatedReportSearch.StartMonthYear.Substring(0, 4)) - 1) + request.NonConsolidatedReportSearch.StartMonthYear.Substring(4, 2);
                                var endMonthYear = (Convert.ToInt32(request.NonConsolidatedReportSearch.EndMonthYear.Substring(0, 4)) - 1) + request.NonConsolidatedReportSearch.EndMonthYear.Substring(4, 2);

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
                        if (request.NonConsolidatedReportSearch.AdditionalValue.Contains("LY"))
                        {
                            columnType = "LY";
                            if (request.NonConsolidatedReportSearch.StartMonthYear != "undefined")
                            {
                                var startMonthYear = (Convert.ToInt32(request.NonConsolidatedReportSearch.StartMonthYear.Substring(0, 4)) - 1) + request.NonConsolidatedReportSearch.StartMonthYear.Substring(4, 2);
                                var endMonthYear = (Convert.ToInt32(request.NonConsolidatedReportSearch.EndMonthYear.Substring(0, 4)) - 1) + request.NonConsolidatedReportSearch.EndMonthYear.Substring(4, 2);

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
                        if (request.NonConsolidatedReportSearch.AdditionalValue.Contains("LM"))
                        {
                            columnType = "LM";
                            if (request.NonConsolidatedReportSearch.StartMonthYear != "undefined")
                            {
                                var startDate = Helper.GetDateFromMonthYear(request.NonConsolidatedReportSearch.StartMonthYear);
                                var lastForecastDate = Helper.GetDateFromMonthYear(request.NonConsolidatedReportSearch.EndMonthYear);
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
                        if (request.NonConsolidatedReportSearch.AdditionalValue.Contains("Ageing"))
                        {
                            columnType = "LM";
                            if (request.NonConsolidatedReportSearch.StartMonthYear != "undefined")
                            {
                                var startDate = Helper.GetDateFromMonthYear(request.NonConsolidatedReportSearch.StartMonthYear.ToString());
                                var lastForecastDate = Helper.GetDateFromMonthYear(request.NonConsolidatedReportSearch.EndMonthYear.ToString());
                                foreach (var item in Helper.PrepareMonthListYYYYMM(startDate.Value, lastForecastDate.Value))
                                {
                                    summaryResult.MonthList.Add(new MonthList()
                                    {
                                        Month = item,
                                        type = "BPAgeing"
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
                                        type = "BPAgeing"
                                    }
                                   );
                                }
                            }
                        }
                    }
                }

                var data = GetConsolidatedData(request.NonConsolidatedReportSearch, columnType, summaryResult.MonthList);
                List<string> customers = request.NonConsolidatedReportSearch.CustomerCode.ToList();
                data = data.Where(x => customers.Contains(x.CustomerCode) ).ToList();
                summaryResult.NonConsolidatedData = data;
              
                List<DataFieldList> dataField = new List<DataFieldList>();
                foreach (var type in summaryResult.MonthList.Select(x => x.type).Distinct())
                {
                    if (type == "CM" || type == "BP")
                    {

                        var res = _context.ReportAdditionalColumn.Where(x => x.ReportType == "NonConsolidate" && x.ColumnType == "CM").OrderBy(x => x.OrderColumn).AsNoTracking().ToList();
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

                    }
                    if (type == "MonthlyBP" || type == "BPBP")
                    {
                        var res = _context.ReportAdditionalColumn.Where(x => x.ReportType == "NonConsolidate" && x.ColumnType == "BP").OrderBy(x => x.OrderColumn).AsNoTracking().ToList();
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
                    }
                    else if (type == "BPLM" || type == "MonthlyLM")
                    {
                        var res = _context.ReportAdditionalColumn.Where(x => x.ReportType == "NonConsolidate" && x.ColumnType == "LM").OrderBy(x => x.OrderColumn).AsNoTracking().ToList();
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
                    }
                    else if (type == "BPLY" || type == "MonthlyLY")
                    {
                        var res = _context.ReportAdditionalColumn.Where(x => x.ReportType == "NonConsolidate" && x.ColumnType == "LY").OrderBy(x => x.OrderColumn).AsNoTracking().ToList();
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
                    }
                    else if (type == "MonthlyAgeing" || type == "BPAgeing")
                    {

                        var res = _context.ReportAdditionalColumn.Where(x => x.ReportType == "NonConsolidate" && x.ColumnType == "Ageing").OrderBy(x => x.OrderColumn).AsNoTracking().ToList();
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

                    }
                   
                

                }
                if (request.NonConsolidatedReportSearch.Variant != null)
                {
                    var variants = await _context.ReportVariant.Where(x => x.UserId == request.SessionData.ADUserId && x.ReportType == Contants.NonConsoliReport && x.VariantName == request.NonConsolidatedReportSearch.Variant).Select(x => x.ColumnName).AsNoTracking().ToListAsync();
                    if (variants.Count() > 0)
                    {
                        var result = dataField.Where(x => !variants.Contains(x.dataField)).ToList();
                        foreach (var item in result)
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
                return Result.SuccessWith<NonConsolidatedSummary>(summaryResult);
            }
            catch (Exception ex)
            {

                Log.Error($"Error in Consolidated Report with Message - {ex.Message}. StackTrace - {ex.StackTrace}");
                return Result.Failure(Contants.ERROR_MSG);
            }
        }

        private List<sp_NonConsolidateReport> GetConsolidatedData(NonConsolidatedReportSearch consolidatedReportSearch, string columnType, List<MonthList> monthYearList)
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

                var paramIsUSD = new SqlParameter("@IsUSD", SqlDbType.Bit);
                paramIsUSD.Value = consolidatedReportSearch.IsUSD;

                var param = new SqlParameter[] {
                    tvpCustomerCodeList,
                    paramMG,
                    paramMG1,
                    paramSaleType,
                    paramColumnType,
                    tvpMonthYearList,
                    paramIsUSD
                };

                var result = _context.sp_NonConsolidateReport.FromSqlRaw("dbo.SP_NONCONSOLIDATEREPORT  @tvpCustomerCodeList,@MG,@MG1,@SalesSubType,@ColumnType,@tvpMonthYearList,@IsUSD", param).AsNoTracking().ToList();
                if (result != null && result.Count() > 0)
                {
                    //to fill 0 for qty for materials which does not has data for corresponding months.
                    //if this is not done then Nan will displayed in report for materials which does not has data for corresponding month

                    var groupedResult = result.GroupBy(r => new { r.CustomerCode, r.MaterialCode });
                    var distinctMonthCount = new List<string>();
                    if (monthYearList.Any(m => m.type.ToLower().ToLower() == "cm"))
                    {
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
                                result.Add(new sp_NonConsolidateReport
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
                return new List<sp_NonConsolidateReport>();
            }
            catch (Exception ex)
            {
                throw;
            }
        }
    }
}

