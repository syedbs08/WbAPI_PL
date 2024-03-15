

using AttachmentService.Command;
using Core.BaseUtility.Utility;
using DevExtreme.AspNet.Data.ResponseModel;
using PSI.Domains.Entity;
using PSI.Modules.Backends.DirectSales.Command;
using PSI.Modules.Backends.Masters.Command.AccountMaster;
using PSI.Modules.Backends.Masters.Command.CompanyMaster;
using PSI.Modules.Backends.Masters.Command.CountryMaster;
using PSI.Modules.Backends.Masters.Command.CustomerMaster;
using PSI.Modules.Backends.Masters.Command.Department;
using PSI.Modules.Backends.Masters.Command.LockPSIMaster;
using PSI.Modules.Backends.Masters.Command.MaterialMaster;
using PSI.Modules.Backends.Masters.Command.ProductCategoryMaster;
using PSI.Modules.Backends.Masters.Command.RegionMaster;
using PSI.Modules.Backends.Masters.Command.Report;
using PSI.Modules.Backends.Masters.Command.UserDepartmentMaster;
using PSI.Modules.Backends.Masters.Command.UserProductMap;
using PSI.Modules.Backends.Masters.Queries.MaterialMaster;
using PSI.Modules.Backends.Masters.Queries.PSILockMaster;
using PSI.Modules.Backends.Masters.Results;
using SessionManagers.Results;

namespace PSI.Modules.Backends.Masters.Services
{
    public interface IMasterService
    {
        #region Account
        Task<Result> AddAccount(AccountCommand command);
        Task<List<Account>> GetAccounts();
        Task<List<FCPLCompany>> GetFCPLCompany();

        Task<Account> GetAccount(string accountCode, string accountName);
        #endregion

        #region company
        Task<Result> AddCompany(CompanyCommand command);
        Task<LoadResult> GetCompanyMasters(DataSourceLoadOptions loadOptions);
        Task<Result> DeleteCompany(int companyId, string updateBy);
        Task<List<Company>> GetCompany();
        MemoryStream ExportCompany(string fileName);
        #endregion

        #region Country master        
        Task<Result> AddCountry(CountryCommand command);
        Task<IEnumerable<Country>> GetAllCountry();
        Task<IEnumerable<Country>> GetCountryByDepartment(string? departmentId);
        Task<LoadResult> GetCountry(DataSourceLoadOptions loadOptions);
        Task<Country> GetCountry(string accountCode, string accountName);
        Task<Result> DeleteCountry(int countryId, string updateBy);
        #endregion

        #region Department Master
        Task<Result> AddDepartment(DepartmentCommand command);
        Task<LoadResult> GetDepartment(DataSourceLoadOptions loadOptions);
        Task<Department> GetDepartment(string departmentCode, string departmentName);
        Task<Result> DeleteDepartment(int departmentId, string updateBy);
        Task<Result> MapUserDepartment(UserDepartmentMappingCommand command);
        Task<IEnumerable<UserProfileView>> UserDepartmentMappLookups(string userId);
        Task<IEnumerable<DepartmentLookupCommand>> DepartmentLookups();
        #endregion

        #region Region master
        Task<Result> AddRegion(RegionCommand command);
        Task<LoadResult> GetRegionMasters(DataSourceLoadOptions loadOptions);
        Task<List<Region>> GetRegions();
        Task<Result> DeleteRegion(int regionId, string updateBy);
        MemoryStream ExportRegion(string fileName);
        #endregion
        #region currency master
        Task<List<Currency>> GetCurrency();
        Task<LoadResult> GetCurrencyMasters(DataSourceLoadOptions loadOptions);
        Task<Result> ImportCurrency(FileCommand command, SessionData session);
        MemoryStream ExportCurrency(string fileName);
        #endregion

        #region productcategory master
        Task<Result> AddProductCategory(ProductCategoryCommand command);
        Task<IEnumerable<ProductCategory>> GetProductCategories();
        Task<IEnumerable<ProductCategory>> GetUserProductCategories(string userId);
        Task<IEnumerable<ProductCategory>> GetAllMG1();
        Task<Result> DeleteProductCategory(int productCategoryId, string updateBy);
        #endregion

        #region psidates master
        Task<LoadResult> GetPSIDateMasters(DataSourceLoadOptions loadOptions);
        Task<Result> ImportPSIDates(FileCommand command, SessionData session);
        MemoryStream ExportPSIDates(string fileName);
        #endregion

