
using AttachmentService.Command;
using Core.BaseUtility.Utility;
using FluentValidation;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Command.AccountMaster;
using PSI.Modules.Backends.Masters.Command.CompanyMaster;
using PSI.Modules.Backends.Masters.Command.CountryMaster;
using PSI.Modules.Backends.Masters.Command.CurrencyMaster;
using PSI.Modules.Backends.Masters.Command.RegionMaster;
using PSI.Modules.Backends.Masters.Command.Department;
using PSI.Modules.Backends.Masters.Queries.AccountMaster;
using PSI.Modules.Backends.Masters.Queries.CompanyMaster;
using PSI.Modules.Backends.Masters.Queries.CountryMaster;
using PSI.Modules.Backends.Masters.Queries.CurrencyMaster;
using PSI.Modules.Backends.Masters.Queries.RegionMaster;
using PSI.Modules.Backends.Masters.Queries.DepartmentMaster;
using PSI.Modules.Backends.Masters.Results;
using PSI.Modules.Backends.Masters.Command.ProductCategoryMaster;
using PSI.Modules.Backends.Masters.Queries.ProductCategoryMaster;
using PSI.Modules.Backends.Masters.Repository.CurrencyMaster;
using PSI.Modules.Backends.Services.ExcelServices;
using PSI.Modules.Backends.Masters.Repository.ProductCategoryMaster;
using PSI.Modules.Backends.Masters.Repository.RegionMaster;
using PSI.Modules.Backends.Masters.Queries.PSIDatesMaster;
using PSI.Modules.Backends.Masters.Command.PSIDatesMaster;
using PSI.Modules.Backends.Masters.Repository.PSIDatesMaster;
using AutoMapper;
using PSI.Modules.Backends.Masters.Command.TurnoverDaysMaster;
using PSI.Modules.Backends.Masters.Queries.TurnoverDaysMaster;
using PSI.Modules.Backends.Masters.Repository.TurnoverDaysMaster;
using PSI.Modules.Backends.Masters.Repository.AccountMaster;
using PSI.Modules.Backends.Masters.Command.MaterialMaster;
using PSI.Modules.Backends.Masters.Repository.CompanyMaster;
using PSI.Modules.Backends.Masters.Repository.SupplierMaster;
using PSI.Modules.Backends.Masters.Repository.SeaPortMaster;
using PSI.Modules.Backends.Masters.Repository.AirPortMaster;
using PSI.Modules.Backends.Masters.Command.UserDepartmentMaster;
using PSI.Modules.Backends.Masters.Queries.UserViewProfile;
using PSI.Modules.Backends.Masters.Command.UserProductMap;
using PSI.Modules.Backends.Masters.Repository.MaterialMaster;
using DevExtreme.AspNet.Data;
using DevExtreme.AspNet.Data.ResponseModel;
using PSI.Modules.Backends.Masters.Queries.DashMaster;
using PSI.Modules.Backends.Masters.Command.CustomerMaster;
using PSI.Modules.Backends.Masters.Repository.SalesOfficeMaster;
using PSI.Modules.Backends.Masters.Repository.CustomerMaster;
using System.Data;
using PSI.Modules.Backends.Masters.Repository.SaleTypeMaster;
using SessionManagers.Results;
using PSI.Modules.Backends.Masters.Repository.UserDepartmentCountry;
using PSI.Modules.Backends.Masters.Repository.UserViewProfile;
using PSI.Modules.Backends.Masters.Queries.PSILockMaster;
using PSI.Modules.Backends.Masters.Repository.CountryMaster;
using PSI.Modules.Backends.Masters.Repository.GlobalConfigMaster;
using PSI.Modules.Backends.Masters.Repository.SalesOrganizationMaster;
using Core.BaseEntitySql.BaseRepository;
using static PSI.Modules.Backends.Constants.Contants;
using PSI.Modules.Backends.Masters.Repository.UsersMaster;
using PSI.Modules.Backends.Masters.Command.LockPSIMaster;
using PSI.Modules.Backends.Masters.Repository.DepartmentMaster;
using PSI.Modules.Backends.Helpers;
using Microsoft.EntityFrameworkCore;
using PSI.Domains;
using Microsoft.Data.SqlClient;
using PSI.Modules.Backends.Masters.Repository.LockPSIMaster;
using PSI.Modules.Backends.Masters.Queries.MaterialMaster;
using PSI.Modules.Backends.Adjustments.Queries;
using System.Xml.Linq;
using System.Linq;
using NPOI.Util;
using PSI.Modules.Backends.Masters.Command.Report;

