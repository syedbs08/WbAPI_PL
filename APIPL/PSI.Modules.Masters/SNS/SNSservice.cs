using Core.BaseUtility.Utility;
using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Azure;
using Microsoft.Extensions.Configuration;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.CountryMaster;
using PSI.Modules.Backends.SNS.Command;
using PSI.Modules.Backends.SNS.Queries;
using PSI.Modules.Backends.SNS.Repository;
using PSI.Modules.Backends.SNS.Results;
using System.Globalization;
using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;

namespace PSI.Modules.Backends.SNS
{
    public class SNSService : ISNSService
    {
        private IMediator _mediator;
        private readonly ISNSPlanningCommentRepository iSNSPlanningCommentRepository;
        private readonly IVW_SNSPlanningCommentRepository _vwSNSPlanningCommentRepository;
        private readonly IConfiguration _configuration;
        private readonly ISPINSResultPurchaseRepository _spINSResultPurchaseRepository;
        private readonly ISPGetPlannedCustomerRepository _plannedCustomerRepo;
        private readonly PSIDbContext _context;
        public SNSService(IMediator mediator,
        ISNSPlanningCommentRepository sNSPlanningCommentRepository,
        IVW_SNSPlanningCommentRepository vwSNSPlanningCommentRepository,
        IConfiguration configuration,
        ISPINSResultPurchaseRepository spINSResultPurchaseRepository,
        ISPGetPlannedCustomerRepository plannedCustomerRepo)
        {
            _mediator = mediator;
            iSNSPlanningCommentRepository = sNSPlanningCommentRepository;
            _vwSNSPlanningCommentRepository = vwSNSPlanningCommentRepository;
            _configuration = configuration;
            _spINSResultPurchaseRepository = spINSResultPurchaseRepository;
            _plannedCustomerRepo = plannedCustomerRepo;
            _context = new PSIDbContext();
        }

        public Task<Result> Archive(SNSArchiveCommand command)
        {
            var result = _mediator.Send(command);
            return result;
        }

        public async Task<LoadResult> ArchiveData(DataSourceLoadOptions loadOptions, SNSArchiveSearch obj)
        {
            var result = await _mediator.Send(new SNSArchiveSearchQuery(loadOptions, obj));
            return result;
        }
        public Task<Result> TriggerRollingInventorySnsBP(RollingInventorySnsBPCommand command)
        {
            var result = _mediator.Send(command);
            return result;
        }

        public Task<Result> GetOrDownloadSNSEntry(SNSEntryDownloadCommand command)
        {
            var result = _mediator.Send(command);
            return result;
        }

        public async Task<Result> SNSUploadFiles(SNS_PriceCommand command)
        {
            var result = await _mediator.Send(command);
            return result;
        }
        public async Task<Result> RunPriceProcess(RunPriceProcessCommand command)
        {
            var result = await _mediator.Send(command);
            return result;
        }

        public Task<Result> UploadFiles(SNSEntryUploadCommand command)
        {
            var result = _mediator.Send(command);
            return result;
        }
        public async Task<Result> CreateSNSComment(SNSPlanningCommentCommand command)
        {
            var result = await _mediator.Send(command);
            return result;
        }
        public async Task<IEnumerable<VW_SNSPlanningComment>> GetPlanningComment(string materialcode, string accountcode)
        {
            var result = _vwSNSPlanningCommentRepository.GetSNSPlanningCommentByQuery(materialcode, accountcode);
            return result;
        }

        #region SNS_Planning
        public async Task<Result> GetSNSPlanning(SNSPlanningCommand command)
        {
            var result = await _mediator.Send(command);
            return result;
        }

        public async Task<Result> UpdateSNSPlanning(UpdateSNSPlanningCommand command)
        {
            var result = await _mediator.Send(command);
            return result;
        }

        public List<SP_GET_PLANNEDCUSTOMER> GetPlannedCustomer(string accountCode, string materialCode)
        {
            return _plannedCustomerRepo.GetAll(accountCode, materialCode);

        }
        #endregion



        #region month closing
        public async Task<SapRfcResponseResult> TriggerMonthClosing(string type, string userId)
        {
            var resonseResult = new SapRfcResponseResult();
            try
            {
                var handler = new HttpClientHandler();
                handler.ClientCertificateOptions = ClientCertificateOption.Manual;
                handler.ServerCertificateCustomValidationCallback =
                    (httpRequestMessage, cert, cetChain, policyErrors) =>
                    {
                        return true;
                    };
                using (var client = new HttpClient(handler))
                {
                    client.BaseAddress = new Uri(_configuration["AppConfig:SapRfcUrl"]);
                    client.DefaultRequestHeaders.Accept.Clear();
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                    HttpResponseMessage response = await client.GetAsync($"{type}/{userId}");
                    if (response.IsSuccessStatusCode)
                    {
                        resonseResult = await response.Content.ReadFromJsonAsync<SapRfcResponseResult>();

                    }
                    else
                    {
                        var content = await response.Content.ReadAsStringAsync();
                        resonseResult.ErrorMessage = content;

                    }
                }

            }

            catch (Exception ex)
            {
                resonseResult.ErrorMessage = ex.Message;
            }
            return resonseResult;

        }
        public SapRfcResponseResult SaveResultPurchase(string userId)
        {

            var resultPurchase = new SapRfcResponseResult();
            try
            {

                var result = _spINSResultPurchaseRepository.SaveResultMonthPurchase(userId);
                if (result.Any())
                {
                    resultPurchase.InsertedCount = result.Count();

                }


            }
            catch (Exception ex)
            {
                resultPurchase.ErrorMessage = ex.Message;

            }
            return resultPurchase;

        }