        #region turnoverdays master
        Task<LoadResult> GetTurnoverDaysMasters(DataSourceLoadOptions loadOptions);
        Task<Result> ImportTurnoverDays(FileCommand command, SessionData session);
        MemoryStream ExportTurnoverDays(string fileName);
        #endregion

        #region material master
        Task<Result> AddMaterial(MaterialCommand command);
        Task<List<MaterialView>> GetModelByCountryId(string countryId);
        Task<LoadResult> GetAllMaterial(DataSourceLoadOptions loadOptions);
        List<Material> GetMaterialByCategorySubCategories(int productCategoryId, List<int> productSubCategoryIds);
        Task<List<SP_MATERIALSEARCH>> GetMaterialByMG1MG2(MaterilSearch materilSearch);
        MemoryStream ExportMaterial(string fileName);
        #endregion

        #region supplier master
        Task<List<Supplier>> GetSuppliers();
        #endregion

        #region seaport master
        Task<List<SeaPort>> GetSeaPorts();
        #endregion

        #region airport master
        Task<List<AirPort>> GetAirPorts();
        #endregion

        #region user Product mapping        
        Task<Result> MapUserProduct(UserProductMappingCommand command);
        MemoryStream ExportUser(string fileName, List<AppUsers> users);
        #endregion
        #region DashMaster
        Task<LoadResult> GetDashMasters(DataSourceLoadOptions loadOptions);
        Task<LoadResult> GetDashMastersBP(DataSourceLoadOptions loadOptions);
        Task<LoadResult> GetDashMasterMonthly(DataSourceLoadOptions loadOptions);
        #endregion

        #region customer master
        Task<Result> AddCustomer(CustomerCommand command);
        Task<LoadResult> GetAllCoustomer(DataSourceLoadOptions loadOptions, List<Users> userlist);
        MemoryStream ExportCustomer(string fileName);
        Task<List<Customer>> GetCustomers();
        Task<List<Customer>> GetCollaboNonCollaboCustomers(bool? customerType);
        Task<List<CustomerView>> GetCollaboNonCollaboCustomersByInchargeByCountryIds(List<int> countryId, bool? customerType, string personIncharge,bool isSupeAdmin, string userId, string? saleTypeName);
        Task<List<CustomerView>> GetCustomersByInchargeByCountryIds(List<int> countryId, string personIncharge,bool isSupeAdmin, string userId);
        Task<List<Customer>> GetCollaboNonCollaboCustomersByIncharge(bool? customerType, string personIncharge);
        Task<List<Customer>> GetCollaboandSNSCustomers(int saleTypeId);
        List<CustomerView> GetCustomersByAccount(int accountId);
        #endregion

        #region salesoffice master
        Task<List<SalesOffice>> GetSaleOffices();
        #endregion

        #region saletype master
        Task<List<SaleType>> GetSaleTypes();
        #endregion
        #region user department country
        Task<LoadResult> GetAllUser(DataSourceLoadOptions loadOptions, List<AppUsers> userlist);
        [Obsolete]
        Task<List<UserDepartmentCountryView>> GetUsersByCountryId(string? countryId);
        Task<List<UserDepartmentCountryView>> GetUserByCountryId(string? countryId, List<Users> users);
        #endregion
        #region LockPSI
        Task<Result> AddPSI(LockPSICommand command, SessionData session);
        Task<LockPSI> CheckLockPSIByUserId(string? userId, string? serachItem);
        Task<LoadResult> GetLockPSI(DataSourceLoadOptions loadOptions, PSILockSearchItems pSILockSearcDataQuery, string userId);
        LoadResult GetLockPSIList(DataSourceLoadOptions loadOptions,
            PSILockSearchItems obj,
            string userId);

        Result AddUpdateLockPSI(IEnumerable<LockPSI> command, string userId, string loggedInUser);
       Task<Result> UpdateOrInsertAllLockUser(bool IsBlock, string loggedInUser);
        #endregion

        #region global config
        Task<string> GetGlobalConfigByKey(string? type);
        IEnumerable<GlobalConfig> GetGlobalConfig();
       void UpdateGlobalConfig(string salesTypes);
        #endregion

        #region sales organization
        Task<List<SalesOrganization>> GetSalesOrganization();
        #endregion

        Task<List<CustomerView>> GetCustomersByInchargeByCountryIdsOAC(List<int> countryId, string personIncharge, bool isSupeAdmin, string userId, string? accountCode);
        Task<List<Users>> GetUsers();
        Task<Result> AddReportVariant(ReportCommand command);

    }
}