namespace PSI.Modules.Backends.Masters.Services
{
    public class MasterService : IMasterService
    {
        private IMediator _mediator;
        private readonly IExcelExport _excelExportService;
        private readonly ICurrencyRepository _currencyRepository;
        private readonly IRegionRepository _regionRepository;
        private readonly IPSIDatesRepository _psiDatesRepository;
        private readonly IMapper _mapper;
        private readonly ITurnoverDaysRepository _turnoverDaysRepository;
        private readonly IAccountRepository _accountRepository;
        private readonly ICompanyRepository _companyRepository;
        private readonly IProductCategoryRepository _productCategoryRepository;
        private readonly ISupplierRepository _supplierRepository;
        private readonly ISeaPortRepository _seaPortRepository;
        private readonly IAirPortRepository _airPortRepository;
        private readonly IMaterialViewReopsitory _materialViewReopsitory;
        private readonly ISalesOfficeRepository _salesOfficeRepository;
        private readonly ICustomerViewReopsitory _customerViewReopsitory;
        private readonly ICustomerRepository _customerRepository;
        private readonly ISaleTypeRepository _saleTypeRepository;
        private readonly IUserDepartmentCountryRepository _userDepartmentCountryRepository;
        private readonly IUserViewProfileRepository _userViewProfileRepository;
        private readonly ICountryRepository _countryRepository;
        private readonly IGlobalConfigRepository _globalConfigRepository;
        private readonly ISalesOrganizationRepository _salesOrganizationRepository;
        private readonly IMaterialRepository _materialRepository;
        private readonly IUsersRepository _usersRepository;
        private readonly IDepartmentMasterRepository _departmentMasterRepository;
        private readonly ISPGetLockPSIRepository _psiLockRepo;
        private readonly ILockPSIRepository _psilockTableRepo;
        private readonly PSIDbContext _context;
        public MasterService(IMediator mediator,
            ICurrencyRepository currencyRepository,
            IRegionRepository regionRepository,
            IPSIDatesRepository psiDatesRepository,
            IMapper mapper,
            ITurnoverDaysRepository turnoverDaysRepository,
            IAccountRepository accountRepository,
            ICompanyRepository companyRepository,
            IProductCategoryRepository productCategoryRepository,
            ISupplierRepository supplierRepository,
            ISeaPortRepository seaPortRepository,
            IAirPortRepository airPortRepository,
            IMaterialViewReopsitory materialViewReopsitory,
            ISalesOfficeRepository salesOfficeRepository,
            ICustomerViewReopsitory customerViewReopsitory,
            ICustomerRepository customerRepository,
            ISaleTypeRepository saleTypeRepository,
            IUserDepartmentCountryRepository userDepartmentCountryRepository,
            IUserViewProfileRepository userViewProfileRepository,
            ICountryRepository countryRepository,
            IGlobalConfigRepository globalConfigRepository,
            ISalesOrganizationRepository salesOrganizationRepository,
            IMaterialRepository materialRepository,
            IUsersRepository usersRepository,
            IDepartmentMasterRepository departmentMasterRepository,
            ISPGetLockPSIRepository psiLockRepo,
            ILockPSIRepository psilockTableRepo
            )
        {
            _mediator = mediator;
            _currencyRepository = currencyRepository;
            _excelExportService = new GenerateExcel();
            _regionRepository = regionRepository;
            _psiDatesRepository = psiDatesRepository;
            _mapper = mapper;
            _turnoverDaysRepository = turnoverDaysRepository;
            _accountRepository = accountRepository;
            _companyRepository = companyRepository;
            _productCategoryRepository = productCategoryRepository;
            _supplierRepository = supplierRepository;
            _seaPortRepository = seaPortRepository;
            _airPortRepository = airPortRepository;
            _materialViewReopsitory = materialViewReopsitory;
            _salesOfficeRepository = salesOfficeRepository;
            _customerViewReopsitory = customerViewReopsitory;
            _customerRepository = customerRepository;
            _saleTypeRepository = saleTypeRepository;
            _userDepartmentCountryRepository = userDepartmentCountryRepository;
            _userViewProfileRepository = userViewProfileRepository;
            _countryRepository = countryRepository;
            _globalConfigRepository = globalConfigRepository;
            _salesOrganizationRepository = salesOrganizationRepository;
            _materialRepository = materialRepository;
            _usersRepository = usersRepository;
            _departmentMasterRepository = departmentMasterRepository;
            _context = new PSIDbContext();
            _psiLockRepo = psiLockRepo;
            _psilockTableRepo = psilockTableRepo;
        }

        #region account master
        public async Task<Result> AddAccount(AccountCommand command)
        {

            var result = await _mediator.Send(new CreateAccountCommand(command));
            return result;
        }
        public async Task<List<Account>> GetAccounts()
        {
           
            var result = _accountRepository.GetAll();
            return result.Where(x => x.IsActive == true).ToList();

        }

