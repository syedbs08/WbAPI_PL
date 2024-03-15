using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.EntityFrameworkCore;
using NPOI.SS.Formula.Functions;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Constants;
using PSI.Modules.Backends.Helpers;
using PSI.Modules.Backends.Masters.Repository.GlobalConfigMaster;
using PSI.Modules.Backends.Masters.Repository.MaterialMaster;
using PSI.Modules.Backends.SNS.Command;
using PSI.Modules.Backends.SNS.Repository;
using PSI.Modules.Backends.SNS.Results;
using Log = Core.BaseUtility.Utility.Log;

namespace PSI.Modules.Backends.SNS.CommandHandler
{
    public class UpdateSNSPlanningHandler : IRequestHandler<UpdateSNSPlanningCommand, Result>
    {
        private readonly ITRNPricePlanningRepository _trnPricePlanningRepository;
        private readonly IMaterialViewReopsitory _materialViewReopsitory;
        private readonly IGlobalConfigRepository _globalConfig;
        private readonly ITRNSalesPlanningRepository _trnSalesPlanningRepository;
        private readonly PSIDbContext _context;
        public UpdateSNSPlanningHandler(ITRNPricePlanningRepository trnPricePlanningRepository,
        IMaterialViewReopsitory materialViewReopsitory,
        IGlobalConfigRepository globalConfigRepository,
        ITRNSalesPlanningRepository trnSalesPlanningRepository
        )
        {
            _trnPricePlanningRepository = trnPricePlanningRepository;
            _materialViewReopsitory = materialViewReopsitory;
            _globalConfig = globalConfigRepository;
            _trnSalesPlanningRepository = trnSalesPlanningRepository;
            _context = new PSIDbContext();
        }

        public async Task<Result> Handle(UpdateSNSPlanningCommand request, CancellationToken cancellationToken)
        {
            try
            {
                var resultMonthYear = Convert.ToInt32(_globalConfig.GetGlobalConfigByKey("Result_Month"));
                var resultMonthStartDate = Helper.GetDateFromMonthYear(resultMonthYear.ToString());
                var lastForecastMonthyear = Helper.GetLastForecastMonthYear(request.UpdateSNSPlanning.SNSPlanning.PeriodId, (DateTime)resultMonthStartDate);
                var lastForecastDate = Helper.GetDateFromMonthYear(lastForecastMonthyear.ToString());
                request.UpdateSNSPlanning.SNSPlanningList.RemoveAll(item => item.ModeofType == "Stock Days");


                // Take Summary Records
                List<string> customerCodes = request.UpdateSNSPlanning.SNSPlanning.CustomerCodeList.ToList();
                List<string> materialCodes = request.UpdateSNSPlanning.SNSPlanning.MaterialCodeList.ToList();

                List<string> subCateCodes = (from m in _context.Materials
                                             join p in _context.ProductCategories
                                             on m.ProductCategoryId2 equals p.ProductCategoryId
                                             where p.CategoryLevel == 2 && materialCodes.Contains(m.MaterialCode)
                                             select p.ProductCategoryCode).Distinct().ToList();

                var checkPermissionToUpdateRecord = _context.LockPSI.Where(x => x.UserId == request.SessionData.ADUserId && customerCodes.Contains(x.CustomerCode) && x.OC_IndicationMonth == true && subCateCodes.Contains(x.SubCategoryCode)).Distinct().ToList();
                if (checkPermissionToUpdateRecord.Any())
                {
                    string customer = string.Join(", ", checkPermissionToUpdateRecord.Select(item => item.CustomerCode).Distinct());
                    string mg1s = string.Join(", ", checkPermissionToUpdateRecord.Select(item => item.SubCategoryCode).Distinct());
                    return Result.Failure("You do not have permission to update data of these customer(" + customer + ") and Category(" + mg1s + ").Please contact to admin");
                }
                var summaryPlanList = request.UpdateSNSPlanning.SNSPlanningList.Where(c => c.CustomerId == null).ToList();

                // Insert and Update Summary Records
                if (summaryPlanList.Count() > 0)
                {
                    InsertUpdatePlanSummary(summaryPlanList, resultMonthYear, lastForecastDate.Value, request.SessionData.ADUserId);
                }

                var customerQtyPlanList = request.UpdateSNSPlanning.SNSPlanningList.Where(c => c.CustomerId != null).ToList();
                if (customerQtyPlanList.Count() > 0)
                {
                    InsertUpdateCustomerSaleEntry(customerQtyPlanList, resultMonthYear, lastForecastDate.Value, request.SessionData.ADUserId, request.UpdateSNSPlanning.SNSPlanning.AccountCode);
                }
                return Result.Success;
            }
            catch (Exception ex)
            {
                Log.Error($"Error in update sns planning with Message - {ex.Message}. StackTrace - {ex.StackTrace}");
                return Result.Failure(Contants.ERROR_MSG);
            }
        }

