using System.Data;
using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Graph;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Constants;
using PSI.Modules.Backends.Helpers;
using PSI.Modules.Backends.Masters.Repository.CustomerMaster;
using PSI.Modules.Backends.Masters.Repository.GlobalConfigMaster;
using PSI.Modules.Backends.Masters.Repository.MaterialMaster;
using PSI.Modules.Backends.SNS.Command;
using PSI.Modules.Backends.SNS.Repository;
using PSI.Modules.Backends.SNS.Results;

namespace PSI.Modules.Backends.SNS.CommandHandler
{
    public class SNSPlanningHandler : IRequestHandler<SNSPlanningCommand, Result>
    {
        private readonly ITRNPricePlanningRepository _trnPricePlanningRepository;
        private readonly IMaterialViewReopsitory _materialViewReopsitory;
        private readonly IMaterialRepository _materialReopsitory;
        private readonly ISNSEntryWithQtyPriceViewRepository _snsEntryWithQtyPriceViewRepository;
        private readonly ICustomerRepository _customerRepository;
        private readonly PSIDbContext _context;
        private readonly IGlobalConfigRepository _globalConfig;
        public SNSPlanningHandler(ITRNPricePlanningRepository trnPricePlanningRepository,
        IMaterialViewReopsitory materialViewReopsitory,
        ISNSEntryWithQtyPriceViewRepository snsEntryWithQtyPriceViewRepository,
        ICustomerRepository customerRepository,
        IMaterialRepository materialReopsitory,
        IGlobalConfigRepository globalConfig)
        {
            _trnPricePlanningRepository = trnPricePlanningRepository;
            _materialViewReopsitory = materialViewReopsitory;
            _snsEntryWithQtyPriceViewRepository = snsEntryWithQtyPriceViewRepository;
            _customerRepository = customerRepository;
            _materialReopsitory = materialReopsitory;
            _context = new PSIDbContext();
            _globalConfig = globalConfig;
        }