        public async Task<List<FCPLCompany>> GetFCPLCompany()
        {
            DataSet dataSet = new DataSet();
            string CS = "Data Source=PMMSQLDEV02;Initial Catalog=FBC_Live;User ID=pmmsqldevadmin;Password=init#123456; MultipleActiveResultSets=true;Encrypt=false;TrustServerCertificate=False;Connection Timeout=30";
            using (SqlConnection con = new SqlConnection(CS))
            {
                SqlCommand cmd = new SqlCommand("FCPL_GetCompany", con);
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();               

                //SqlDataAdapter adapter = new SqlDataAdapter(cmd, con);
                
                //adapter.Fill(dataSet, "dsCompany");


            }
            List<FCPLCompany> companyList = new List<FCPLCompany>();

            //foreach (DataRow row in dataSet["dsCompany"].dataTable[0].Rows)
            //{
            //    FCPLCompany dataObject = new FCPLCompany
            //    {
            //        COMPANY_CODE =row["COMPANY_CODE"].ToString(),
            //        COMPANY_NAME = row["COMPANY_NAME"].ToString(),
            //        SHORT_NAME = row["SHORT_NAME"].ToString(),
            //        ACTIVE = row["ACTIVE"].ToString()
                    
            //    };

            //    companyList.Add(dataObject);
            //}

            return companyList;

        }

        #endregion
        #region MastersQuery & Lookups
        public async Task<IEnumerable<Account>> GetAccounts(int pageNumber = 0,
            int pageSize = 1,
            string hotelName = "",
            string city = "",
            string searchTerm = "")
        {
            var result = await _mediator.Send(new AccountSearchQuery(pageNumber, pageSize,
                hotelName, city, searchTerm));
            return result;
        }
        public async Task<Account> GetAccount(string accountCode, string accountName)
        {
            var result = await _mediator.Send(new AccountSingleQuery(accountCode, accountName));
            return result;
        }
        #region Country
        public async Task<Result> AddCountry(CountryCommand command)
        {
            return await _mediator.Send(new CreateCountryCommand(command));
        }
        public async Task<IEnumerable<Country>> GetAllCountry()
        {
            return await _mediator.Send(new CountryLookupQuery());
        }
        public async Task<IEnumerable<Country>> GetCountryByDepartment(string? departmentId)
        {
            var departmentIds = departmentId
                   .Split(',').Select(s => int.TryParse(s, out int result) ? result : 0)
                .ToList();
            var data = _departmentMasterRepository.GetAll().ToList();
            data = data.Where(x => departmentIds.Contains(x.DepartmentId)).ToList();
            int[] countryIds = null;
            if (data.Any())
            {
                List<int> intList = new List<int>();
                var countryids = data.Select(x => x.CountryId).ToList();
                if (countryids != null)
                {
                    foreach (string? str in countryids)
                    {
                        var Ids = str.Split(',').Select(s => int.TryParse(s, out int result) ? result : 0).ToList();
                        intList.AddRange(Ids);
                    }
                    countryIds = intList.ToArray();
                }
            }
            var result = _countryRepository.GetByIds(countryIds);
            return result;
        }
        public async Task<LoadResult> GetCountry(DataSourceLoadOptions loadOptions)
        {
            return await _mediator.Send(new CountrySearchQuery(loadOptions));
        }
        //public async Task<PagingResponse<Country>> GetCountry(PagingRequest paging)
        //{
        //    return await _mediator.Send(new CountrySearchQuery(paging));
        //}
        public async Task<Country> GetCountry(string accountCode, string accountName)
        {
            return await _mediator.Send(new CountrySingleQuery(accountCode, accountName));
        }
        public async Task<Result> DeleteCountry(int countryId, string updateBy)
        {
            var result = await _mediator.Send(new DeleteCountryCommand(countryId, updateBy));
            return result;
        }
        #endregion
        #region Companies
        public async Task<LoadResult> GetCompanyMasters(DataSourceLoadOptions loadOptions)
        {
            var result = await _mediator.Send(new CompanySearchQuery(loadOptions));
            return result;
        }
        public async Task<Result> AddCompany(CompanyCommand command)
        {
            var result = await _mediator.Send(new CreateCompanyCommand(command));
            return result;
        }
        public async Task<Result> DeleteCompany(int companyId, string updateBy)
        {
            var result = await _mediator.Send(new DeleteCompanyCommand(companyId, updateBy));
            return result;
        }
        public async Task<List<Company>> GetCompany()
        {
            var result = _companyRepository.GetAll();
            return result.Where(X => X.IsActive == true && X.IsDeleted != true).OrderBy(x => x.CompanyName).ToList(); ;
        }
        public MemoryStream ExportCompany(string fileName)
        {
            var result = _companyRepository.ExportCompanies();
            return _excelExportService.Export(result, fileName);
        }
        #endregion
        #region Region
        public async Task<Result> AddRegion(RegionCommand command)
        {
            var result = await _mediator.Send(new CreateRegionCommand(command));
            return result;
        }
        public async Task<LoadResult> GetRegionMasters(DataSourceLoadOptions loadOptions)
        {
            var result = await _mediator.Send(new RegionSearchQuery(loadOptions));
            return result;
        }
        public async Task<Result> DeleteRegion(int regionId, string updateBy)
        {
            var result = await _mediator.Send(new DeleteRegionCommand(regionId, updateBy));
            return result;
        }
        public MemoryStream ExportRegion(string fileName)
        {
            var result = _regionRepository.GetRegions();
            return _excelExportService.Export(result, fileName);
        }
        public async Task<List<Region>> GetRegions()
        {
            var result = _regionRepository.GetAll();
            return result.Where(X => X.IsActive == true).OrderBy(x => x.RegionName).ToList();
        }
        #endregion