        private int? GetQuantityFromNewData(int index, SNSPlanningDetail snsSummaryData)
        {
            int? quantity = null;
            switch (index)
            {
                case 0:
                    quantity = snsSummaryData.Month0Quantity;
                    break;
                case 1:
                    quantity = snsSummaryData.Month1Quantity;
                    break;
                case 2:
                    quantity = snsSummaryData.Month2Quantity;
                    break;
                case 3:
                    quantity = snsSummaryData.Month3Quantity;
                    break;
                case 4:
                    quantity = snsSummaryData.Month4Quantity;
                    break;
                case 5:
                    quantity = snsSummaryData.Month5Quantity;
                    break;
                case 6:
                    quantity = snsSummaryData.Month6Quantity;
                    break;
                case 7:
                    quantity = snsSummaryData.Month7Quantity;
                    break;
                case 8:
                    quantity = snsSummaryData.Month8Quantity;
                    break;
                case 9:
                    quantity = snsSummaryData.Month9Quantity;
                    break;
                case 10:
                    quantity = snsSummaryData.Month10Quantity;
                    break;
                case 11:
                    quantity = snsSummaryData.Month10Quantity;
                    break;
                case 12:
                    quantity = snsSummaryData.Month12Quantity;
                    break;
            }
            return quantity;
        }

        private void InsertUpdatePlanSummary(List<SNSPlanningDetail> summaryPlanList, int resultMonthYear, DateTime lastForecastDate, string userId)
        {
            var snsSummaryListToUpdate = new List<TRNPricePlanning>();
            var snsSummaryListToInsert = new List<TRNPricePlanning>();

            summaryPlanList.ForEach((item) =>
            {
                var summayStartDate = Helper.GetDateFromMonthYear(resultMonthYear.ToString());
                int index = 0;
                var summaryIds = item.SNSSummaryIdList.Where(c => c.HasValue).ToList();
                var existingSummaryData = _trnPricePlanningRepository.GetTRNPricePlanningsByIds(summaryIds);
                while (summayStartDate <= lastForecastDate)
                {
                    if (index != 0)
                    {
                        var quantity = GetQuantityFromNewData(index, item);
                        var summaryId = item.SNSSummaryIdList[index];
                        var monthYear = Helper.GetMonthYearFromDate(summayStartDate.Value);
                        if (summaryId.HasValue)
                        {
                            var existingData = existingSummaryData.FirstOrDefault(c => c.TRNPricePlanningId == (int)summaryId);
                            if (existingData != null)
                            {
                                existingData.Quantity = quantity.HasValue ? quantity.Value : 0;
                                existingData.UpdatedDate = DateTime.Now;
                                existingData.UpdatedBy = userId;
                                snsSummaryListToUpdate.Add(existingData);
                            }
                            else
                            {
                                snsSummaryListToInsert.Add(new TRNPricePlanning()
                                {
                                    AccountCode = item.AccountCode,
                                    ModeofType = item.ModeofType,
                                    MonthYear = Convert.ToInt32(monthYear),
                                    MaterialCode = item.MaterialCode,
                                    Quantity = quantity.HasValue ? quantity.Value : 0,
                                    Type = item.Type,
                                    CreatedDate = DateTime.Now,
                                    CreatedBy = userId,
                                    UpdatedDate = DateTime.Now,
                                    UpdatedBy = userId,
                                    SaleSubType = "Monthly",
                                    Price=0
                                    

                                });
                            }
                        }
                        else
                        {
                            snsSummaryListToInsert.Add(new TRNPricePlanning()
                            {
                                AccountCode = item.AccountCode,
                                ModeofType = item.ModeofType,
                                MonthYear = Convert.ToInt32(monthYear),
                                MaterialCode = item.MaterialCode,
                                Quantity = quantity.HasValue ? quantity.Value : 0,
                                Price=0,
                                Type = item.Type,
                                CreatedDate = DateTime.Now,
                                CreatedBy = userId,
                                UpdatedDate = DateTime.Now,
                                UpdatedBy = userId,
                                SaleSubType="Monthly"
                            });
                        }
                    }
                    summayStartDate = summayStartDate.Value.AddMonths(1);
                    index++;
                }

            });

            if (snsSummaryListToInsert.Count() > 0)
            {
                _trnPricePlanningRepository.AddBulk(snsSummaryListToInsert);
            }

            if (snsSummaryListToUpdate.Count() > 0)
            {
                _trnPricePlanningRepository.UpdateBulk(snsSummaryListToUpdate);
            }

        }