        public async Task<Result> Handle(SNSPlanningCommand request, CancellationToken cancellationToken)
        {
            try
            {
                var summaryResult = new SNSPlanningSummary
                {
                    MonthList = new List<string>(),
                    PlanningData = new List<SNSPlanningDetail>(),
                };
                var globalconfig = _globalConfig.GetAll();
                var resultMonthYear = Convert.ToInt32(globalconfig.Where(x => x.ConfigKey == "Result_Month").Select(x => x.ConfigValue).FirstOrDefault());
                var currentMonthYear = Convert.ToInt32(globalconfig.Where(x => x.ConfigKey == "Current_Month").Select(x => x.ConfigValue).FirstOrDefault());
                var lockMonthYear = Convert.ToInt32(globalconfig.Where(x => x.ConfigKey == "Lock_Month").Select(x => x.ConfigValue).FirstOrDefault());
                var forecasteMonthYearDate = (DateTime)(Helper.GetDateFromMonthYear(resultMonthYear.ToString()));
                var forecasteMonthYear = Convert.ToInt32(Helper.GetMonthYearFromDate(forecasteMonthYearDate.AddMonths(+7))); 
                var resultMonthStartDate = Helper.GetDateFromMonthYear(resultMonthYear.ToString());
                var lastForecastMonthyear = Helper.GetLastForecastMonthYear(request.SNSPlanning.PeriodId, (DateTime)resultMonthStartDate);

                request.SNSPlanning.StartMonthYear = resultMonthYear;
                request.SNSPlanning.EndMonthYear = lastForecastMonthyear;

                var lastForecastDate = Helper.GetDateFromMonthYear(lastForecastMonthyear.ToString());

                if (resultMonthStartDate.HasValue && lastForecastDate.HasValue)
                {
                    summaryResult.MonthList = Helper.PrepareMonthList(resultMonthStartDate.Value, lastForecastDate.Value);
                }
                else
                {
                    return Result.Failure("Invalid date");
                }
                var customerList = _customerRepository.GetCustomersByIds(request.SNSPlanning.CustomerIdList);
                if (customerList.Count() == 0)
                {
                    return Result.Failure("No Customers");
                }

                // load materials If IsWildCardSearch
                if (request.SNSPlanning.IsWildCardSearch)
                {
                    string mg2 = string.Join(", ", request.SNSPlanning.ProductCategoryId);
                    string? mg3 = null;
                    if (request.SNSPlanning.ProductSubCategoryIdList.Count() > 0)
                    {
                        mg3 = string.Join(", ", request.SNSPlanning.ProductSubCategoryIdList);
                    }
                    var materialList=_context.SP_MATERIALSEARCH.FromSql($"SP_MATERIALSEARCH {mg2},{mg3},{request.SNSPlanning.SearchedMaterialCode}").AsNoTracking().ToList();
                    if (materialList.Count() == 0)
                    {
                        return Result.Failure("No Materials found on the search");
                    }
                    else
                    {
                        request.SNSPlanning.MaterialCodeList = materialList.Select(c => c.MaterialCode).ToList();
                       // request.SNSPlanning.MaterialIdList = materialList.Select(c => c.MaterialId).ToList();
                    }
                }

                var snsSummaryResult = GetTRNPricePlannings(request.SNSPlanning);

                //var snsEntryResult = _snsEntryWithQtyPriceViewRepository.GetSNSEntryQtyPriceForPlanningQuery(request.SNSPlanning);
                var snsEntryResult = GetCustomerWiseSaleQtyPrices(request.SNSPlanning, currentMonthYear, lockMonthYear, resultMonthYear, forecasteMonthYear);
                var customers = _customerRepository.GetCustomersByCustomerCode(snsEntryResult.Select(x => x.CustomerCode).ToList());

                var summaryByMaterial = snsSummaryResult.GroupBy(c => c.MaterialCode);

                var selectedMaterial = _materialViewReopsitory.GetMaterialByCodes(summaryByMaterial.Select(x => x.Key).ToArray());
                foreach (var materials in summaryByMaterial)
                {
                    var materialInfo = selectedMaterial.FirstOrDefault(x=>x.MaterialCode== materials.Key);
                    if (materialInfo != null)
                    {
                        var snsEntryCustomerWiseMaterialQtyList = snsEntryResult.Where(c => c.MaterialCode == materials.Key).OrderBy(c => c.CustomerCode).ToList();

                        // Load summary data
                        PrepareSummaryPlanningData(materials.Key, resultMonthYear.ToString(), lastForecastDate.Value, materials.ToList(), summaryResult, materialInfo, request.SNSPlanning.AccountCode, request.SNSPlanning.IsStockDays);

                        // Add Customer Title
                        var detailData = new SNSPlanningDetail()
                        {
                            Description = "CUSTOMERS",
                            DisableEditQuantity = true,
                            MaterialId = materialInfo.MaterialId,
                            MaterialCode = materialInfo.MaterialCode,
                            MaterialAndSubGroupDesc = $"{materialInfo.MaterialCode} & {materialInfo.ProductCategoryCode2} {materialInfo.ProductCategoryName2}",
                            SubGroup = $"{materialInfo.ProductCategoryCode2} {materialInfo.ProductCategoryName2}",
                        };
                        summaryResult.PlanningData.Add(detailData);

                        //Load customer data
                        PrepareCustomerDataForMaterial(materials.Key, snsEntryCustomerWiseMaterialQtyList, summaryResult, materialInfo, resultMonthYear.ToString(), lastForecastDate.Value, customers.ToList());
                    }
                }

                return Result.SuccessWith(summaryResult);
            }
            catch (Exception ex)
            {
                Log.Error($"Error in sns planning with Message - {ex.Message}. StackTrace - {ex.StackTrace}");
                return Result.Failure(Contants.ERROR_MSG);
            }
        }

