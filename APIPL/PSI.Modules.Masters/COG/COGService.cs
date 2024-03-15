using Core.BaseUtility.Utility;
using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using PSI.Modules.Backends.COG.Command;
using PSI.Modules.Backends.COG.Queries;
using PSI.Modules.Backends.DirectSales.Command;
using PSI.Modules.Backends.DirectSales.Queries;
using PSI.Modules.Backends.Masters.Repository.CountryMaster;
using PSI.Modules.Backends.Masters.Repository.CustomerMaster;
using PSI.Modules.Backends.Masters.Repository.ProductCategoryMaster;
using PSI.Modules.Backends.Masters.Repository.UserViewProfile;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace PSI.Modules.Backends.COG
{
    public class COGService : ICOGService
    {
        private IMediator _mediator;
        private readonly IUserViewProfileRepository _userViewProfileRepository;
        private readonly ICustomerRepository _customerRepository;
        private readonly IProductCategoryRepository _productCategoryRepository;
        private readonly ICountryRepository _countryRepository;
        public COGService(IMediator mediator, IUserViewProfileRepository userViewProfileRepository,
            ICustomerRepository customerRepository
            , IProductCategoryRepository productCategoryRepository
            ,ICountryRepository countryRepository)
        {
            _mediator = mediator;
            _userViewProfileRepository = userViewProfileRepository;
            _customerRepository = customerRepository;
            _productCategoryRepository = productCategoryRepository;
            _countryRepository = countryRepository;
        }

        public Task<Result> UploadFiles(COGEntryUploadCommand command)
        {
            var result = _mediator.Send(command);
            return result;
        }
        public async Task<LoadResult> GetCOGUpload(DataSourceLoadOptions loadOptions, COGUploadSearch obj, string userId, bool isSupeAdmin)
        {
            if (!isSupeAdmin)
            {
                var data = _userViewProfileRepository.GetAll().Where(x => x.UserId == userId).ToList();
            if (obj.CountryId == null)
            {
                if (data.Count() > 0)
                    obj.CountryId = string.Join(",", data.Select(x => x.CountryId).Distinct().ToList());
            }
            if (obj.ProductCategoryId1 == "null")
            {
                if (data.Count() > 0)
                {
                    if (data.Count() > 0)
                    {
                        obj.ProductCategoryId1 = string.Join(",", data.Select(x => x.ProductId).ToList());
                    }
                }
            }
            if (obj.CustomerId == null)
            {
                obj.CustomerId = string.Join(",", _customerRepository.GetAll().Where(x => x.IsActive == true && (x.CountryId != null && data.Select(x => x.CountryId).Distinct().ToList().Contains((int)x.CountryId)) ).Select(x => x.CustomerId).ToList());

            }
            }
            var result = await _mediator.Send(new COGUploadSearchQuery(loadOptions, obj));
            return result;
        }
    }
}