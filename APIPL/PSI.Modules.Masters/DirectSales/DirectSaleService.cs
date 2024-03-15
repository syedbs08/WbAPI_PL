using Core.BaseUtility.Utility;
using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using Microsoft.Graph.CallRecords;
using PSI.Domains.Entity;
using PSI.Modules.Backends.DirectSales.Command;
using PSI.Modules.Backends.DirectSales.Queries;
using PSI.Modules.Backends.Masters.Repository.CountryMaster;
using PSI.Modules.Backends.Masters.Repository.CustomerMaster;
using PSI.Modules.Backends.Masters.Repository.ProductCategoryMaster;
using PSI.Modules.Backends.Masters.Repository.UserViewProfile;
using PSI.Modules.Backends.Report.Queries;
using static PSI.Modules.Backends.Constants.Contants;

namespace PSI.Modules.Backends.DirectSales
{
    public class DirectSaleService : IDirectSaleService
    {
        private IMediator _mediator;
        private readonly ICustomerRepository _customerRepository;
        private readonly ICustomerViewReopsitory _customerViewReopsitory;
        private readonly IUserViewProfileRepository _userViewProfileRepository;
        private readonly IProductCategoryRepository _productCategoryRepository;
        private readonly ICountryRepository _countryRepository;
        public DirectSaleService(IMediator mediator, ICustomerRepository customerRepository, ICustomerViewReopsitory customerViewReopsitory
            , IUserViewProfileRepository userViewProfileRepository, IProductCategoryRepository productCategoryRepository
            , ICountryRepository countryRepository)
        {
            _mediator = mediator;
            _userViewProfileRepository = userViewProfileRepository;
            _customerRepository = customerRepository;
            _customerViewReopsitory = customerViewReopsitory;
            _productCategoryRepository = productCategoryRepository;
            _countryRepository = countryRepository;
        }
        #region OcIndicationMonth
        public async Task<LoadResult> GetOcIndicationMonth(DataSourceLoadOptions loadOptions, OCIndicationMonthSearchCommand obj, string userId, bool isSupeAdmin, SessionData SessionMain)
        {
            if (isSupeAdmin == true)
            {
                if (obj.CountryId == null)
                {
                    obj.CountryId = string.Join(",", _countryRepository.GetAllCountry().Select(x => x.CountryId).ToList());
                }
            }
            if (!isSupeAdmin)
            {
                var data = _userViewProfileRepository.GetAll().Where(x => x.UserId == userId).ToList();
                if (obj.CountryId == null)
                {
                    if (data.Count() > 0)
                        obj.CountryId = string.Join(",", data.Select(x => x.CountryId).Distinct().ToList());
                }
                if (obj.ProductCategoryId == null)
                {
                   
                    if (data.Count() > 0)
                    {
                        obj.ProductCategoryId = string.Join(",", data.Select(x => x.ProductId).ToList());
                    }
                }
                if (obj.CustomerId == null)
                {
                    string saleTypeName = Convert.ToString((int)SaleTypeEnum.Direct);
                    if (obj.CustomerTypeId == null)
                    {
                        obj.CustomerId = string.Join(",", _customerViewReopsitory.GetAll().Where(x => x.IsActive == true && (x.SalesTypeIds != null && x.SalesTypeIds.Split(",").Any(c => saleTypeName.Contains(c))) && (x.CountryId != null && data.Select(x => x.CountryId).Distinct().ToList().Contains((int)x.CountryId)) ).Select(x => x.CustomerId).ToList());
                       // obj.CustomerId = string.Join(",", _customerRepository.GetAll().Where(x => x.IsActive == true && data.Select(x => x.CountryId).Distinct().ToList().Contains((int)x.CountryId) && x.PersonInChargeId == userId).Select(x => x.CustomerId).ToList());
                    }
                    else
                    {
                        obj.CustomerId = string.Join(",", _customerViewReopsitory.GetAll().Where(x => x.IsActive == true && (x.SalesTypeIds != null && x.SalesTypeIds.Split(",").Any(c => saleTypeName.Contains(c))) && x.IsCollabo == obj.CustomerTypeId && (x.CountryId != null && data.Select(x => x.CountryId).Distinct().ToList().Contains((int)x.CountryId))).Select(x => x.CustomerId).ToList());
                    }

                }
            }
            var result = await _mediator.Send(new OCIndicationMonthConfirmSearchQuery(loadOptions, obj, SessionMain));
            return result;
        }
        public async Task<Result> UpdateOCIndicationMonth(OCIndicationMonthCommand command, SessionData session)
        {
            var result = await _mediator.Send(new UpdateOCIndicationMonthCommand(command, session));
            return result;
        }
        #endregion