        #region Department
        public async Task<Result> AddDepartment(DepartmentCommand command)
        {
            return await _mediator.Send(new CreateDepartmentCommand(command));
        }

        public async Task<LoadResult> GetDepartment(DataSourceLoadOptions loadOptions)
        {
            return await _mediator.Send(new DepartmentSearchQuery(loadOptions));

        }
        public async Task<Department> GetDepartment(string departmentCode, string departmentName)
        {
            return await _mediator.Send(new DepartmentSIngleQuery(departmentCode, departmentName));
        }
        public async Task<Result> DeleteDepartment(int departmentId, string updateBy)
        {
            return await _mediator.Send(new DeleteDepartmentCommand(departmentId, updateBy));
        }
        public async Task<Result> MapUserDepartment(UserDepartmentMappingCommand command)
        {
            return await _mediator.Send(new CreateUserDepartmentMappingCommand(command));
        }
        public async Task<IEnumerable<DepartmentLookupCommand>> DepartmentLookups()
        {
            return await _mediator.Send(new DepartmentLookupQuery());
        }
        public async Task<IEnumerable<UserProfileView>> UserDepartmentMappLookups(string userId)
        {
            return await _mediator.Send(new UserProfileViewQuery(userId));
        }
        #endregion

        #region currency
        public async Task<List<Currency>> GetCurrency()
        {
            var result = _currencyRepository.GetAll();
            return result.OrderBy(x => x.CurrencyCode).ToList(); ;
        }
        public async Task<LoadResult> GetCurrencyMasters(DataSourceLoadOptions loadOptions)
        {
            var result = await _mediator.Send(new CurrencySearchQuery(loadOptions));
            return result;
        }
        public async Task<Result> ImportCurrency(FileCommand command, SessionData session)
        {
            var result = await _mediator.Send(new ImportCurrencyCommand(command, session));
            return result;
        }
        public MemoryStream ExportCurrency(string fileName)
        {
            var result = _currencyRepository.GetCurrencies();
            return _excelExportService.Export(result, fileName);
        }
        #endregion
        #region create product category

        public async Task<Result> AddProductCategory(ProductCategoryCommand command)
        {
            var result = await _mediator.Send(new CreateProductCategoryCommand(command));
            return result;
        }
        public async Task<IEnumerable<ProductCategory>> GetUserProductCategories(string userId)
        {
            try
            {
                var result = await _mediator.Send(new GetAllUserProductsCategoryQuery(userId));
                return result;
            }
            catch (Exception ex)
            {
                return Enumerable.Empty<ProductCategory>();
            }

        }
        public async Task<IEnumerable<ProductCategory>> GetProductCategories()
        {
            try
            {
                var result = await _mediator.Send(new GetAllProductsCategoryQuery());
                return result;
            }
            catch (Exception ex)
            {
                return Enumerable.Empty<ProductCategory>();
            }

        }
        public async Task<IEnumerable<ProductCategory>> GetAllMG1()
        {
            try
            {
                var result = await _mediator.Send(new GetAllProductsCategoryQuery());
                return result;
            }
            catch (Exception ex)
            {
                return Enumerable.Empty<ProductCategory>();
            }

        }
        public async Task<Result> DeleteProductCategory(int productCategoryId, string updateBy)
        {
            var result = await _mediator.Send(new DeleteProductCategoryCommand(productCategoryId, updateBy));
            return result;
        }

        #endregion

        #region psiDates

        public async Task<LoadResult> GetPSIDateMasters(DataSourceLoadOptions loadOptions)
        {
            var result = await _mediator.Send(new PSIDatesSearchQuery(loadOptions));
            return result;
        }
        public async Task<Result> ImportPSIDates(FileCommand command, SessionData session)
        {
            var result = await _mediator.Send(new ImportPSIDatesCommand(command, session));
            return result;
        }
        public MemoryStream ExportPSIDates(string fileName)
        {
            var result = _psiDatesRepository.GetAll();
            List<PSIDatesResult> final = _mapper.Map<List<PSIDatesResult>>(result);
            return _excelExportService.Export(final, fileName);
        }
        #endregion

        #endregion

