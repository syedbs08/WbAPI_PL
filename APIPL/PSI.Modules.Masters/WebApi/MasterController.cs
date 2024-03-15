
using AttachmentService.Command;
using Microsoft.AspNetCore.Mvc;
using PSI.Modules.Backends.Masters.Command.AccountMaster;
using PSI.Modules.Backends.Masters.Command.CompanyMaster;
using PSI.Modules.Backends.Masters.Command.CountryMaster;
using PSI.Modules.Backends.Masters.Command.RegionMaster;
using PSI.Modules.Backends.Masters.Command.Department;
using PSI.Modules.Backends.Masters.Services;
using SessionManagers.AuthorizeService.services;
using System.Net;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Command.ProductCategoryMaster;
using PSI.Modules.Backends.WebApi.Results;
using AutoMapper;
using PSI.Modules.Backends.Constants;
using PSI.Modules.Backends.Masters.Command.MaterialMaster;
using PSI.Modules.Backends.Masters.Command.UserProductMap;
using DevExtreme.AspNet.Data;
using PSI.Modules.Backends.Masters.Command.CustomerMaster;
using PSI.Modules.Backends.Masters.Command.UserDepartmentMaster;
using SessionManagers.AuthorizeService.Services;
using SessionManagers.Results;
using PSI.Modules.Backends.WebApi.Command;
using Newtonsoft.Json;
using static PSI.Modules.Backends.Constants.Contants;
using PSI.Modules.Backends.Masters.Repository.UserViewProfile;
using Microsoft.AspNetCore.Authorization;
using PSI.Modules.Backends.Masters.Repository.CountryMaster;
using PSI.Modules.Backends.Masters.Results;
using PSI.Modules.Backends.Masters.Queries.PSILockMaster;
using PSI.Modules.Backends.Masters.Command.LockPSIMaster;
using PSI.Modules.Backends.Masters.Queries.MaterialMaster;
using PSI.Modules.Backends.Masters.Command.Report;

namespace PSI.Modules.Backends.WebApi
{
    [Authorize]
    [Route("api/v1/masters")]

    public class MasterController : SessionServiceBase
    {
        private readonly IMasterService _masterServices;
        private readonly IAzureAppServices _azureAppServices;
        private readonly IMapper _mapper;
        private readonly IUserViewProfileRepository _userViewProfileRepository;
        private readonly ICountryRepository _countryRepository;
        public MasterController(IMasterService masterServices, IMapper mapper,
            IAzureAppServices azureAppServices,
            IUserViewProfileRepository userViewProfileRepository,
            ICountryRepository countryRepository)
        {
            _masterServices = masterServices;
            _mapper = mapper;
            _azureAppServices = azureAppServices;
            _userViewProfileRepository = userViewProfileRepository;
            _countryRepository = countryRepository;
        }
        [HttpGet]