        private void InsertUpdateCustomerSaleEntry(List<SNSPlanningDetail> summaryPlanList, int resultMonthYear, DateTime lastForecastDate, string userId, string accountCode)
        {
          
                var trnSalesPlanningToUpdate = new List<TRNSalesPlanning>();
                var trnSalesPlanningToInsert = new List<TRNSalesPlanning>();
                summaryPlanList.ForEach((item) =>
                {
                    var summayStartDate = Helper.GetDateFromMonthYear(resultMonthYear.ToString());
                    int index = 0;
                    while (summayStartDate <= lastForecastDate)
                    {
                        if (index != 0)
                        {
                            var quantity = GetQuantityFromNewData(index, item);
                            var monthYear = Helper.GetMonthYearFromDate(summayStartDate.Value);

                            //update
                            var updateTRNSalesPlanning = _trnSalesPlanningRepository.GetTRNSalesPlanning(accountCode, item.MaterialCode, item.CustomerCode, Convert.ToInt32(monthYear), "Monthly");
                            if (updateTRNSalesPlanning != null)
                            {
                                updateTRNSalesPlanning.Quantity = quantity.HasValue ? quantity.Value : 0;
                                updateTRNSalesPlanning.Amount= quantity.HasValue ? quantity.Value* updateTRNSalesPlanning.Price : 0;
                                updateTRNSalesPlanning.UpdatedDate = DateTime.Now;
                                updateTRNSalesPlanning.UpdatedBy = userId;
                                trnSalesPlanningToUpdate.Add(updateTRNSalesPlanning);
                            }
                            else
                            {
                                // insert trn Quantity
                                var newTRNSalesPlanning = new TRNSalesPlanning()
                                {
                                    AccountCode = accountCode,
                                    MonthYear = Convert.ToInt32(monthYear),
                                    CustomerCode = item.CustomerCode,
                                    MaterialCode = item.MaterialCode,
                                    Quantity = quantity.HasValue ? quantity.Value : 0,
                                    CreatedDate = DateTime.Now,
                                    CreatedBy = userId,
                                    UpdatedDate = DateTime.Now,
                                    UpdatedBy = userId,
                                    IsPlannes = true,
                                    SaleSubType="Monthly",
                            };
                                trnSalesPlanningToInsert.Add(newTRNSalesPlanning);
                            }
                        }
                        summayStartDate = summayStartDate.Value.AddMonths(1);
                        index++;
                    }
                });

                if (trnSalesPlanningToInsert.Count() > 0)
                {
                    _trnSalesPlanningRepository.AddBulk(trnSalesPlanningToInsert);
                }

                if (trnSalesPlanningToUpdate.Count() > 0)
                {
                    _trnSalesPlanningRepository.UpdateBulk(trnSalesPlanningToUpdate);
                }
            
           
        }

    }
}