        #region trunoverDays master
        public async Task<LoadResult> GetTurnoverDaysMasters(DataSourceLoadOptions loadOptions)
        {
            var result = await _mediator.Send(new TurnoverDaysSearchQuery(loadOptions));
            return result;
        }
        public async Task<Result> ImportTurnoverDays(FileCommand command, SessionData session)
        {
            var result = await _mediator.Send(new ImportTurnoverDaysCommand(command, session));
            return result;
        }
        public MemoryStream ExportTurnoverDays(string fileName)
        {
            var data = _turnoverDaysRepository.GetTurnoverDays();
            var accounts = _accountRepository.GetAll();
            var result = data.Select(x => new TurnoverDaysResult
            {
                SubgroupCode = x.SubGroupProductCategoryCode,
                Month = x.Month,
                TurnoverDay = x.TurnoverDay,
                BPYear = x.BP_Year,
                GitDays = x.Git_Year,
                OACCode = accounts.Where(x => x.AccountId == (int)x.AccountId).Select(x => x.AccountCode).FirstOrDefault()
            }
          );
            return _excelExportService.Export(result.ToList(), fileName);
        }
        #endregion

        #region material
        public async Task<Result> AddMaterial(MaterialCommand command)
        {
            var result = await _mediator.Send(new CreateMaterialCommand(command));
            return result;
        }
        public async Task<List<MaterialView>> GetModelByCountryId(string countryId)
        {
            var result = _materialViewReopsitory.GetAll().Where(x => x.IsActive == true && x.CountryIds.Split(',').Any(c => c == countryId)).OrderBy(x => x.MaterialCode).ToList();
            return result;
        }
        public async Task<LoadResult> GetAllMaterial(DataSourceLoadOptions loadOptions)
        {
            var result = _materialViewReopsitory.GetAll();
            loadOptions.PrimaryKey = new[] { "MaterialId" };
            loadOptions.PaginateViaPrimaryKey = true;
            var results = DataSourceLoader.Load(result, loadOptions);
            return results;
        }

        public List<Material> GetMaterialByCategorySubCategories(int productCategoryId, List<int> productSubCategoryIds)
        {
            var results = _materialRepository.GetMaterialByCategorySubCategories(productCategoryId, productSubCategoryIds);
            return results;
        }
        public async Task<List<SP_MATERIALSEARCH>> GetMaterialByMG1MG2(MaterilSearch materilSearch)
        {
            var result = await _mediator.Send(new MaterialByMgSearchQuery(materilSearch));
            return result;

        }

        public MemoryStream ExportMaterial(string fileName)
        {
            var data = _materialViewReopsitory.GetAll();
            var result = data.Select(x => new MaterialResult
            {
                Company = x.CompanyName,
                Material = x.MaterialCode,
                Description = x.MaterialShortDescription,
                MG = x.ProductCategoryName1,
                MG1 = x.ProductCategoryName2,
                MG2 = x.ProductCategoryName3,
                MG3 = x.ProductCategoryName4,
                MG4 = x.ProductCategoryName5,
                MG5 = x.ProductCategoryName6,
                BarCode = x.BarCode,
                Weight = x.Weight,
                Volume = x.Volume,
                Supplier = x.SupplierName,
                SeaPort = x.SeaPortName,
                AirPort = x.AirPortName,
                Countries = x.CountryNames,
                IsActive = x.IsActive1,
                InSap = x.InSap1,
                CreatedBy = x.CreatedBy,
                CreatedDate = x.CreatedDate1,
                UpdateBy = x.UpdateBy,
                UpdateDate = x.UpdateDate1,

            });
            return _excelExportService.Export(result.ToList(), fileName);
        }
        #endregion

        #region supplier master
        public async Task<List<Supplier>> GetSuppliers()
        {
            var result = _supplierRepository.GetAll().Where(x => x.IsActive == true);
            return result.OrderBy(x => x.SupplierName).ToList();
        }
        #endregion

        #region seaport master
        public async Task<List<SeaPort>> GetSeaPorts()
        {
            var result = _seaPortRepository.GetAll().Where(x => x.IsActive == true);
            return result.OrderBy(x => x.SeaPortName).ToList();
        }
        #endregion

        #region airport master
        public async Task<List<AirPort>> GetAirPorts()
        {
            var result = _airPortRepository.GetAll().Where(x => x.IsActive == true);
            return result.OrderBy(x => x.AirPortName).ToList();
        }
        #endregion

        #region user Product Mapping
        public async Task<LoadResult> GetAllUser(DataSourceLoadOptions loadOptions, List<AppUsers> users)
        {

            var data = users.Select(x => new UserResult
            {
                Name = x.UserId == null ? "" : users.Where(z => z.UserId == x.UserId).Select(z => z.DisplayName).FirstOrDefault(),
                EmailId = x.UserId == null ? "" : users.Where(z => z.UserId == x.UserId).Select(z => z.UserPrincipalName).FirstOrDefault(),
                Role = x.UserId == null ? "" : UserListItemConvertWithCommaString(users, x.UserId),
                UserId = x.UserId,

            }); ;
            var result = DataSourceLoader.Load(data, loadOptions);
            return result;
        }
        public async Task<Result> MapUserProduct(UserProductMappingCommand command)
        {
            return await _mediator.Send(new CreateUserProductMappingCommand(command));
        }
        [Obsolete]
        public async Task<List<UserDepartmentCountryView>> GetUsersByCountryId(string? countryId)
        {
            var data = _userDepartmentCountryRepository.GetAll();
            if (data != null)
            {
                data = data.Where(x => x.CountryId != null && x.CountryId.Contains(countryId));
            }
            var users = _usersRepository.GetAll();
            var result = data.Select(x => new UserDepartmentCountryView
            {
                UserId = x.UserId,
                DepartmentId = x.DepartmentId,
                DepartmentName = x.DepartmentName,
                UserName = x.UserId == null ? "" : users.Where(z => z.UserId == x.UserId).Select(z => z.Name).FirstOrDefault(),
            });
            return result.DistinctBy(x => x.UserName).OrderBy(x => x.UserName).ToList();
        }