        public async Task<Result> UpdateConsinee(UpdateConsineeCommand command)
        {
            var result = await _mediator.Send(command);
            return result;
        }

        public async Task<Result> AddSNSMapping(SNSMappingCommand command)
        {
            var result = await _mediator.Send(command);
            return result;
        }
        public async Task<LoadResult> GetSNSMapping(DataSourceLoadOptions loadOptions)
        {
            return await _mediator.Send(new SNSMappingSearchQuery(loadOptions));
        }
        #endregion
        public async Task<Result> RollingInventory(string accountCode)
        {

            var data = _context.TRNPricePlannings.Where(x => x.AccountCode == accountCode && x.MonthYear >= 202311 && x.MonthYear <= 202405 && x.ModeofType == "INVENTORY").ToList();
            try
            {
                int count = 0;
                foreach (var res in data)
                {
                    count++;

                    DateTime nextmonth = DateTime.ParseExact(Convert.ToString(res.MonthYear), "yyyyMM", CultureInfo.InvariantCulture);
                    var resultMonthDate = nextmonth.AddMonths(-1);
                    string resultMonth = resultMonthDate.ToString("yyyyMM");
                    
                    int prvInvqty = 0;
                    decimal prvInvPrice = 0;
                    int purchaseqty = 0;
                    decimal purchasePrice = 0;
                    int mpoQty = 0;
                    decimal mpoPrice = 0;
                    int adjQty = 0;
                    decimal adjPrice = 0;
                    int saleQty = 0;
                    decimal salePrice = 0;
                    var prvInv = _context.TRNPricePlannings.Where(x => x.AccountCode == accountCode && x.MaterialCode == res.MaterialCode && x.MonthYear == Convert.ToInt32(resultMonth) && x.ModeofType == "INVENTORY").FirstOrDefault();
                    if (prvInv != null)
                    {
                        prvInvqty = Convert.ToInt32(prvInv.Quantity);
                        prvInvPrice = Convert.ToDecimal(prvInv.Price);
                    }
                    var purchase = _context.TRNPricePlannings.Where(x => x.AccountCode == accountCode && x.MaterialCode == res.MaterialCode && x.MonthYear == res.MonthYear && x.ModeofType == "PURCHASE").FirstOrDefault();
                    if (purchase != null)
                    {
                        purchaseqty = Convert.ToInt32(purchase.Quantity);
                        purchasePrice = Convert.ToDecimal(purchase.Price);
                    }
                    var mpo = _context.TRNPricePlannings.Where(x => x.AccountCode == accountCode && x.MaterialCode == res.MaterialCode && x.MonthYear == res.MonthYear && x.ModeofType == "MPO").FirstOrDefault();
                    if (mpo != null)
                    {
                        mpoQty = Convert.ToInt32(mpo.Quantity);
                        mpoPrice = Convert.ToDecimal(mpo.Price);
                    }
                    var adj = _context.TRNPricePlannings.Where(x => x.AccountCode == accountCode && x.MaterialCode == res.MaterialCode && x.MonthYear == res.MonthYear && x.ModeofType == "ADJ").FirstOrDefault();
                    if (adj != null)
                    {
                        adjQty = Convert.ToInt32(adj.Quantity);
                        adjPrice = Convert.ToDecimal(adj.Price);
                    }
                    var sale = _context.TRNPricePlannings.Where(x => x.AccountCode == accountCode && x.MaterialCode == res.MaterialCode && x.MonthYear == res.MonthYear && x.ModeofType == "SALES").FirstOrDefault();
                    if (sale != null)
                    {
                        saleQty = Convert.ToInt32(sale.Quantity);
                        salePrice = Convert.ToDecimal(sale.Price);
                    }
                    int currentInvtQty = (prvInvqty + purchaseqty + mpoQty + adjQty) - saleQty;
                    decimal currentInvtPrice = (prvInvPrice + purchasePrice + mpoPrice + adjPrice) - salePrice;
                    res.Price = currentInvtPrice;
                    res.Quantity = currentInvtQty;
                    res.UpdatedDate = DateTime.Now;
                    res.UpdatedBy = "kamna";
                    _context.TRNPricePlannings.Update(res);
                    _context.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                return Result.Success;
            }
            return Result.Success;
        }

        public async Task<Result> MapSNSModel(string accountCode,string userid)
        {
            var res = await _context.SP_ResponseResult.FromSql($"SP_MAPPING_ROLLINGINGINVENTORY {accountCode},{userid}").AsNoTracking().ToListAsync();
            if (res.Count() == 0)
            {
                return Result.Success;
            }
            else
            {
                Log.Error($"SNS mapping Add:Db operation failed{res}");
                return Result.Failure("Error in adding SNS mapping,contact to support team");
            }
        }

    }
}