        #region Direct Sales Agency Upload
        /// <summary>
        /// Upload Direct Sales File
        /// </summary>
        /// <param name="command"></param>
        /// <returns></returns>
        public Task<Result> UploadFiles(DirectSalesCommand command)
        {
            var result = _mediator.Send(command);
            return result;
        }

        /// <summary>
        /// Download Direct Sales File
        /// </summary>
        /// <param name="command"></param>
        /// <returns></returns>
        public Task<Result> GetOrDownloadAgentSaleSummary(DirectSalesDownloadCommand command)
        {
            var result = _mediator.Send(command);
            return result;
        }
        #endregion

        #region Direct Sale OCO-Current lock months
        public async Task<LoadResult> GetOCOLockMonth(DataSourceLoadOptions loadOptions, OCOLockMonthSearchCommand obj, string userId, bool isSupeAdmin)
        {
            if (isSupeAdmin == true)
            {
                if (obj.CountryId == null)
                {
                    obj.CountryId = string.Join(",", _countryRepository.GetAllCountry().Select(x => x.CountryId).ToList());
                }
            }
            if (!isSupeAdmin)
            {
                var data = _userViewProfileRepository.GetAll().Where(x => x.UserId == userId).ToList();
                if (obj.CountryId == null)
                {
                    if (data.Count > 0)
                        obj.CountryId = string.Join(",", data.Select(x => x.CountryId).Distinct().ToList());
                }
                if (obj.ProductCategoryId == null)
                {
                    if (data.Count() > 0)
                    {
                        obj.ProductCategoryId = string.Join(",", data.Select(x => x.ProductId).ToList());
                    }
                }
                if (obj.CustomerId == null)
                {
                    if (obj.CustomerTypeId == null)
                    {
                        obj.CustomerId = string.Join(",", _customerRepository.GetAll().Where(x => x.IsActive == true && (x.CountryId != null && data.Select(x => x.CountryId).Distinct().ToList().Contains((int)x.CountryId)) ).Select(x => x.CustomerId).ToList());
                    }
                    else
                    {
                        obj.CustomerId = string.Join(",", _customerRepository.GetAll().Where(x => x.IsActive == true && x.IsCollabo == obj.CustomerTypeId && (x.CountryId != null && data.Select(x => x.CountryId).Distinct().ToList().Contains((int)x.CountryId)) ).Select(x => x.CustomerId).ToList());
                    }

                }
            }
            var result = await _mediator.Send(new OCOLockMonthSearchQuery(loadOptions, obj));
            return result;
        }
        public async Task<Result> UpdateSaleEntryStatus(List<OCOLockMonthCommand> commands, SessionData sessionMain)
        {
            var result = await _mediator.Send(new CreateOCOLockMonthCommand(commands, sessionMain));
            return result;
        }

        #endregion

        //#region archive
        //public Task<SalesArchivalEntry> DirectSaleArchive(string month,string createdby)
        //{

        //}
        //#endregion

        #region SSD
        
        public async Task<Result> UploadSSDForeCast(SSDForecastUploadCommand command)
        {
            var result = await _mediator.Send(command);
            return result;
        }
        #endregion

        public async Task<Result> GetDirectSaleReport(DirectSaleReportSearchQuery query)
        {
            var result = await _mediator.Send(query);
            return result;
        }
    }
}