        public async Task<List<UserDepartmentCountryView>> GetUserByCountryId(string? countryId, List<Users> users)
        {
            var data = _userDepartmentCountryRepository.GetAll();
            if (data != null)
            {
                data = data.Where(x => x.CountryId != null && x.CountryId.Contains(countryId));
            }
            var result = data.Select(x => new UserDepartmentCountryView
            {
                UserId = x.UserId,
                DepartmentId = x.DepartmentId,
                DepartmentName = x.DepartmentName,
                UserName = users.FirstOrDefault(z => z.UserId == x.UserId)?.Name,
            });
            return result.DistinctBy(x => x.UserName).OrderBy(x => x.UserName).ToList();
        }

        public MemoryStream ExportUser(string fileName, List<AppUsers> users)
        {
            var data = _userViewProfileRepository.GetAll();
            var result = data.Select(x => new UserResult
            {
                Name = x.UserId == null ? "" : users.Where(z => z.UserId == x.UserId).Select(z => z.DisplayName).FirstOrDefault(),
                EmailId = x.UserId == null ? "" : users.Where(z => z.UserId == x.UserId).Select(z => z.UserPrincipalName).FirstOrDefault(),
                Role = x.UserId == null ? "" : UserListItemConvertWithCommaString(users, x.UserId),
                Department = x.DepartmentName,
                Country = x.CountryName,
                Product = x.ProductName,
            }); ;
            return _excelExportService.Export(result.Where(x => x.Name != null).ToList(), fileName);
        }
        public string UserListItemConvertWithCommaString(List<AppUsers> users, string userId)
        {
            string result = "";
            var data = users.Where(z => z.UserId == userId).Select(z => z.RoleList).ToList();
            if (data.Count() > 0)
            {
                result = string.Join(",", data[0].Select(x => x.DisplayName));
            }
            return result;
        }
        #endregion


        #region Customer master