        private void PrepareSummaryPlanningData(string materialCode, string resultMonthYear, DateTime lastForecastDate, 
            List<SP_TRNPricePlanningSearch> materials, 
            SNSPlanningSummary summaryResult, 
            MaterialView materialInfo, string accountCode,bool isStockDays)
        {
            var snsPlanningModes = Contants.sns_planning_desc_modes.Split(",");
            if (!isStockDays)
            {
                snsPlanningModes = snsPlanningModes.Where(mode => mode.Trim() != "Stock Days").ToArray();
            }
            foreach (var modeCode in snsPlanningModes)
            {
                
                    var detailData = new SNSPlanningDetail()
                    {
                        MaterialCode = materialInfo.MaterialCode,
                        MaterialAndSubGroupDesc = $"{materialInfo.MaterialCode} & {materialInfo.ProductCategoryCode2} {materialInfo.ProductCategoryName2}",
                        Description = modeCode,
                        MaterialId = materialInfo.MaterialId,
                        SubGroup = $"{materialInfo.ProductCategoryCode2} {materialInfo.ProductCategoryName2}",
                        Type = modeCode == "PURCHASE" || modeCode == "SALES" ? "S&S" : modeCode == "MPO" ? "MPO" : null,
                        AccountCode = accountCode,
                        ModeofType = modeCode,
                        SNSSummaryIdList = new List<int?>(),
                        SNSEntryIdList = new List<int?>(),
                        SNSEntryQtyPriceIdList = new List<int?>(),
                    };
                    if (modeCode == "GIT Arrivals" || modeCode == "INVENTORY" || modeCode == "SALES")
                    {
                        detailData.DisableEditQuantity = true;
                    }
                    var summaryData = materials.Where(c => c.ModeofType == modeCode);
                    var summayStartDate = Helper.GetDateFromMonthYear(resultMonthYear);
                    int index = 0;
                    while (summayStartDate <= lastForecastDate)
                    {

                        var summaryMonthData = summaryData.FirstOrDefault(c => c.MonthYear == Convert.ToInt32(Helper.GetMonthYearFromDate(summayStartDate.Value)));
                        if (summaryMonthData != null)
                        {
                            SetSummaryPlanningCountData(detailData, index, summaryMonthData, 0);
                        }
                        else
                        {
                            SetSummaryPlanningCountData(detailData, index, null, 0);
                        }

                        index++;
                        summayStartDate = summayStartDate.Value.AddMonths(1);
                    }
                    summaryResult.PlanningData.Add(detailData);
                
            }
        }

        private void SetSummaryPlanningCountData(SNSPlanningDetail detailData, int index, SP_TRNPricePlanningSearch snsSummary, int? quantity)
        {
            if (snsSummary != null)
            {
                quantity = snsSummary.Quantity != null ? snsSummary.Quantity.Value : null;
            }
            quantity = quantity == 0 ? null : quantity;
            switch (index)
            {
                case 0:
                    detailData.Month0Quantity = quantity;
                    break;
                case 1:
                    detailData.Month1Quantity = quantity;
                    break;
                case 2:
                    detailData.Month2Quantity = quantity;
                    break;
                case 3:
                    detailData.Month3Quantity = quantity;
                    break;
                case 4:
                    detailData.Month4Quantity = quantity;
                    break;
                case 5:
                    detailData.Month5Quantity = quantity;
                    break;
                case 6:
                    detailData.Month6Quantity = quantity;
                    break;
                case 7:
                    detailData.Month7Quantity = quantity;
                    break;
                case 8:
                    detailData.Month8Quantity = quantity;
                    break;
                case 9:
                    detailData.Month9Quantity = quantity;
                    break;
                case 10:
                    detailData.Month10Quantity = quantity;
                    break;
                case 11:
                    detailData.Month11Quantity = quantity;
                    break;
                case 12:
                    detailData.Month12Quantity = quantity;
                    break;
            }
            detailData.SNSSummaryIdList.Add(snsSummary?.TRNPricePlanningId);
        }

        private void SetCustomerPlanningCountData(SNSPlanningDetail detailData, int index, SP_Get_CustomerWiseSaleQtyPrice customerDataFortheMonth, int? snsEntryId)
        {
            int? quantity = null;
            if (customerDataFortheMonth != null)
            {
                quantity = customerDataFortheMonth.Quantity != null ? customerDataFortheMonth.Quantity.Value : null;
            }
            quantity = quantity == 0 ? null : quantity;
            switch (index)
            {
                case 0:
                    detailData.Month0Quantity = quantity;
                    break;
                case 1:
                    detailData.Month1Quantity = quantity;
                    break;
                case 2:
                    detailData.Month2Quantity = quantity;
                    break;
                case 3:
                    detailData.Month3Quantity = quantity;
                    break;
                case 4:
                    detailData.Month4Quantity = quantity;
                    break;
                case 5:
                    detailData.Month5Quantity = quantity;
                    break;
                case 6:
                    detailData.Month6Quantity = quantity;
                    break;
                case 7:
                    detailData.Month7Quantity = quantity;
                    break;
                case 8:
                    detailData.Month8Quantity = quantity;
                    break;
                case 9:
                    detailData.Month9Quantity = quantity;
                    break;
                case 10:
                    detailData.Month10Quantity = quantity;
                    break;
                case 11:
                    detailData.Month11Quantity = quantity;
                    break;
                case 12:
                    detailData.Month12Quantity = quantity;
                    break;
            }
            detailData.SNSEntryIdList.Add(snsEntryId);
            detailData.SNSEntryQtyPriceIdList.Add(customerDataFortheMonth?.SNSEntryQtyPriceId);
        }

