using Core.BaseEntitySql.BaseRepository;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.DepartmentMaster;
using PSI.Modules.Backends.Masters.Repository.CountryMaster;
using PSI.Modules.Backends.Masters.Repository.DepartmentMaster;
using PSI.Modules.Backends.Masters.Results;

using PSI.Modules.Backends.Helpers;
using Core.BaseUtility.TableSearchUtil;
using DevExtreme.AspNet.Data.ResponseModel;
using DevExtreme.AspNet.Data;
using PSI.Modules.Backends.Masters.Repository.CompanyMaster;

namespace PSI.Modules.Backends.Masters.QueriesHandler.DepartmentMaster
{
    public class DepartmentSearchHandler : IRequestHandler<DepartmentSearchQuery, LoadResult> 
    {
        private readonly IDepartmentMasterRepository _deparmentRepository;
        private readonly ICountryRepository _countryRepository;
        private readonly ICompanyRepository _companyRepository;
        public DepartmentSearchHandler(IDepartmentMasterRepository deparmentRepository, ICountryRepository countryRepository,ICompanyRepository companyRepository)
        {
            _deparmentRepository = deparmentRepository;
            _countryRepository = countryRepository;
            _companyRepository = companyRepository;
        }
        public async Task<LoadResult> Handle(DepartmentSearchQuery request, CancellationToken cancellationToken)
        {
            var deparmentResult = _deparmentRepository.GetDepartments();
            var countries = _countryRepository.GetAll();
            string companyCode = "";
            var data = deparmentResult.Select(x => new DepartmentResults
            {
                CreatedBy = x.CreatedBy,
                CreatedDate = x.CreatedDate,
                DepartmentId = x.DepartmentId,
                DepartmentCode = x.DepartmentCode,
                DepartmentName = x.DepartmentName,
                DepartmentDescription = x.DepartmentDescription,
                IsActive = x.IsActive,
                CompanyId=0,
                CompanyName=null,
                CompanyCode=companyCode,
                Countries = GetDepartmentWiseCountry(countries, x.CountryId),
            });
            var result = DataSourceLoader.Load(data, request.LoadOptions);
            return await Task.FromResult(result);
        }
        private string GetCompanyName(string companyId,out string companyCode)
        {
            var result = _companyRepository.GetById(Convert.ToInt32(companyId));
            if(result.Result != null)
            {
                companyCode = result.Result.CompanyCode;
                return result.Result.CompanyName;
            }
            companyCode = "";
            return "";
        }
        public List<Country> GetDepartmentWiseCountry(IEnumerable<Country> countries,string countryIds)
        {
            if (string.IsNullOrWhiteSpace(countryIds) == true)
            {
                return new List<Country>();
        
            }
            int[] departmentCountryIds = Helper.SplitToInt(countryIds);
            return countries.Where(x => departmentCountryIds.Contains(x.CountryId)).ToList();
        }
    }
}