        public async Task<Result> AddCustomer(CustomerCommand command)
        {
            var result = await _mediator.Send(new CreateCustomerCommand(command));
            return result;
        }
        public async Task<LoadResult> GetAllCoustomer(DataSourceLoadOptions loadOptions, List<Users> userlist)
        {

            var data = _context.VW_Customers.ToList();
            var result = data.Select(x => new VW_Customers
            {
                SalesOrganizationCode = x.SalesOrganizationCode,
                CustomerId = x.CustomerId,
                CustomerCode = x.CustomerCode,
                CustomerName = x.CustomerName,
                CustomerShortName = x.CustomerShortName,
                EmailId = x.EmailId,
                RegionId = x.RegionId,
                RegionName = x.RegionName,
                DepartmentId = x.DepartmentId,
                DepartmentName = x.DepartmentName,
                CountryId = x.CountryId,
                CountryName = x.CountryName,
                SalesOfficeId = x.SalesOfficeId,
                SalesOfficeName = x.SalesOfficeName,
                PersonInChargeId = x.PersonInChargeId,
                IsBP = x.IsBP,
                IsPSI = x.IsPSI,
                IsCollabo = x.IsCollabo,
                IsActive = x.IsActive,
                UpdateDate = x.UpdateDate,
                CreatedDate = x.CreatedDate,
                UpdateDate1 = x.UpdateDate1,
                CreatedDate1 = x.CreatedDate1,
                CreatedBy = x.CreatedBy,
                UpdateBy = x.UpdateBy,
                SalesTypeNames = x.SalesTypeNames == null ? "" : string.Join(",", x.SalesTypeNames.Split(',').Distinct().Select(v => v.ToString())),
                SalesTypeIds = x.SalesTypeIds,
                AccountId = x.AccountId,
                PersonInChargeName = x.PersonInChargeId == null ? "" : userlist.Where(z => z.UserId == x.PersonInChargeId).Select(z => z.Name).FirstOrDefault(),
                CurrencyCode = x.CurrencyCode
            });
            loadOptions.PrimaryKey = new[] { "CustomerId" };
            loadOptions.PaginateViaPrimaryKey = true;
            var results = DataSourceLoader.Load(result, loadOptions);
            return results;
        }
        public MemoryStream ExportCustomer(string fileName)
        {

            var data = _customerViewReopsitory.GetAll();
            var result = data.Select(x => new CustomerResult
            {
                CustomerCode = x.CustomerCode,
                CustomerName = x.CustomerName,
                ShortName = x.CustomerShortName,
                Region = x.RegionName,
                Department = x.DepartmentName,
                Country = x.CountryName,
                SalesOffice = x.SalesOfficeName,
                PIC = x.PersonInChargeName,
                PSI = x.IsPSI,
                BP = x.IsBP,
                IsActive = x.IsActive,
                CreatedBy = x.CreatedBy,
                CreatedDate = x.CreatedDate1,
                UpdateBy = x.UpdateBy,
                UpdateDate = x.UpdateDate1,
                Type = x.SalesTypeNames,
            }
          );
            return _excelExportService.Export(result.ToList(), fileName);
        }
        public async Task<List<Customer>> GetCustomers()
        {
            var data = _customerRepository.GetCustomers();
            return data;
        }
        public async Task<List<Customer>> GetCollaboNonCollaboCustomers(bool? customerType)
        {
            var data = _customerRepository.GetCollaboNonCollaboCustomers(customerType);
            return data;
        }
        public async Task<List<CustomerView>> GetCustomersByInchargeByCountryIds(List<int> countryId, string personIncharge, bool isSupeAdmin, string userId)
        {
            if (isSupeAdmin == true)
            {
                personIncharge = null;
                if (countryId.Count() == 0)
                {
                    countryId = _countryRepository.GetAllCountry().Select(x => x.CountryId).ToList();
                }
            }
            else
            {
                if (countryId.Count() == 0)
                {
                    countryId = _userViewProfileRepository.GetAll().Where(x => x.UserId == userId).Select(x => x.CountryId).Distinct().ToList();
                }
            }
            var data = _customerViewReopsitory.GetCustomersByInchargeByCountryIds(countryId, personIncharge).ToList();
            return data;
        }
        public async Task<List<CustomerView>> GetCollaboNonCollaboCustomersByInchargeByCountryIds(List<int> countryId, bool? customerType, string personIncharge, bool isSupeAdmin, string userId, string? saleTypeName)
        {
            try
            {
                if (isSupeAdmin == true)
                {
                    personIncharge = null;
                    if (countryId.Count() == 0)
                    {
                        countryId = _countryRepository.GetAllCountry().Select(x => x.CountryId).ToList();
                    }
                }
                else
                {
                    if (countryId.Count() == 0)
                    {
                        countryId = _userViewProfileRepository.UserProfileByUserId(userId).Select(x => x.CountryId).Distinct().ToList();
                    }
                }
                var data = _customerViewReopsitory.GetCollaboNonCollaboCustomersByInchargeByCountryIds(countryId, customerType, personIncharge).ToList();
                if (saleTypeName != "null")
                {
                    data = data.Where(x => x.SalesTypeNames != null && x.SalesTypeNames.Split(",").Any(c => saleTypeName.Contains(c))).ToList();

                }

                return data;
            }
            catch (Exception ex)
            {
                return new List<CustomerView>();

            }
        }
        public async Task<List<Customer>> GetCollaboNonCollaboCustomersByIncharge(bool? customerType, string personIncharge)
        {
            var data = _customerRepository.GetCollaboNonCollaboCustomersByIncharge(customerType);
            return data;
        }
        public async Task<List<Customer>> GetCollaboandSNSCustomers(int saleTypeId)
        {
            var data = _customerRepository.GetCollaboNonCollaboCustomersByIncharge(true);
            List<string> accounts = _accountRepository.GetAll().Where(x => x.IsActive == true).Select(x => x.AccountCode).ToList();
            if (saleTypeId == 1)
            {
                var res = data.Where(x => !accounts.Contains(x.CustomerCode)).ToList();
                return res;
            }
            else if (saleTypeId == 2)
            {
                var res = data.Where(x => accounts.Contains(x.CustomerCode)).ToList();
                return res;
            }
            return data;
        }

        public List<CustomerView> GetCustomersByAccount(int accountId)
        {
            var data = _customerViewReopsitory.GetCustomersByAccount(accountId);
            return data;
        }
        #endregion

        #region salesoffice master
        public async Task<List<SalesOffice>> GetSaleOffices()
        {
            var data = _salesOfficeRepository.GetAll();
            return data.Where(X => X.IsActive == true).OrderBy(x => x.SalesOfficeName).ToList();
        }
        #endregion

        #region saletype master
        public async Task<List<SaleType>> GetSaleTypes()
        {
            var data = _saleTypeRepository.GetAll();
            return data.Where(X => X.IsActive == true).OrderBy(x => x.SaleTypeName).ToList();
        }
        #endregion
        #region DashMaster