        private void PrepareCustomerDataForMaterial(string materialCode, List<SP_Get_CustomerWiseSaleQtyPrice> snsEntryCustomerWiseMaterialQtyList, SNSPlanningSummary summaryResult, MaterialView materialInfo, string resultMonthYear, DateTime lastForecastDate, List<Customer> customerList)
        {
            foreach (var customer in customerList)
            {
                var customerWiseMaterialList = snsEntryCustomerWiseMaterialQtyList.Where(c => c.CustomerCode == customer.CustomerCode);
                if (customerWiseMaterialList.Any())
                {
                    var detailData = new SNSPlanningDetail()
                    {
                        MaterialCode = materialInfo.MaterialCode,
                        MaterialAndSubGroupDesc = $"{materialInfo.MaterialCode} & {materialInfo.ProductCategoryCode2} {materialInfo.ProductCategoryName2}",
                        Description = customer.CustomerCode,
                        MaterialId = materialInfo.MaterialId,
                        SubGroup = $"{materialInfo.ProductCategoryCode2} {materialInfo.ProductCategoryName2}",
                        Type = "S&S",
                        CustomerId = customer.CustomerId,
                        CustomerCode = customer.CustomerCode,
                        CustomerName = customer.CustomerName,
                        SNSSummaryIdList = new List<int?>(),
                        SNSEntryIdList = new List<int?>(),
                        SNSEntryQtyPriceIdList = new List<int?>()
                    };
                    var customerSNSEntryInfo = customerWiseMaterialList.FirstOrDefault();
                    var summayStartDate = Helper.GetDateFromMonthYear(resultMonthYear);
                    int index = 0;
                    while (summayStartDate <= lastForecastDate)
                    {
                        var customerDataFortheMonth = customerWiseMaterialList.FirstOrDefault(c => c.MonthYear == Convert.ToInt32(Helper.GetMonthYearFromDate(summayStartDate.Value)));
                        if (customerDataFortheMonth != null)
                        {
                            SetCustomerPlanningCountData(detailData, index, customerDataFortheMonth, customerDataFortheMonth.SNSEntryId);
                        }
                        else
                        {
                            SetCustomerPlanningCountData(detailData, index, null, null);
                        }
                        index++;
                        summayStartDate = summayStartDate.Value.AddMonths(1);
                    }
                    summaryResult.PlanningData.Add(detailData);
                }
                /*else
                {
                    var summayStartDate = Helper.GetDateFromMonthYear(resultMonthYear);
                    int index = 0;
                    while(summayStartDate <= lastForecastDate)
                    {
                        SetCustomerPlanningCountData(detailData, index, null, null);
                        index++;
                        summayStartDate = summayStartDate.Value.AddMonths(1);
                    }
                }*/
                //summaryResult.PlanningData.Add(detailData);
            }

        }