        [Route("status")]
        public IActionResult GetStatus()
        {
            return Ok("master api called sucessfully");
        }
        /// <summary>
       #region Account master
        /// </summary>
        /// <returns></returns>
        // POST: api/v1/masters/add-account
        [HttpPost]
        [Route("add-account")]
        public async Task<IActionResult> AddAccount([FromBody] AccountCommand command)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);

            }
            var result = await _masterServices.AddAccount(command);
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok();
        }
        [HttpGet]
        [Route("get-account")]
        public async Task<IActionResult> GetAccounts()
        {
            var result = await _masterServices.GetAccounts();
            return Ok(result.OrderBy(x => x.AccountName));
        }

        [HttpGet]
        [Route("get-FCPLCompany")]
        public async Task<IActionResult> GetFCPLCompany()
        {
            var result = await _masterServices.GetFCPLCompany();
            return Ok(result.OrderBy(x => x.COMPANY_NAME));
        }
        #endregion

        #region Country Master
        [HttpGet]
        [Route("get-allcountry")]
        public async Task<IActionResult> GetCountryAll()
        {
            return Ok(await _masterServices.GetAllCountry());
        }
        [HttpGet]
        [Route("get-country-by-department/{departmentId}")]
        public async Task<IActionResult> GetCountryByDepartment(string? departmentId)
        {
            var res = await _masterServices.GetCountryByDepartment(departmentId);
            return Ok(res);
        }
        [HttpGet]
        [Route("get-country")]
        public async Task<IActionResult> GetCountry(string accountCode, string accountName)
        {
            var result = await _masterServices.GetCountry(accountCode, accountName);
            return Ok(result);
        }
        [Authorize]
        [HttpGet]
        [Route("get-user-country")]
        public async Task<IActionResult> GetUserCountryList()
        {

            if (SessionMain == null || string.IsNullOrWhiteSpace(SessionMain.ADUserId)
                     || !SessionMain.Roles.Any())
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            bool isSupeAdmin = SessionMain.Roles.Contains(Contants.ADMIN_ROLE);
            var result = _userViewProfileRepository.GetUserCountry(SessionMain.ADUserId,
                isSupeAdmin, _countryRepository);
            return Ok(result);
        }
        [HttpGet]
        [Route("country-master")]
        public async Task<IActionResult> GetCountryList(DataSourceLoadOptions loadOptions)
        {
            var result = await _masterServices.GetCountry(loadOptions);
            return Ok(result);
        }

        //[HttpPost]
        //[Route("get-countryList")]
        //public async Task<IActionResult> GetCountryList([FromBody] PagingRequest paging)
        //{
        //    var result = await _masterServices.GetCountry(paging);
        //    return Ok(result);
        //}


        [HttpPost]
        [Route("add-country")]
        public async Task<IActionResult> AddCountry([FromBody] CountryCommand command)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _masterServices.AddCountry(command);
            if (!result.IsSuccess)
            {
                return BadRequest(result.Errors);
            }
            return Ok();
        }

        [HttpDelete]
        [Route("delete-country/{countryId}")]
        public async Task<IActionResult> DeleteCountry(int countryId)
        {
            if (countryId < 0)
            {
                return NotFound();
            }
            var result = await _masterServices.DeleteCountry(countryId, SessionMain.ADUserId);
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok();
        }
        #endregion

        #region Department Master

        //[HttpPost]
        //[Route("get-departmentList")]
        //public async Task<IActionResult> GetDepartmentList([FromBody] PagingRequest paging)
        //{
        //    var result = await _masterServices.GetDepartment(paging);
        //    return Ok(result);
        //}
        [HttpGet]
        [Route("department-master")]
        public async Task<IActionResult> GetDepartmentList(DataSourceLoadOptions loadOptions)
        {
            var result = await _masterServices.GetDepartment(loadOptions);
            return Ok(result);
        }

        [HttpPost]
        [Route("add-department")]
        public async Task<IActionResult> AddDepartment([FromBody] DepartmentCommand command)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            if (command.DepartmentId > 0)
            {
                command.UpdateBy = SessionMain.ADUserId;
            }
            else
            {
                command.CreatedBy = SessionMain.ADUserId;
            }
            var result = await _masterServices.AddDepartment(command);
            if (!result.IsSuccess)
            {
                return BadRequest(result.Errors);
            }
            return Ok();
        }


        [HttpDelete]
        [Route("delete-department/{departmentId}")]
        public async Task<IActionResult> DeleteDepartment(int departmentId)
        {
            if (departmentId < 0)
            {
                return NotFound();
            }
            var result = await _masterServices.DeleteDepartment(departmentId, SessionMain.ADUserId);
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok();
        }
        [HttpGet]
        [Route("get-departmentlookUp")]
        public async Task<IActionResult> GetDepartmentLookUp()
        {
            var result = await _masterServices.DepartmentLookups();
            return Ok(result);
        }
        #endregion

        #region Company


        [HttpGet]
        [Route("get-companies")]
        public async Task<IActionResult> GetCompany()
        {
            var result = await _masterServices.GetCompany();
            return Ok(result);
        }
        [HttpGet]
        [Route("company-master")]
        public async Task<IActionResult> GetCompanyMasters(DataSourceLoadOptions loadOptions)
        {
            var result = await _masterServices.GetCompanyMasters(loadOptions);
            return Ok(result);
        }
        [HttpPost]
        [Route("add-company")]
        public async Task<IActionResult> AddCompany([FromBody] CompanyCommand command)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _masterServices.AddCompany(command);
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok();
        }
        [HttpDelete]
        [Route("delete-company/{companyId}")]
        public async Task<IActionResult> DeleteCompany(int companyId)
        {
            if (companyId < 0)
            {
                return NotFound();
            }
            var result = await _masterServices.DeleteCompany(companyId, SessionMain.ADUserId);
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok();
        }
        [HttpGet]
        [Route("export-company/{fileName}")]
        public IActionResult ExportCompany(string fileName = "Excelfile")
        {
            var result = _masterServices.ExportCompany(fileName);
            return File(result, Contants.EXCEL_MEDIA_TYPE);

        }
        #endregion

        #region Region Master
        [HttpGet]
        [Route("region-master")]
        public async Task<IActionResult> GetRegionMasters(DataSourceLoadOptions loadOptions)
        {
            var result = await _masterServices.GetRegionMasters(loadOptions);
            return Ok(result);
        }
        [HttpGet]
        [Route("get-regions")]
        public async Task<IActionResult> GetRegions()
        {
            var result = await _masterServices.GetRegions();
            return Ok(result);
        }
        [HttpPost]
        [Route("add-region")]
        public async Task<IActionResult> AddRegion([FromBody] RegionCommand command)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            command.UpdateBy = SessionMain.ADUserId;
            command.CreatedBy = SessionMain.ADUserId;
            var result = await _masterServices.AddRegion(command);
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok();
        }

        [HttpDelete]
        [Route("delete-region/{regionId}")]
        public async Task<IActionResult> DeleteRegion(int regionId)
        {
            if (regionId < 0)
            {
                return NotFound();
            }
            var result = await _masterServices.DeleteRegion(regionId, SessionMain.ADUserId);
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok();
        }
        [HttpGet]
        [Route("export-region/{fileName}")]
        public IActionResult ExportRegion(string fileName = "Excelfile")
        {
            var result = _masterServices.ExportRegion(fileName);
            return File(result, Contants.EXCEL_MEDIA_TYPE);

        }
        #endregion
        #region Currency Master
        [HttpGet]
        [Route("get-currency")]
        public async Task<IActionResult> GetCurrency()
        {
            var result = await _masterServices.GetCurrency();
            return Ok(result);
        }
        [HttpGet]
        [Route("currency-master")]
        public async Task<IActionResult> GetCurrencyMasters(DataSourceLoadOptions loadOptions)
        {
            var result = await _masterServices.GetCurrencyMasters(loadOptions);
            return Ok(result);
        }

        [Route("currency-import")]
        [HttpPost, DisableRequestSizeLimit]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> ImportCurrency(FileCommand command)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            var result = await _masterServices.ImportCurrency(command, SessionMain);
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok();
        }

        [HttpGet]
        [Route("export-currency/{fileName}")]
        public IActionResult ExportCurrency(string fileName = "Excelfile")
        {
            var result = _masterServices.ExportCurrency(fileName);
            return File(result, Contants.EXCEL_MEDIA_TYPE);

        }
        #endregion

        #region productcategory  Master
        [HttpGet]
        [Route("productcategories")]
        public async Task<IActionResult> GetProductCategories()
        {
            var result = await _masterServices.GetProductCategories();
            List<ProductCategory> data = result.OrderBy(x => x.ProductCategoryCode).ToList();
            List<ProductCategoryTreeItem> final = _mapper.Map<List<ProductCategoryTreeItem>>(data);
            return Ok(final);
        }
        [HttpGet]
        [Route("get-mg1")]
        public async Task<IActionResult> GetAllMG1()
        {
            var result = await _masterServices.GetAllMG1();
            List<ProductCategory> data = result.Where(x => x.CategoryLevel == 2).OrderBy(x => x.ProductCategoryCode).ToList();
            List<ProductCategoryTreeItem> final = _mapper.Map<List<ProductCategoryTreeItem>>(data);
            return Ok(final);
        }


        [HttpGet]

        [Route("user-productcategories")]
        public async Task<IActionResult> GetProductCategoriesByUser()
        {
            if (SessionMain == null || string.IsNullOrWhiteSpace(SessionMain.ADUserId)
                     || !SessionMain.Roles.Any())
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            var result = await _masterServices.GetUserProductCategories(SessionMain.ADUserId);
            List<ProductCategoryTreeItem> final = _mapper.Map<List<ProductCategoryTreeItem>>(result);
            return Ok(final);
        }
        [HttpPost]
        [Route("add-product-category")]
        public async Task<IActionResult> AddProductCategory([FromBody] ProductCategoryCommand command)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            if (SessionMain == null || string.IsNullOrWhiteSpace(SessionMain.ADUserId)
                      || !SessionMain.Roles.Any())
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            if (command.ProductCategoryId > 0)
            {
                command.UpdateBy = SessionMain.ADUserId;
            }
            else
            {
                command.CreatedBy = SessionMain.ADUserId;
            }
            var result = await _masterServices.AddProductCategory(command);
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok();
        }

        #endregion

        #region Turnoverdays Master
        [HttpGet]
        [Route("trunoverday-master")]
        public async Task<IActionResult> GetTurnoverDaysMaster(DataSourceLoadOptions loadOptions)
        {
            var result = await _masterServices.GetTurnoverDaysMasters(loadOptions);
            return Ok(result);
        }
        [HttpPost]
        [Route("turnoverdays-import")]
        [HttpPost, DisableRequestSizeLimit]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> ImportTurnoverdays(FileCommand command)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            command.FileTypeId = (int)FileTypeEnum.TurnoverDays;
            var result = await _masterServices.ImportTurnoverDays(command, SessionMain);
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok();
        }

        [HttpGet]
        [Route("export-turnoverdays/{fileName}")]
        public IActionResult ExportTurnoverdays(string fileName = "Excelfile")
        {
            var result = _masterServices.ExportTurnoverDays(fileName);
            return File(result, Contants.EXCEL_MEDIA_TYPE);

        }
        #endregion

        #region PSIDates Master

        [HttpGet]
        [Route("psidate-master")]
        public async Task<IActionResult> GetPSIDateMaster(DataSourceLoadOptions loadOptions)
        {
            var result = await _masterServices.GetPSIDateMasters(loadOptions);
            return Ok(result);
        }

        [Route("psidates-import")]
        [HttpPost, DisableRequestSizeLimit]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> ImportPSIDates(FileCommand command)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            command.FileTypeId = (int)FileTypeEnum.PSIDates;
            var result = await _masterServices.ImportPSIDates(command, SessionMain);
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok();
        }

        [HttpGet]
        [Route("export-psidates/{fileName}")]
        public IActionResult ExportPSIDates(string fileName = "Excelfile")
        {
            var result = _masterServices.ExportPSIDates(fileName);

            return File(result, Contants.EXCEL_MEDIA_TYPE);

        }
        #endregion

        #region material master

        [HttpGet]
        [Route("export-material/{fileName}")]
        public IActionResult ExportMaterials(string fileName = "Excelfile")
        {
            var result = _masterServices.ExportMaterial(fileName);

            return File(result, Contants.EXCEL_MEDIA_TYPE);

        }
        [HttpPost]
        [Route("add-material")]
        public async Task<IActionResult> AddMaterial([FromBody] MaterialCommand command)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            if (SessionMain == null || string.IsNullOrWhiteSpace(SessionMain.ADUserId)
                      || !SessionMain.Roles.Any())
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            if (command.MaterialId > 0)
            {
                command.UpdateBy = SessionMain.Name;
            }
            else
            {
                command.CreatedBy = SessionMain.Name;
            }
            var result = await _masterServices.AddMaterial(command);
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok();
        }
        [HttpGet]
        [Route("materials")]
        public async Task<IActionResult> GetMaterials(DataSourceLoadOptions loadOptions)
        {
            var result = await _masterServices.GetAllMaterial(loadOptions);
            return Ok(result);
        }
        [HttpGet]
        [Route("model-by-countryId/{countryId}")]
        public async Task<IActionResult> GetModelByCountryId(int? countryId)
        {
            List<MaterialView> data = await _masterServices.GetModelByCountryId(Convert.ToString(countryId));
            List<DropDownResult> result = _mapper.Map<List<DropDownResult>>(data);
            return Ok(result);
        }

        [HttpPost]
        [Route("get-materials-by-mg1-and-mg2")]
        public IActionResult GetMaterialByCategorySubCategories([FromBody] MaterilSearch materilSearch)
        {
            var result = _masterServices.GetMaterialByMG1MG2(materilSearch);
            return Ok(result.Result);
        }
        [HttpGet]
        [Route("get-materials-by-mg1-and-mg2/{mg1}/{mg2}")]
        public IActionResult GetMaterialBMG1MG2(int mg1, int? mg2)
        {
            MaterilSearch materilSearch = new MaterilSearch();
            materilSearch.MG1 = new List<int>();
            materilSearch.MG2 = new List<int?>();
            materilSearch.MG1.Add(mg1);
            if (mg2 != 0)
            {
                materilSearch.MG2.Add(mg2);
            }
            var result = _masterServices.GetMaterialByMG1MG2(materilSearch);
            return Ok(result.Result);
        }
        #endregion

        #region supplier master
        [HttpGet]
        [Route("get-suppliers")]
        public async Task<IActionResult> GetSuppliers()
        {
            var result = await _masterServices.GetSuppliers();
            return Ok(result);
        }
        #endregion

        #region seaport master
        [HttpGet]
        [Route("get-seaports")]
        public async Task<IActionResult> GetSeaPorts()
        {
            var result = await _masterServices.GetSeaPorts();
            return Ok(result);
        }
        #endregion

        #region airport master
        [HttpGet]
        [Route("get-airports")]
        public async Task<IActionResult> GetAirPorts()
        {
            var result = await _masterServices.GetAirPorts();
            return Ok(result);
        }
        #endregion


        #region RND

        [HttpGet]
        [Route("countries-devextream")]

        // use jsonObjec if need more than one param else use extra param
        public async Task<IActionResult> DevExtreamTest(DataSourceLoadOptions loadOptions, string extraParam, string jsonObject)
        {
            // ExtraParamCommand create for your won paramater
            var objects = JsonConvert.DeserializeObject<ExtraParamCommand>(jsonObject);
            //if (loadOptions.Filter != null)
            //{
            //    foreach (var p in loadOptions.Filter)
            //    {
            //        Console.WriteLine(p);
            //    }

            //}

            var result = await _masterServices.GetAllCountry();
            loadOptions.PrimaryKey = new[] { "CountryID" };
            loadOptions.PaginateViaPrimaryKey = true;
            var results = DataSourceLoader.Load(result, loadOptions);
            return Ok(results);
        }
        #endregion

        #region user Profile Mapping

        [HttpGet]
        [Route("get-userDepartmentmap/{userId}")]
        public async Task<IActionResult> getuserDepartmentmap(string userId)
        {
            var result = await _masterServices.UserDepartmentMappLookups(userId);
            var groupedResult = result.GroupBy(c => new
            {
                c.DepartmentCode,
                c.DepartmentId,
                c.DepartmentName,
            })
             .Select(gcs => new UserDepartmentMappingResult()
             {
                 DepartmentCode = gcs.Key.DepartmentCode,
                 DepartmentId = gcs.Key.DepartmentId,
                 DepartmentName = gcs.Key.DepartmentName,
                 CountryName = gcs.GroupBy(c => c.CountryName).Select(x => x.FirstOrDefault().CountryName).ToList()
             });
            return Ok(groupedResult);
        }
        [HttpPost]
        [Route("map-userDepartment")]
        public async Task<IActionResult> MapUserDepartment([FromBody] UserDepartmentMappingCommand command)
        {
            var result = await _masterServices.MapUserDepartment(command);
            if (!result.IsSuccess)
            {
                return BadRequest(result.Errors);

            }
            return Ok();
        }
        [Obsolete]
        [HttpGet]
        [Route("get-users-by-countryId/{countryId}")]
        public async Task<IActionResult> GetUsersByCountryId(int countryId)
        {

            var result = await _masterServices.GetUsersByCountryId(Convert.ToString(countryId));
            return Ok(result);
        }
        [HttpGet]
        [Route("active-users")]
        public async Task<IActionResult> GetUsers()
        {
            var result = await _masterServices.GetUsers();
            return Ok(result);
        }
        [HttpGet]
        [Route("get-users-country/{countryId}")]
        public async Task<IActionResult> GetUsersByCountry(int countryId)
        {
            var userlist = await _masterServices.GetUsers();
            var result = await _masterServices.GetUserByCountryId(Convert.ToString(countryId), userlist);
            return Ok(result);
        }

        [Obsolete]
        [HttpGet]
        [Route("app-users")]
        public async Task<IActionResult> GetUsers(DataSourceLoadOptions loadOptions)
        {
            List<AppUsers> userlist = _azureAppServices.GetUsers();
            var result = await _masterServices.GetAllUser(loadOptions, userlist);
            return Ok(result);
        }
        [HttpGet]
        [Route("app-users-all")]
        public async Task<IActionResult> GetAllUsers()
        {
            List<AppUsers> userlist = _azureAppServices.GetUsers();
            return Ok(userlist);
        }
        [HttpGet]
        [Route("app-users-groups")]
        public async Task<IActionResult> GetUsersByRoleAndGroup()
        {
            var userlist = _azureAppServices.GetUsersFromGraph();
            return Ok(userlist);
        }
        [HttpPost]
        [Route("map-userproduct")]
        public async Task<IActionResult> MapUserProduct([FromBody] UserProductMappingCommand command)
        {
            var result = await _masterServices.MapUserProduct(command);
            if (!result.IsSuccess)
            {
                return BadRequest(result.Errors);

            }
            return Ok();
        }
        [HttpGet]
        [Route("export-user/{fileName}")]
        public IActionResult ExportUser(string fileName = "Excelfile")
        {
            List<AppUsers> userlist = _azureAppServices.GetUsers();
            var result = _masterServices.ExportUser(fileName, userlist);
            return File(result, Contants.EXCEL_MEDIA_TYPE);

        }
        #endregion
        #region customer master

        [HttpGet]
        [Route("export-customer/{fileName}")]
        public IActionResult ExportCustomer(string fileName = "Excelfile")
        {
            var result = _masterServices.ExportCustomer(fileName);

            return File(result, Contants.EXCEL_MEDIA_TYPE);

        }
        [HttpPost]
        [Route("add-customer")]
        public async Task<IActionResult> AddCustomer([FromBody] CustomerCommand command)
        {
            ModelState.Remove("ModelIds");
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            if (SessionMain == null || string.IsNullOrWhiteSpace(SessionMain.ADUserId)
                      || !SessionMain.Roles.Any())
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            if (command.CustomerId > 0)
            {
                command.UpdateBy = SessionMain.Name;
            }
            else
            {
                command.CreatedBy = SessionMain.Name;
            }
            var result = await _masterServices.AddCustomer(command);
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok();
        }
        [HttpGet]
        [Route("customers")]
        public async Task<IActionResult> GetCustomer(DataSourceLoadOptions loadOptions)
        {
            try
            {
                List<Users> userlist = await _masterServices.GetUsers();
                var result = await _masterServices.GetAllCoustomer(loadOptions, userlist);
                return Ok(result);
            }
            catch (Exception ex)
            {
                return BadRequest(string.Join(",", ex.InnerException.Message));
            }

        }
        [HttpGet]
        [Route("get-customers")]
        public async Task<IActionResult> GetCustomers()
        {
            var result = await _masterServices.GetCustomers();
            return Ok(result);
        }
        [HttpGet]
        [Route("get-customers-by-sale-typeids/{saleTypeId}")]
        public async Task<IActionResult> GetCustomersBySaleTypeIds(int saleTypeId)
        {
            List<Customer> data = new List<Customer>();
            if (SessionMain == null || string.IsNullOrWhiteSpace(SessionMain.ADUserId)
                      || !SessionMain.Roles.Any())
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            data = await _masterServices.GetCollaboandSNSCustomers(saleTypeId);
            List<CustomerListResult> result = _mapper.Map<List<CustomerListResult>>(data);
            return Ok(result.DistinctBy(x => x.CustomerId).OrderBy(x => x.CustomerName).ToList());
        }
        [HttpGet]
        [Route("get-customers-by-incharge-by-user-countryids/{countryId}")]
        public async Task<IActionResult> GetCustomersByInchargeByCountryIds(string? countryId)
        {
            List<int> countryIds = new List<int>();
            if (SessionMain == null || string.IsNullOrWhiteSpace(SessionMain.ADUserId)
                      || !SessionMain.Roles.Any())
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            if (countryId != "null")
            {
                countryIds = countryId
                   .Split(',').Select(s => int.TryParse(s, out int result) ? result : 0)
                .ToList();
            }

            bool isSupeAdmin = SessionMain.Roles.Contains(Contants.ADMIN_ROLE);
            var data = await _masterServices.GetCustomersByInchargeByCountryIds(countryIds, SessionMain.ADUserId, isSupeAdmin, SessionMain.ADUserId);
            List<CustomerListResult> result = _mapper.Map<List<CustomerListResult>>(data);
            return Ok(result.DistinctBy(x => x.CustomerId).OrderBy(x => x.CustomerName).ToList());
        }
        [HttpGet]
        [Route("get-collabo-noncollabo-customers-by-incharge-by-user-countryids/{customerType}/{countryId}/{saleTypeName}")]
        public async Task<IActionResult> GetCollaboNonCollaboCustomersByInchargeByCountryIds(bool? customerType, string? countryId, string? saleTypeName)
        {
            List<int> countryIds = new List<int>();
            if (SessionMain == null || string.IsNullOrWhiteSpace(SessionMain.ADUserId)
                      || !SessionMain.Roles.Any())
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            if (countryId != "null")
            {
                countryIds = countryId
                   .Split(',').Select(s => int.TryParse(s, out int result) ? result : 0)
                .ToList();
            }
            bool isSupeAdmin = SessionMain.Roles.Contains(Contants.ADMIN_ROLE);

            var data = await _masterServices.GetCollaboNonCollaboCustomersByInchargeByCountryIds(countryIds, customerType, SessionMain.ADUserId, isSupeAdmin, SessionMain.ADUserId, saleTypeName);
            List<CustomerListResult> result = _mapper.Map<List<CustomerListResult>>(data);
            return Ok(result.DistinctBy(x => x.CustomerId).OrderBy(x => x.CustomerName).ToList());
        }
        [HttpGet]
        [Route("get-collabo-noncollabo-customers/{customerType}")]
        public async Task<IActionResult> GetCollaboNonCollaboCustomers(bool? customerType)
        {
            var result = await _masterServices.GetCollaboNonCollaboCustomers(customerType);
            return Ok(result);
        }

        [HttpGet]
        [Route("get-collabo-noncollabo-customers-by-incharge/{customerType}")]
        public async Task<IActionResult> GetCollaboNonCollaboCustomersByIncharge(bool? customerType)
        {
            var result = await _masterServices.GetCollaboNonCollaboCustomersByIncharge(customerType, SessionMain.ADUserId);
            return Ok(result);
        }

        [HttpGet]
        [Route("get-customers-by-account/{accountId}")]
        public IActionResult GetCustomersByAccount(int accountId)
        {
            var data = _masterServices.GetCustomersByAccount(accountId);
            List<CustomerListResult> result = _mapper.Map<List<CustomerListResult>>(data);
            return Ok(result.DistinctBy(x => x.CustomerId).OrderBy(x => x.CustomerName).ToList());
        }


        #endregion

        #region salesoffice master
        [HttpGet]
        [Route("get-salesoffice")]
        public async Task<IActionResult> GetSaleOffices()
        {
            var result = await _masterServices.GetSaleOffices();
            return Ok(result);
        }
        #endregion

        #region saletype
        [HttpGet]
        [Route("get-saletype")]
        public async Task<IActionResult> GetSaleTypes()
        {
            var result = await _masterServices.GetSaleTypes();
            return Ok(result);
        }
        #endregion

        #region
        [HttpGet]
        [Route("dash-master")]
        public async Task<IActionResult> GetDashMasters(DataSourceLoadOptions loadOptions)
        {
            var result = await _masterServices.GetDashMasters(loadOptions);
            return Ok(result);
        }

        [HttpGet]
        [Route("dash-master-bp")]
        public async Task<IActionResult> GetDashMasterBP(DataSourceLoadOptions loadOptions)
        {
            var result = await _masterServices.GetDashMastersBP(loadOptions);
            return Ok(result);
        }

        [HttpGet]
        [Route("dash-monthly")]
        public async Task<IActionResult> GetDashMasterMonthly(DataSourceLoadOptions loadOptions)
        {
            var result = await _masterServices.GetDashMasterMonthly(loadOptions);
            return Ok(result);
        }
        #endregion
        #region Product Master
        [HttpGet]
        [Route("get-userproductmap/{userId}")]
        public async Task<IActionResult> getUserProductmap(string userId)
        {
            var result = await _masterServices.UserDepartmentMappLookups(userId);
            var list = result.Where(w => w.ProductId != null).DistinctBy(d => d.ProductId).ToList();
            return Ok(list);
        }
        #endregion


        #region globalConfig
        [HttpGet]
        [Route("global-config-by-key/{type}")]
        public async Task<IActionResult> GetGlobalConfigByKey(string? type)
        {
            var result = await _masterServices.GetGlobalConfigByKey(type);
            return Ok(result);
        }
        [HttpGet]
        [Route("global-config")]
        public IActionResult GetGlobalConfig()
        {
            var result = _masterServices.GetGlobalConfig();
            return Ok(result);
        }
        [HttpGet]
        [Route("update-config/{salesTypes}")]
        public IActionResult UpdateConfig(string salesTypes)
        {
            _masterServices.UpdateGlobalConfig(salesTypes);
            return Ok();
        }

        #endregion

        #region sales organization
        [HttpGet]
        [Route("salesOrganization-loopUp")]
        public async Task<IActionResult> GetSalesOrganization()
        {
            var result = await _masterServices.GetSalesOrganization();
            return Ok(result);
        }

        #endregion

        [HttpGet]
        [Route("get-customer-by-oac-country/{oacaccountid}/{countryId}")]
        public async Task<IActionResult> getcustomerbyoaccountry(string? oacaccountid, string? countryId)
        {
            List<int> countryIds = new List<int>();
            if (SessionMain == null || string.IsNullOrWhiteSpace(SessionMain.ADUserId)
                      || !SessionMain.Roles.Any())
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            if (countryId != null)
            {
                countryIds = countryId
                   .Split(',').Select(s => int.TryParse(s, out int result) ? result : 0)
                .ToList();
            }
            bool isSupeAdmin = SessionMain.Roles.Contains(Contants.ADMIN_ROLE);

            var result = await _masterServices.GetCustomersByInchargeByCountryIdsOAC(countryIds, SessionMain.ADUserId, isSupeAdmin, SessionMain.ADUserId, oacaccountid);
            return Ok(result.OrderBy(x => x.CustomerName));
            //return Ok();
        }
        #region  lock-psi

        [HttpGet]
        [Route("check-lock-screen/{pageBlock}")]
        public async Task<IActionResult> CheckLockPSIByUserId(string? pageBlock)
        {
            if (SessionMain == null || string.IsNullOrWhiteSpace(SessionMain.ADUserId)
                      || !SessionMain.Roles.Any())
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            var result = await _masterServices.CheckLockPSIByUserId(SessionMain.ADUserId, pageBlock);
            return Ok(result);
        }
        //[Obsolete]
        //[Authorize]
        //[HttpPost]
        //[Route("lock-psi-old")]
        //public async Task<IActionResult> GetLockPSI(DataSourceLoadOptions loadOptions, PSILockSearchGrid obj)
        //{
        //    if (SessionMain == null || string.IsNullOrWhiteSpace(SessionMain.ADUserId)
        //            || !SessionMain.Roles.Any())
        //    {
        //        return BadRequest(HttpStatusCode.Unauthorized);
        //    }
        //    bool isSupeAdmin =  SessionMain.Roles.Contains(Contants.ADMIN_ROLE);
        //    //var result = await _masterServices.GetLockPSI(loadOptions, obj, SessionMain.ADUserId);

        //    return Ok(result);
        //}
        [Authorize]
        [HttpPost]
        [Route("lock-psi")]
        public IActionResult GetLockPSI(DataSourceLoadOptions loadOptions, PSILockSearchItems obj)
        {
            if (SessionMain == null || string.IsNullOrWhiteSpace(SessionMain.ADUserId)
                    || !SessionMain.Roles.Any())
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }

            var result = _masterServices.GetLockPSIList(loadOptions, obj, SessionMain.ADUserId);
            //var result =  _masterServices.GetLockPSI(loadOptions, obj, SessionMain.ADUserId);

            return Ok(result);
        }

        [Obsolete]
        [HttpPost]
        [Route("add-lock-psi")]
        public async Task<IActionResult> AddPSI([FromBody] LockPSICommand command)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            var result = await _masterServices.AddPSI(command, SessionMain);
            if (!result.IsSuccess)
            {
                return BadRequest(result.Errors);
            }
            return Ok();
        }
        [HttpPost]
        [Route("add-lock-psi/{userId}")]
        public IActionResult LockPSI([FromBody] IEnumerable<LockPSI> command, string userId)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            var result = _masterServices.AddUpdateLockPSI(command, userId, SessionMain.ADUserId);
            if (!result.IsSuccess)
            {
                return BadRequest(result.Errors);
            }
            return Ok();
        }
        [HttpGet]
        [Route("lock-all-users/{isBlock}")]
       
        public async Task<IActionResult> LokAllUser(bool? isBlock)
        {
            if (SessionMain == null)
            {
                return BadRequest(HttpStatusCode.Unauthorized);
            }
            var result = await _masterServices.UpdateOrInsertAllLockUser((bool)isBlock, SessionMain.ADUserId);
            if (!result.IsSuccess)
            {
                return BadRequest(result.Errors);
            }
            return Ok();
        }
        [HttpPost]
        [Route("add-Variant")]
        public async Task<IActionResult> AddVariant([FromBody] ReportCommand command)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            command.UserId = SessionMain.ADUserId;
            var result = await _masterServices.AddReportVariant(command);
            if (result.IsSuccess == false)
            {
                return BadRequest(result.Errors);
            }
            return Ok();
        }

        #endregion

    }
}