        public async Task<LoadResult> GetDashMasters(DataSourceLoadOptions loadOptions)
        {
            var result = await _mediator.Send(new DashMasterSearchQuery(loadOptions));
            return result;
        }
        public async Task<LoadResult> GetDashMastersBP(DataSourceLoadOptions loadOptions)
        {
            var result = await _mediator.Send(new DashMasterBPSearchQuery(loadOptions));
            return result;
        }
        public async Task<LoadResult> GetDashMasterMonthly(DataSourceLoadOptions loadOptions)
        {
            var result = await _mediator.Send(new DashMonthlySearchQuery(loadOptions));
            return result;
        }
        #endregion
        #region LockPSI
        [Obsolete]
        public async Task<Result> AddPSI(LockPSICommand command, SessionData session)
        {
            var result = await _mediator.Send(new CreateLockPSICommand(command, session));
            return result;
        }
        [Obsolete]
        public async Task<LockPSI> CheckLockPSIByUserId(
            string? userId, string? serachItem)
        {

            var result = await _mediator.Send(new PSILockSearchQuery(userId, serachItem));
            return result;
        }
        [Obsolete]
        public async Task<LoadResult> GetLockPSI(DataSourceLoadOptions loadOptions, PSILockSearchItems obj, string userId)
        {
            var result = await _mediator.Send(new PSILockSearchGridQuery(loadOptions, obj));
            return result;
        }
        public LoadResult GetLockPSIList(DataSourceLoadOptions loadOptions,
            PSILockSearchItems obj,
            string userId)
        {

            var dbResult = _psiLockRepo.GetAll(obj);
            var result = DataSourceLoader.Load(dbResult, loadOptions);
            return result;

        }

        public Result AddUpdateLockPSI(IEnumerable<LockPSI> command, string userId, string loggedInUser)
        {
            var result = _psilockTableRepo.UpdateOrInsertLockPSI(command, userId, loggedInUser);
            return result;
        }
        public async Task<Result> UpdateOrInsertAllLockUser(bool isBlock, string loggedInUser)
        {
            try
            {
                var result = await _context.SP_ResponseResult.FromSql($"SP_LOCKALLUSER {loggedInUser},{isBlock}").AsNoTracking().ToListAsync();
                if (result.Count() == 0)
                {
                    return Result.Success;
                }
                Log.Error($"Execption occured while LOCK PSI {result}");
                return Result.Failure("Problem in Lock PSI ,try later");
            }
            catch(Exception ex)
            {
                Log.Error($"Execption occured while LOCK PSI");
                return Result.Failure("Problem in Lock PSI ,try later");
            }

        }
        #endregion

        #region global config
        public async Task<string> GetGlobalConfigByKey(string? type)
        {

            type = type == "BP" ? "BP_Year" : type;
            var result = _globalConfigRepository.GetGlobalConfigByKey(type);
            return result;
        }
        public IEnumerable<GlobalConfig> GetGlobalConfig()
        {
            return _globalConfigRepository.GetAll();

        }

        public void UpdateGlobalConfig(string salesTypes)
        {
            var salesType = new SqlParameter("@SalesType", SqlDbType.NVarChar, 10);
            salesType.Value = salesTypes;
            var param = new SqlParameter[] {
                salesType
            };
            var result = _context.SP_GLOBALCONFIG_MONTH.FromSqlRaw("dbo.SP_GLOBALCONFIG_MONTH @SalesType", param).AsNoTracking().ToList();

        }
        #endregion

        #region sales organization
        public async Task<List<SalesOrganization>> GetSalesOrganization()
        {
            var result = _salesOrganizationRepository.GetAllSalesOrganization();
            return result.ToList();
        }
        #endregion


        public async Task<List<CustomerView>> GetCustomersByInchargeByCountryIdsOAC(List<int> countryId, string personIncharge, bool isSupeAdmin, string userId, string? accountCode)
        {
            try
            {
                if (isSupeAdmin == true)
                {
                    personIncharge = null;
                    if (countryId.Count() == 0)
                    {
                        countryId = _countryRepository.GetAllCountry().Select(x => x.CountryId).ToList();
                    }
                }
                else
                {
                    if (countryId.Count() == 0)
                    {
                        countryId = _userViewProfileRepository.GetAll().Where(x => x.UserId == userId).Select(x => x.CountryId).Distinct().ToList();
                    }
                }


                string type = Convert.ToString((int)SaleTypeEnum.SNS);
                var data = _customerViewReopsitory.GetAll().Where(x => x.IsActive == true && x.AccountId == Convert.ToInt16(accountCode) &&
                (x.SalesTypeIds != null && x.SalesTypeIds.Split(",").Any(c => type.Contains(c)))).ToList();
                if (data != null)
                {
                    data = data.Where(x => x.CountryId != null && countryId.Contains((int)x.CountryId)).ToList();
                }
                return data;

            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public async Task<List<Users>> GetUsers()
        {
            var result = _usersRepository.GetUserActive().OrderBy(x => x.Name).ToList();
            return result;
        }
        public async Task<Result> AddReportVariant(ReportCommand command)
        {

            var result = await _mediator.Send(new CreateReportCommand(command));
            return result;
        }
    }
}