        private List<SP_TRNPricePlanningSearch> GetTRNPricePlannings(SNSPlanning snsPlanning)
        {
            try
            {
                var paramAccountCode = new SqlParameter("@accountCode", SqlDbType.NVarChar, 100);
                paramAccountCode.Value = snsPlanning.AccountCode;

                var paramStartMonth = new SqlParameter("@StartMonthYear", SqlDbType.Int);
                paramStartMonth.Value = snsPlanning.StartMonthYear;

                var paramEndMonth = new SqlParameter("@EndMonthYear", SqlDbType.Int);
                paramEndMonth.Value = snsPlanning.EndMonthYear;

                var dtMaterialCodeList = new DataTable();
                dtMaterialCodeList.Columns.Add(new DataColumn("Code", typeof(string)));
                foreach (var materialCode in snsPlanning.MaterialCodeList)
                {
                    dtMaterialCodeList.Rows.Add(materialCode);
                }
                var tvpMaterialCodeList = new SqlParameter("@tvpMaterialCodeList", SqlDbType.Structured);
                tvpMaterialCodeList.Value = dtMaterialCodeList;
                tvpMaterialCodeList.TypeName = "dbo.TVP_CODE_LIST";

                var param = new SqlParameter[] {
                    paramAccountCode,
                    paramStartMonth,
                    paramEndMonth,
                    tvpMaterialCodeList
                };
                var result = _context.SP_TRNPricePlanningSearch.FromSqlRaw("dbo.SP_TRNPricePlanningSearch @accountCode,@StartMonthYear,@EndMonthYear, @tvpMaterialCodeList", param).AsNoTracking().ToList();
                if (result != null && result.Count() > 0)
                {
                    return result;
                }
                return new List<SP_TRNPricePlanningSearch>();
            }
            catch (Exception)
            {
                throw;
            }
        }
        /// <summary>
        /// Get Customer Wise Sale Qty Prices
        /// </summary>
        /// <param name="customerId"></param>
        /// <returns></returns>
        private List<SP_Get_CustomerWiseSaleQtyPrice> GetCustomerWiseSaleQtyPrices(SNSPlanning snsPlanning, int currentMonth, int lockMonth, int resultMonth, int lastForecastMonth)
        {
            try
            {
                var paramAccountCode = new SqlParameter("@accountCode", SqlDbType.NVarChar, 100);
                paramAccountCode.Value = snsPlanning.AccountCode;

                var paramCurrentMonth = new SqlParameter("@currentMonth", SqlDbType.Int);
                paramCurrentMonth.Value = currentMonth;

                var paramlockMonth = new SqlParameter("@lockMonth", SqlDbType.Int);
                paramlockMonth.Value = lockMonth;

                var paramResultMonth = new SqlParameter("@resultMonth", SqlDbType.Int);
                paramResultMonth.Value = resultMonth;

                var paramlastForecastMonth = new SqlParameter("@lastForecastMonth", SqlDbType.Int);
                paramlastForecastMonth.Value = lastForecastMonth;

                var dtCustomerCodeList = new DataTable();
                dtCustomerCodeList.Columns.Add(new DataColumn("Code", typeof(string)));
                foreach (var customerCode in snsPlanning.CustomerCodeList)
                {
                    dtCustomerCodeList.Rows.Add(customerCode);
                }
                var tvpCustomerCodeList = new SqlParameter("@tvpCustomerCodeList", SqlDbType.Structured);
                tvpCustomerCodeList.Value = dtCustomerCodeList;
                tvpCustomerCodeList.TypeName = "dbo.TVP_CODE_LIST";

                var dtMaterialCodeList = new DataTable();
                dtMaterialCodeList.Columns.Add(new DataColumn("Code", typeof(string)));
                foreach (var materialCode in snsPlanning.MaterialCodeList)
                {
                    dtMaterialCodeList.Rows.Add(materialCode);
                }
                var tvpMaterialCodeList = new SqlParameter("@tvpMaterialCodeList", SqlDbType.Structured);
                tvpMaterialCodeList.Value = dtMaterialCodeList;
                tvpMaterialCodeList.TypeName = "dbo.TVP_CODE_LIST";

                var param = new SqlParameter[] {
                    paramAccountCode,
                    paramCurrentMonth,
                    paramlockMonth,
                    paramResultMonth,
                    paramlastForecastMonth,
                    tvpCustomerCodeList,
                    tvpMaterialCodeList
                };
                var result = _context.SP_Get_CustomerWiseSaleQtyPrice.FromSqlRaw("dbo.SP_Get_CustomerWiseSaleQtyPrice @accountCode,@currentMonth,@lockMonth,@resultMonth,@lastForecastMonth, @tvpCustomerCodeList, @tvpMaterialCodeList", param).AsNoTracking().ToList();
                if (result != null && result.Count() > 0)
                {
                    return result;
                }
                return new List<SP_Get_CustomerWiseSaleQtyPrice>();
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}