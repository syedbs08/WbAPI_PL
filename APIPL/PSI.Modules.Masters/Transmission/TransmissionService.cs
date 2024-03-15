
using IConfiguration = Microsoft.Extensions.Configuration.IConfiguration;
using Core.BaseUtility.Utility;
using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Transmission.Command;
using PSI.Modules.Backends.Transmission.Queries;
using PSI.Modules.Backends.Transmission.Repository;
using System.Net;
using System.Text;
using PSI.Modules.Backends.Masters.Repository.DashMaster;
using PSI.Modules.Backends.Helpers;
using PSI.Modules.Backends.Masters.Repository.CustomerMaster;
using AttachmentService;
using PSI.Modules.Backends.Masters.Repository.GlobalConfigMaster;
using NPOI.SS.Formula.Functions;
using Log = Core.BaseUtility.Utility.Log;
using PSI.Domains;
using Microsoft.EntityFrameworkCore;
using Microsoft.Data.SqlClient;
using System.Data;

namespace PSI.Modules.Backends.Transmission
{
    public class TransmissionService : ITransmissionService
    {
        private IMediator _mediator;
        private readonly ITransmissionPlanTypeRepository _transmissionPlanTypeRepository;
        private readonly ITransmissionListRepository _transmissionListRepository;
        private readonly ITransmissionDataRepository _transmissionDataRepository;
        private readonly IConfiguration _config;
        private readonly PSIDbContext _context;
        private readonly ICustomerViewReopsitory _customerViewReopsitory;
        private readonly IConfiguration _configuration;
        private readonly IAttachmentService _attachmentService;
        private readonly IGlobalConfigRepository _globalConfig;
        public TransmissionService(IMediator mediator,
            ITransmissionPlanTypeRepository transmissionPlanTypeRepository,
            ITransmissionListRepository transmissionListRepository,
            ITransmissionDataRepository transmissionDataRepository,
            IConfiguration config,
             ICustomerViewReopsitory customerViewReopsitory,
             IConfiguration configuration,
             IAttachmentService attachmentService,
             IGlobalConfigRepository globalConfig)
        {
            _mediator = mediator;
            _transmissionPlanTypeRepository = transmissionPlanTypeRepository;
            _transmissionListRepository = transmissionListRepository;
            _transmissionDataRepository = transmissionDataRepository;
            _config = config;
            _customerViewReopsitory = customerViewReopsitory;
            _configuration = configuration;
            _attachmentService = attachmentService;
            _globalConfig = globalConfig;
            _context = new PSIDbContext();
        }
        public async Task<List<TransmissionPlanType>> GetTransmissionPlanType()
        {
            var result = _transmissionPlanTypeRepository.GetAll().Where(x => x.IsActive == true);
            return result.OrderBy(x => x.PlanTypeName).ToList();
        }
        public async Task<Result> AddTransmissionList(TransmissionListCommand command, SessionData sessionData)
        {
            var result = await _mediator.Send(new CreateTransmissionListCommand(command, sessionData));
            return result;
        }
        public async Task<LoadResult> GetTransmissionList(DataSourceLoadOptions loadOptions)
        {
            var result = await _mediator.Send(new TransmissionListQuery(loadOptions));
            return result;
        }

        //pre-transmission
        public async Task<Result> AddPreTransmissionList(PreTransmissionListCommand command, SessionData sessionData)
        {
            var result = await _mediator.Send(new CreatePreTransmissionListCommand(command, sessionData));
            return result;
        }
        public async Task<LoadResult> GetPreTransmissionCustomerList(DataSourceLoadOptions loadOptions, PreTransmissionCustomerSearch obj)
        {
            var result = await _mediator.Send(new PreTransmissionCustomerListQuery(loadOptions, obj));
            return result;
        }
        public async Task<List<TransmissionListView>> getTransmissionCustomerByPlanTypeBySaleType(string planTypeCode, string saletype)
        {
            var result = _transmissionListRepository.GetTransmissionCustomerByPlanTypeBySaleType(planTypeCode, saletype).ToList();
            return result;
        }
        public async Task<Result> WritTramissionFile(int plantype, int resultMonth, string customerCode, int currentMonth, string type)
        {

            switch (plantype)
            {
                case Constants.Contants.DistResult:
                    return await WriteDistResult(resultMonth, customerCode, type);
                case Constants.Contants.DistPlan:
                    return await WriteDistPlan(currentMonth, customerCode, type, Constants.Contants.Plan);

                case Constants.Contants.Plan:
                    return await WritePlan(currentMonth, customerCode, type, Constants.Contants.Plan);
                case Constants.Contants.Consoli:
                    return await WriteConsoliPlan(currentMonth, customerCode, type, Constants.Contants.Consoli);
                default:
                    return Result.Failure("Plan not valid");

            }
            return Result.Success;
        }
        private async Task<Result> WriteConsoliPlan(int currentMonth, string customerCode, string type, int plantype)
        {
            try
            {

                if (currentMonth == 0)
                {
                    return Result.Failure("Current month must be provided");
                }
                Log.Error($"Consoli:DB START  {DateTime.Now}");
                var forecasteMonthYearDate = (DateTime)(Helper.GetDateFromMonthYear(currentMonth.ToString()));
                var forecasteMonthYear = Convert.ToInt32(Helper.GetMonthYearFromDate(forecasteMonthYearDate.AddMonths(+6)));
               // var transmitData = _transmissionDataRepository.GetConsoliTransmissionData(customerCode, currentMonth, forecasteMonthYear, type, plantype).ToList().Distinct();
               var transmitData= await _context.SP_TRANSMISSION_SEARCH.FromSql($"SP_TRANSMISSION_SEARCH {customerCode},{type},{Constants.Contants.Consoli},{currentMonth},{forecasteMonthYear}").AsNoTracking().ToListAsync();
                if (!transmitData.Any())
                {
                    return Result.Failure("Data not found in this month");
                }
                Log.Error($"Consoli:DB SUCCESFULLY {DateTime.Now}");
                //if (transmitData.Any())
                //{
                int index = 1;

                //header
                var dataString = "";
                var bpYear = _globalConfig.GetGlobalConfigByKey("BP_Year");
                if (type == "BP")
                {
                    dataString = GetSequenceNumber(index.ToString()) + "01" + "02"
                   + "00029956" + AddBlankSpace(8) + bpYear.ToString()
                   + AddBlankSpace(4) + "0122" + DateTime.Now.ToString("yyyyMMddhhmmssz") + "00"
                   + AddBlankSpace(1) + "00029956" + customerCode + AddBlankSpace(66) + "\r\n";
                }
                else
                {
                    dataString = GetSequenceNumber(index.ToString()) + "01" + "02"
                  + "00029956" + AddBlankSpace(8) + currentMonth.ToString()
                  + AddBlankSpace(2) + "0122" + DateTime.Now.ToString("yyyyMMddhhmmssz") + "00"
                  + AddBlankSpace(1) + "00029956" + customerCode + AddBlankSpace(66) + "\r\n";
                }
                foreach (var transmit in transmitData.Where(x => x.SalesSequenceTypeText == "P "))
                {
                    index++;
                    dataString += GetSequenceNumber(index.ToString()) + "02" +
                        transmit.SaleSequenceType
                        + AddBlankSpace(8)
                        + SetMaterialCode(transmit.MaterialCode)
                        + AddLoanProcurementType(transmit.MaterialCode)//ProcurementType
                        + AddBlankSpace(8)

                        + transmit.MonthYear
                        + AddBlankSpace(8)
                         + AddSign(transmit.Qty.Value)//add + or -
                        + transmit.Qty.ToString().Replace('-', '0').PadLeft(9, '0')
                         + AddSign(Convert.ToInt32(transmit.Amount))//add + or -
                        + transmit.Amount.ToString().Replace('-', '0').PadLeft(15, '0')

                        + "1SEA.F"
                         + AddSign(Convert.ToInt32(transmit.SaleValue))//add + or -
                        + transmit.SaleValue.ToString().Replace('-', '0').PadLeft(15, '0')
                        + AddBlankSpace(14) + "\r\n";


                }
                Log.Error($"Consoli:DB P END {DateTime.Now}");
                foreach (var transmit in transmitData.Where(x => x.SalesSequenceTypeText == "S "))
                {
                    index++;
                    dataString += GetSequenceNumber(index.ToString()) + "02" +
                         transmit.SaleSequenceType
                        + AddBlankSpace(8)
                        + SetMaterialCode(transmit.MaterialCode)
                        + AddLoanProcurementType(transmit.MaterialCode)
                        + AddBlankSpace(8)
                        + transmit.MonthYear
                        + AddBlankSpace(8)//Buyercode
                         + AddBlankSpace(30)
                        + AddSign(Convert.ToInt32(transmit.Qty))//add + or -
                        + transmit.Qty.ToString().Replace('-', '0').PadLeft(9, '0')
                       + AddSign(Convert.ToInt32(transmit.SaleValue))//add + or -
                        + transmit.SaleValue.ToString().Replace('-', '0').PadLeft(15, '0')
                        + AddBlankSpace(6) + "\r\n";


                }
                Log.Error($"Consoli:DB S END {DateTime.Now}");
                foreach (var transmit in transmitData.Where(x => x.SalesSequenceTypeText == "I "))
                {
                    index++;
                    dataString += GetSequenceNumber(index.ToString()) + "02" +
                   transmit.SaleSequenceType
                  + AddBlankSpace(8)
                  + SetMaterialCode(transmit.MaterialCode)
                  + AddLoanProcurementType(transmit.MaterialCode)
                  + AddBlankSpace(8)
                  + transmit.MonthYear
                  + AddSign(transmit.Qty.Value)//add + or -

                  + transmit.Qty.ToString().Replace('-', '0').PadLeft(9, '0')
                  + AddSign(Convert.ToInt32(transmit.Amount))//add + or -
                   + transmit.Amount.ToString().Replace('-', '0').PadLeft(15, '0')
                   + AddSign(Convert.ToInt32(transmit.SaleValue))//add + or -
                  + transmit.SaleValue.ToString().Replace('-', '0').PadLeft(15, '0')
                  + AddBlankSpace(28) + "\r\n";


                }
                Log.Error($"Consoli:DB S END {DateTime.Now}");
                index++;
                //trailer
                dataString += GetSequenceNumber(index.ToString()) + "03" + "02" + GetSequenceNumber(index.ToString());
                var result = "";
                if (type == "BP")
                {
                    //var result = WriteFileFTP($"Consoli_{customerCode}_{currentMonth}", dataString);

                    _attachmentService.DeleteFileFromBlob("transmission", $"Consoli_{customerCode}_BP_{bpYear}");
                    result = await _attachmentService.UploadFiles($"Consoli_{customerCode}_BP_{bpYear}", dataString, "transmission");
                }
                else
                {
                    //var result = WriteFileFTP($"Consoli_{customerCode}_{currentMonth}", dataString);

                    _attachmentService.DeleteFileFromBlob("transmission", $"Consoli_{customerCode}_{currentMonth}");
                    result = await _attachmentService.UploadFiles($"Consoli_{customerCode}_{currentMonth}", dataString, "transmission");
                }
                Log.Error($"Consoli:DB FILE UPLOAD  END {DateTime.Now}");
                if (result == "Success")
                {
                    var dtIdList = new DataTable();
                    dtIdList.Columns.Add(new DataColumn("ID", typeof(string)));
                    foreach (var ID in transmitData.Select(x => x.ID).ToList())
                    {
                        dtIdList.Rows.Add(ID);
                    }
                    var tvpIdList = new SqlParameter("@TVP_ID_LIST", SqlDbType.Structured);
                    tvpIdList.Value = dtIdList;

                    tvpIdList.TypeName = "dbo.TVP_ID_LIST";
                    var param = new SqlParameter[] {
                    tvpIdList
                    };
                    Log.Error($"Consoli:Database update start  {DateTime.Now}");
                    var data = _context.SP_ResponseResult.FromSqlRaw("dbo.SP_Transmission_Update @TVP_ID_LIST", param).AsNoTracking().ToList();
                    Log.Error($"Consoli:Database update   END {DateTime.Now}");
                }
                else
                {
                    return Result.Failure("Error in connect to FTP server");
                }
                Log.Error($"Consoli: before success msg {DateTime.Now}");
                return Result.Success;
                // return Result.Success;
            }

            catch (Exception ex)
            {
                Log.Error($"Write Consoli:Db operation failed{ex.Message}");
                return Result.Failure("Error in writing file");
            }


        }
        private async Task<Result> WriteDistPlan(int currentMonth, string customerCode, string type, int plantype)

        {
            try
            {
                if (currentMonth == 0)
                {
                    return Result.Failure("Current month must be provided");
                }
                if (string.IsNullOrWhiteSpace(customerCode))
                {
                    return Result.Failure("Customer Code must be provided");
                }
                var forecasteMonthYearDate = (DateTime)(Helper.GetDateFromMonthYear(currentMonth.ToString()));
                var forecasteMonthYear = Convert.ToInt32(Helper.GetMonthYearFromDate(forecasteMonthYearDate.AddMonths(+6)));
                var transmitData = _transmissionDataRepository.GetDisPlan(customerCode, currentMonth, forecasteMonthYear, type, plantype).ToList().Distinct();
                if (!transmitData.Any())
                {
                    return Result.Failure("Data not found in this month");
                }
                //if (transmitData.Any())
                //{
                int index = 1;
                //header
                var dataString = "";
                var bpYear = _globalConfig.GetGlobalConfigByKey("BP_Year");
                if (type == "BP")
                {
                    dataString = GetSequenceNumber(index.ToString()) + "01" + "02"
               + customerCode + AddBlankSpace(8) + bpYear.ToString()
               + AddBlankSpace(4) + "0122" + DateTime.Now.ToString("yyyyMMddhhmmssz") + "00"
               + AddBlankSpace(1) + customerCode + customerCode + AddBlankSpace(50) + "\r\n";
                }
                else
                {
                    dataString = GetSequenceNumber(index.ToString()) + "01" + "02"
               + customerCode + AddBlankSpace(8) + currentMonth.ToString()
               + AddBlankSpace(2) + "0122" + DateTime.Now.ToString("yyyyMMddhhmmssz") + "00"
               + AddBlankSpace(1) + customerCode + customerCode + AddBlankSpace(50) + "\r\n";
                }

                transmitData = transmitData.Distinct();

                foreach (var transmit in transmitData.Where(x => x.SalesSequenceTypeText == "P "))
                {
                    index++;
                    dataString += GetSequenceNumber(index.ToString()) + "02" +
                        transmit.SaleSequenceType
                        + AddBlankSpace(8)
                        + SetMaterialCode(transmit.MaterialCode)
                        + AddBlankSpace(9)
                        + transmit.MonthYear
                        + AddBlankSpace(8)//suppliercode
                        + AddSign((int)transmit.Qty)//sign qty
                        + RemoveSign((int)transmit.Qty).PadLeft(9, '0')
                        + AddSign((int)transmit.Amount)//sign lended value
                        + RemoveSign((int)transmit.Amount).PadLeft(15, '0')//lended value(p qty*P price)
                        + "1" //collabo set 1 for dis plan
                        + "SEA.F"
                        + AddSign((int)transmit.SaleValue)//sign sales Value
                        + RemoveSign((int)transmit.SaleValue).PadLeft(15, '0')
                        + AddBlankSpace(6) + AddBlankSpace(8) + "\r\n";


                }
                foreach (var transmit in transmitData.Where(x => x.SalesSequenceTypeText == "S "))
                {
                    index++;
                    dataString += GetSequenceNumber(index.ToString()) + "02" +
                        transmit.SaleSequenceType
                        + AddBlankSpace(8)
                        + SetMaterialCode(transmit.MaterialCode)
                        + AddBlankSpace(9)
                        + transmit.MonthYear
                        + AddBlankSpace(8)//suppliercode
                        + AddBlankSpace(30)//blank space
                        + AddSign((int)transmit.Qty)//sign qty
                        + RemoveSign((int)transmit.Qty).PadLeft(9, '0')
                        + AddSign((int)transmit.SaleValue)//sign SaleValue
                        + RemoveSign((int)transmit.SaleValue).PadLeft(15, '0')//lended value(p qty*P price)
                        + AddBlankSpace(6) + "\r\n";


                }
                foreach (var transmit in transmitData.Where(x => x.SalesSequenceTypeText == "I "))
                {
                    index++;
                    dataString += GetSequenceNumber(index.ToString()) + "02" +
                        transmit.SaleSequenceType
                        + AddBlankSpace(8)
                        + SetMaterialCode(transmit.MaterialCode)
                        + AddBlankSpace(9)
                        + transmit.MonthYear
                        + AddSign((int)transmit.Qty)//sign qty
                        + RemoveSign((int)transmit.Qty).PadLeft(9, '0')
                        + AddSign((int)transmit.Amount)//sign lended value
                        + RemoveSign((int)transmit.Amount).PadLeft(15, '0')//lended value(p qty*P price)
                        + AddSign((int)transmit.SaleValue)//sign sales Value
                        + RemoveSign((int)transmit.SaleValue).PadLeft(15, '0')
                        + AddBlankSpace(28)
                        + "\r\n";


                }
                index++;
                //trailer
                dataString += GetSequenceNumber(index.ToString()) + "03" + "02" + GetSequenceNumber(index.ToString()) + AddBlankSpace(108) + "\r\n"; ;
                var result = "";
                if (type == "BP")
                {
                    //var result = WriteFileFTP($"DisPlan_{customerCode}_{currentMonth}", dataString);
                    _attachmentService.DeleteFileFromBlob("transmission", $"DisPlan_{customerCode}_BP_{bpYear}");
                    result = await _attachmentService.UploadFiles($"DisPlan_{customerCode}_BP_{bpYear}", dataString, "transmission");
                }
                else
                {
                    //var result = WriteFileFTP($"DisPlan_{customerCode}_{currentMonth}", dataString);
                    _attachmentService.DeleteFileFromBlob("transmission", $"DisPlan_{customerCode}_{currentMonth}");
                    result = await _attachmentService.UploadFiles($"DisPlan_{customerCode}_{currentMonth}", dataString, "transmission");
                }
                if (result == "Success")
                {
                    var dtIdList = new DataTable();
                    dtIdList.Columns.Add(new DataColumn("ID", typeof(string)));
                    foreach (var ID in transmitData.Select(x => x.ID).ToList())
                    {
                        dtIdList.Rows.Add(ID);
                    }
                    var tvpIdList = new SqlParameter("@TVP_ID_LIST", SqlDbType.Structured);
                    tvpIdList.Value = dtIdList;

                    tvpIdList.TypeName = "dbo.TVP_ID_LIST";
                    var param = new SqlParameter[] {
                    tvpIdList
                    };
                    var data = _context.SP_ResponseResult.FromSqlRaw("dbo.SP_Transmission_Update @TVP_ID_LIST", param).AsNoTracking().ToList();
                }
                else
                {
                    return Result.Failure("Error in connect to FTP server");
                }
                return Result.Success;
            }
            catch (Exception ex)
            {
                Log.Error($"Write DisPlan:Db operation failed{ex.Message}");
                return Result.Failure("Error in writing file");
            }

        }

        private async Task<Result> WritePlan(int currentMonth, string customerCode, string type, int plantype)
        {
            try
            {
                if (currentMonth == 0)
                {
                    return Result.Failure("Current month must be provided");
                }
                if (string.IsNullOrWhiteSpace(customerCode))
                {
                    return Result.Failure("Customer Code must be provided");
                }
                var account = _context.Accounts.Where(x => x.AccountCode == customerCode).FirstOrDefault();
                if (account != null)
                {
                    await WritePlanForSNS(currentMonth, customerCode, type, plantype);
                }
                else
                {
                    await WritePlanForDirectSale(currentMonth, customerCode, type, plantype);
                }
                await WriteZeroPlan(currentMonth, customerCode, type, plantype);
                return Result.Success;
            }
            catch (Exception ex)
            {
                Log.Error($"Plan Add:Db operation failed{ex.Message}");
                return Result.Failure("Error in writing Plan,contact to support team");
            }
        }
        private async Task<Result> WritePlanForSNS(int currentMonth, string customerCode, string type, int plantype)

        {
            try
            {
                var forecasteMonthYearDate = (DateTime)(Helper.GetDateFromMonthYear(currentMonth.ToString()));
                var forecasteMonthYear = Convert.ToInt32(Helper.GetMonthYearFromDate(forecasteMonthYearDate.AddMonths(+6)));
                //var transmitData = _transmissionDataRepository.GetPlanForSNS(customerCode, currentMonth, forecasteMonthYear, type, plantype).ToList().Distinct();
                var transmitData = await _context.SP_TRANSMISSION_SEARCH.FromSql($"SP_TRANSMISSION_SEARCH {customerCode},{type},{Constants.Contants.Plan},{currentMonth},{forecasteMonthYear}").AsNoTracking().ToListAsync();
                if (!transmitData.Any())
                {
                    return Result.Failure("Data not found in this month");
                }
                //if (transmitData.Any())
                //{
                int index = 1;
                //header
                var dataString = "";
                var bpYear = _globalConfig.GetGlobalConfigByKey("BP_Year");
                if (type == "BP")
                {
                    dataString = GetSequenceNumber(index.ToString()) + "01" + "02"
               + "00029956" + AddBlankSpace(8) + bpYear.ToString()
               + AddBlankSpace(4) + "0122" + DateTime.Now.ToString("yyyyMMddhhmmssz") + "00"
               + AddBlankSpace(1) + "00029956" + customerCode + AddBlankSpace(50) + "\r\n";
                }
                else
                {
                    dataString = GetSequenceNumber(index.ToString()) + "01" + "02"
               + "00029956" + AddBlankSpace(8) + currentMonth.ToString()
               + AddBlankSpace(2) + "0122" + DateTime.Now.ToString("yyyyMMddhhmmssz") + "00"
               + AddBlankSpace(1) + "00029956" + customerCode + AddBlankSpace(50) + "\r\n";
                }
                
                var transmistP = transmitData.Where(x => x.SalesSequenceTypeText == "P ").ToList();
                var dashmaterials = _context.DashMaterial.Where(x => transmistP.Select(x=>x.MaterialCode).Contains(x.MaterialCode)).ToList();
                foreach (var transmit in transmistP)
                {
                    index++;
                    dataString += GetSequenceNumber(index.ToString()) + "02" +
                        transmit.SaleSequenceType
                        + AddBlankSpace(8)
                        + SetMaterialCode(transmit.MaterialCode)
                        + AddBlankSpace(9)
                        + transmit.MonthYear
                        + AddBlankSpace(8)//suppliercode
                        + AddSign((int)transmit.Qty)//sign qty
                        + RemoveSign((int)transmit.Qty).PadLeft(9, '0')
                        + AddSign((int)transmit.Amount)//sign lended value
                        + RemoveSign((int)transmit.Amount).PadLeft(15, '0')//lended value(p qty*P price)
                       + IsLocalProcurementItem(transmit.MaterialCode, (int)transmit.MonthYear, dashmaterials)
                        + "SEA.F"
                        + AddSign((int)transmit.SaleValue)//sign sales Value
                        + RemoveSign((int)transmit.SaleValue).PadLeft(15, '0')
                        + AddBlankSpace(6) + AddBlankSpace(8) + "\r\n";


                }
                foreach (var transmit in transmitData.Where(x => x.SalesSequenceTypeText == "S "))
                {
                    index++;
                    dataString += GetSequenceNumber(index.ToString()) + "02" +
                        transmit.SaleSequenceType
                        + AddBlankSpace(8)
                        + SetMaterialCode(transmit.MaterialCode)
                        + AddBlankSpace(9)
                        + transmit.MonthYear
                        + AddBlankSpace(8)//suppliercode
                        + AddBlankSpace(30)//blank space
                        + AddSign((int)transmit.Qty)//sign qty
                        + RemoveSign((int)transmit.Qty).PadLeft(9, '0')
                        + AddSign((int)transmit.SaleValue)//sign SaleValue
                        + RemoveSign((int)transmit.SaleValue).PadLeft(15, '0')//lended value(p qty*P price)
                        + AddBlankSpace(6) + "\r\n";


                }
                foreach (var transmit in transmitData.Where(x => x.SalesSequenceTypeText == "I "))
                {
                    index++;
                    dataString += GetSequenceNumber(index.ToString()) + "02" +
                        transmit.SaleSequenceType
                        + AddBlankSpace(8)
                        + SetMaterialCode(transmit.MaterialCode)
                        + AddBlankSpace(9)
                        + transmit.MonthYear
                        + AddSign((int)transmit.Qty)//sign qty
                        + RemoveSign((int)transmit.Qty).PadLeft(9, '0')
                        + AddSign((int)transmit.Amount)//sign lended value
                        + RemoveSign((int)transmit.Amount).PadLeft(15, '0')//lended value(p qty*P price)
                        + AddSign((int)transmit.SaleValue)//sign sales Value
                        + RemoveSign((int)transmit.SaleValue).PadLeft(15, '0')
                        + AddBlankSpace(28)
                        + "\r\n";


                }
                index++;
                //trailer
                dataString += GetSequenceNumber(index.ToString()) + "03" + "02" + GetSequenceNumber(index.ToString()) + AddBlankSpace(108) + "\r\n"; ;
                var result = "";
                if (type == "BP")
                {
                    //var result = WriteFileFTP($"Plan_{accountCode}_{currentMonth}", dataString);
                    _attachmentService.DeleteFileFromBlob("transmission", $"Plan_{customerCode}_BP_{bpYear}");
                    result = await _attachmentService.UploadFiles($"Plan_{customerCode}_BP_{bpYear}", dataString, "transmission");
                }
                else
                {
                    //var result = WriteFileFTP($"Plan_{accountCode}_{currentMonth}", dataString);
                    _attachmentService.DeleteFileFromBlob("transmission", $"Plan_{customerCode}_{currentMonth}");
                    result = await _attachmentService.UploadFiles($"Plan_{customerCode}_{currentMonth}", dataString, "transmission");
                }

                if (result == "Success")
                {

                    var dtIdList = new DataTable();
                    dtIdList.Columns.Add(new DataColumn("ID", typeof(string)));
                    foreach (var ID in transmitData.Select(x => x.ID).ToList())
                    {
                        dtIdList.Rows.Add(ID);
                    }
                    var tvpIdList = new SqlParameter("@TVP_ID_LIST", SqlDbType.Structured);
                    tvpIdList.Value = dtIdList;

                    tvpIdList.TypeName = "dbo.TVP_ID_LIST";
                    var param = new SqlParameter[] {
                    tvpIdList
                    };
                    var data = _context.SP_ResponseResult.FromSqlRaw("dbo.SP_Transmission_Update @TVP_ID_LIST", param).AsNoTracking().ToList();

                }
                else
                {
                    return Result.Failure("Error in connect to FTP server");
                }
                return Result.Success;
            }
            catch (Exception ex)
            {
                Log.Error($"Write PlanForSNS:Db operation failed{ex.Message}");
                return Result.Failure("Error in writing file");
            }

        }
        private async Task<Result> WritePlanForDirectSale(int currentMonth, string customerCode, string type, int plantype)

        {
            try
            {
                var forecasteMonthYearDate = (DateTime)(Helper.GetDateFromMonthYear(currentMonth.ToString()));
                var forecasteMonthYear = Convert.ToInt32(Helper.GetMonthYearFromDate(forecasteMonthYearDate.AddMonths(+6)));

                var transmitData = _transmissionDataRepository.GetPlan(customerCode, currentMonth, forecasteMonthYear, type, plantype).ToList().Distinct();
                if (!transmitData.Any())
                {
                    return Result.Failure("Data not found in this month");
                }
                //if (transmitData.Any())
                //{
                int index = 1;
                //header
                var dataString = "";
                var bpYear = _globalConfig.GetGlobalConfigByKey("BP_Year");
                if (type == "BP")
                {
                    dataString = GetSequenceNumber(index.ToString()) + "01" + "02"
                   + "00029956" + AddBlankSpace(8) + bpYear.ToString()
                   + AddBlankSpace(4) + "0122" + DateTime.Now.ToString("yyyyMMddhhmmssz") + "00"
                   + AddBlankSpace(1) + "00029956" + customerCode + AddBlankSpace(50) + "\r\n";
                }
                else
                {
                    dataString = GetSequenceNumber(index.ToString()) + "01" + "02"
                   + "00029956" + AddBlankSpace(8) + currentMonth.ToString()
                   + AddBlankSpace(2) + "0122" + DateTime.Now.ToString("yyyyMMddhhmmssz") + "00"
                   + AddBlankSpace(1) + "00029956" + customerCode + AddBlankSpace(50) + "\r\n";
                }
                transmitData = transmitData.Distinct();
                var dashmaterials = _context.DashMaterial.ToList();
                foreach (var transmit in transmitData.Where(x => x.SalesSequenceTypeText == "P "))
                {
                    index++;
                    dataString += GetSequenceNumber(index.ToString()) + "02" +
                        transmit.SaleSequenceType
                        + AddBlankSpace(8)
                        + SetMaterialCode(transmit.MaterialCode)
                        + AddBlankSpace(9)
                        + transmit.MonthYear
                        + AddBlankSpace(8)//suppliercode
                        + AddSign((int)transmit.Qty)//sign qty
                        + RemoveSign((int)transmit.Qty).PadLeft(9, '0')
                        + AddSign((int)transmit.Amount)//sign lended value
                        + RemoveSign((int)transmit.Amount).PadLeft(15, '0')//lended value(p qty*P price)
                        + IsLocalProcurementItem(transmit.MaterialCode, (int)transmit.MonthYear, dashmaterials)
                        + "SEA.F"
                        + AddSign((int)transmit.SaleValue)//sign sales Value
                        + RemoveSign((int)transmit.SaleValue).PadLeft(15, '0')
                        + AddBlankSpace(6) + AddBlankSpace(8) + "\r\n";


                }
                foreach (var transmit in transmitData.Where(x => x.SalesSequenceTypeText == "S "))
                {
                    index++;
                    dataString += GetSequenceNumber(index.ToString()) + "02" +
                        transmit.SaleSequenceType
                        + AddBlankSpace(8)
                        + SetMaterialCode(transmit.MaterialCode)
                        + AddBlankSpace(9)
                        + transmit.MonthYear
                        + AddBlankSpace(8)//suppliercode
                        + AddBlankSpace(30)//blank space
                        + AddSign((int)transmit.Qty)//sign qty
                        + RemoveSign((int)transmit.Qty).PadLeft(9, '0')
                        + AddSign((int)transmit.SaleValue)//sign SaleValue
                        + RemoveSign((int)transmit.SaleValue).PadLeft(15, '0')//lended value(p qty*P price)
                        + AddBlankSpace(6) + "\r\n";


                }
                foreach (var transmit in transmitData.Where(x => x.SalesSequenceTypeText == "I "))
                {
                    index++;
                    dataString += GetSequenceNumber(index.ToString()) + "02" +
                        transmit.SaleSequenceType
                        + AddBlankSpace(8)
                        + SetMaterialCode(transmit.MaterialCode)
                        + AddBlankSpace(9)
                        + transmit.MonthYear
                        + AddSign((int)transmit.Qty)//sign qty
                        + RemoveSign((int)transmit.Qty).PadLeft(9, '0')
                        + AddSign((int)transmit.Amount)//sign lended value
                        + RemoveSign((int)transmit.Amount).PadLeft(15, '0')//lended value(p qty*P price)
                        + AddSign((int)transmit.SaleValue)//sign sales Value
                        + RemoveSign((int)transmit.SaleValue).PadLeft(15, '0')
                        + AddBlankSpace(28)
                        + "\r\n";


                }
                index++;
                //trailer
                dataString += GetSequenceNumber(index.ToString()) + "03" + "02" + GetSequenceNumber(index.ToString()) + AddBlankSpace(108) + "\r\n"; ;
                var result = "";
                if (type == "BP")
                {
                    //var result = WriteFileFTP($"Plan_{customerCode}_{currentMonth}", dataString);
                    _attachmentService.DeleteFileFromBlob("transmission", $"Plan_{customerCode}_BP_{bpYear}");
                    result = await _attachmentService.UploadFiles($"Plan_{customerCode}_BP_{bpYear}", dataString, "transmission");
                }
                else
                { //var result = WriteFileFTP($"Plan_{customerCode}_{currentMonth}", dataString);
                    _attachmentService.DeleteFileFromBlob("transmission", $"Plan_{customerCode}_{currentMonth}");
                    result = await _attachmentService.UploadFiles($"Plan_{customerCode}_{currentMonth}", dataString, "transmission");

                }

                if (result == "Success")
                {
                   
                    var dtIdList = new DataTable();
                    dtIdList.Columns.Add(new DataColumn("ID", typeof(string)));
                    foreach (var ID in transmitData.Select(x => x.ID).ToList())
                    {
                        dtIdList.Rows.Add(ID);
                    }
                    var tvpIdList = new SqlParameter("@TVP_ID_LIST", SqlDbType.Structured);
                    tvpIdList.Value = dtIdList;

                    tvpIdList.TypeName = "dbo.TVP_ID_LIST";
                    var param = new SqlParameter[] {
                    tvpIdList
                    };
                    var data = _context.SP_ResponseResult.FromSqlRaw("dbo.SP_Transmission_Update @TVP_ID_LIST", param).AsNoTracking().ToList();

                }
                else
                {
                    return Result.Failure("Error in connect to FTP server");
                }
                return Result.Success;
            }
            catch (Exception ex)
            {
                Log.Error($"Write Plan For DirectSale:Db operation failed{ex.Message}");
                return Result.Failure("Error in writing file");
            }

        }
        private async Task<Result> WriteZeroPlan(int currentMonth, string customerCode, string type, int plantype)
        {
            try
            {
                var forecasteMonthYearDate = (DateTime)(Helper.GetDateFromMonthYear(currentMonth.ToString()));
                var forecasteMonthYear = Convert.ToInt32(Helper.GetMonthYearFromDate(forecasteMonthYearDate.AddMonths(+6)));
                var transmitData = _transmissionDataRepository.GetZeroPlan(customerCode, currentMonth, forecasteMonthYear, type, plantype).ToList().Distinct();

                //if (transmitData.Any())
                //{
                int index = 1;
                //header
                var dataString = "";
                var bpYear = _globalConfig.GetGlobalConfigByKey("BP_Year");
                if (type == "BP")
                {
                    dataString = GetSequenceNumber(index.ToString()) + "01" + "02"
                   + "00029956" + AddBlankSpace(8) + bpYear.ToString()
                   + AddBlankSpace(4) + "0122" + DateTime.Now.ToString("yyyyMMddhhmmssz") + "00"
                   + AddBlankSpace(1) + "00029956" + customerCode + AddBlankSpace(50) + "\r\n";
                }
                else
                {

                    dataString = GetSequenceNumber(index.ToString()) + "01" + "02"
                   + "00029956" + AddBlankSpace(8) + currentMonth.ToString()
                   + AddBlankSpace(2) + "0122" + DateTime.Now.ToString("yyyyMMddhhmmssz") + "00"
                   + AddBlankSpace(1) + "00029956" + customerCode + AddBlankSpace(50) + "\r\n";
                }

                transmitData = transmitData.Distinct();
                var dashmaterials = _context.DashMaterial.ToList();
                foreach (var transmit in transmitData.Where(x => x.SalesSequenceTypeText == "P "))
                {
                    index++;
                    dataString += GetSequenceNumber(index.ToString()) + "02" +
                        transmit.SaleSequenceType
                        + AddBlankSpace(8)
                        + SetMaterialCode(transmit.MaterialCode)
                        + AddBlankSpace(9)
                        + transmit.MonthYear
                        + AddBlankSpace(8)//suppliercode

                        + AddSign((int)transmit.Qty)//sign qty
                        + RemoveSign((int)transmit.Qty).PadLeft(9, '0')
                        + AddSign((int)transmit.Amount)//sign lended value
                        + RemoveSign((int)transmit.Amount).PadLeft(15, '0')//lended value(p qty*P price)
                        + IsLocalProcurementItem(transmit.MaterialCode, (int)transmit.MonthYear, dashmaterials)
                        + "SEA.F"
                        + AddSign((int)transmit.SaleValue)//sign sales Value
                        + RemoveSign((int)transmit.SaleValue).PadLeft(15, '0')
                        + AddBlankSpace(6) + AddBlankSpace(8) + "\r\n";


                }
                foreach (var transmit in transmitData.Where(x => x.SalesSequenceTypeText == "S "))
                {
                    index++;
                    dataString += GetSequenceNumber(index.ToString()) + "02" +
                        transmit.SaleSequenceType
                        + AddBlankSpace(8)
                        + SetMaterialCode(transmit.MaterialCode)
                        + AddBlankSpace(9)
                        + transmit.MonthYear
                        + AddBlankSpace(8)//suppliercode
                        + AddBlankSpace(30)//blank space
                        + AddSign((int)transmit.Qty)//sign qty
                        + RemoveSign((int)transmit.Qty).PadLeft(9, '0')
                        + AddSign((int)transmit.SaleValue)//sign SaleValue
                        + RemoveSign((int)transmit.SaleValue).PadLeft(15, '0')//lended value(p qty*P price)
                        + AddBlankSpace(6) + "\r\n";


                }
                foreach (var transmit in transmitData.Where(x => x.SalesSequenceTypeText == "I "))
                {
                    index++;
                    dataString += GetSequenceNumber(index.ToString()) + "02" +
                        transmit.SaleSequenceType
                        + AddBlankSpace(8)
                        + SetMaterialCode(transmit.MaterialCode)
                        + AddBlankSpace(9)
                        + transmit.MonthYear
                        + AddSign((int)transmit.Qty)//sign qty
                        + RemoveSign((int)transmit.Qty).PadLeft(9, '0')
                        + AddSign((int)transmit.Amount)//sign lended value
                        + RemoveSign((int)transmit.Amount).PadLeft(15, '0')//lended value(p qty*P price)
                        + AddSign((int)transmit.SaleValue)//sign sales Value
                        + RemoveSign((int)transmit.SaleValue).PadLeft(15, '0')
                        + AddBlankSpace(28)
                        + "\r\n";


                }
                index++;
                //trailer
                dataString += GetSequenceNumber(index.ToString()) + "03" + "02" + GetSequenceNumber(index.ToString()) + AddBlankSpace(108) + "\r\n"; ;
                var result = "";
                if (type == "BP")
                {
                    //var result = WriteFileFTP($"ZeroPlan_{customerCode}_{currentMonth}", dataString);
                    _attachmentService.DeleteFileFromBlob("transmission", $"ZeroPlan_{customerCode}_BP_{bpYear}");
                    result = await _attachmentService.UploadFiles($"ZeroPlan_{customerCode}_BP_{bpYear}", dataString, "transmission");
                }
                else
                {
                    //var result = WriteFileFTP($"ZeroPlan_{customerCode}_{currentMonth}", dataString);
                    _attachmentService.DeleteFileFromBlob("transmission", $"ZeroPlan_{customerCode}_{currentMonth}");
                    result = await _attachmentService.UploadFiles($"ZeroPlan_{customerCode}_{currentMonth}", dataString, "transmission");
                }
                if (result == "Success")
                {
                
                    var dtIdList = new DataTable();
                    dtIdList.Columns.Add(new DataColumn("ID", typeof(string)));
                    foreach (var ID in transmitData.Select(x => x.ID).ToList())
                    {
                        dtIdList.Rows.Add(ID);
                    }
                    var tvpIdList = new SqlParameter("@TVP_ID_LIST", SqlDbType.Structured);
                    tvpIdList.Value = dtIdList;

                    tvpIdList.TypeName = "dbo.TVP_ID_LIST";
                    var param = new SqlParameter[] {
                    tvpIdList
                    };
                    var data = _context.SP_ResponseResult.FromSqlRaw("dbo.SP_Transmission_Update @TVP_ID_LIST", param).AsNoTracking().ToList();
                }
                else
                {
                    return Result.Failure("Error in connect to FTP server");
                }
                return Result.Success;
            }
            catch (Exception ex)
            {
                Log.Error($"Write ZeroPlan:Db operation failed{ex.Message}");
                return Result.Failure("Error in writing file");
            }
        }

        private async Task<Result> WriteDistResult(int resultMonth, string customerCode, string type)

        {
            try
            {

                if (resultMonth == 0)
                {
                    return Result.Failure("Result month must be provided");
                }
                if (string.IsNullOrWhiteSpace(customerCode))
                {
                    return Result.Failure("Customer Code must be provided");
                }
                var transmitData = _transmissionDataRepository.GetDistResultPlan(customerCode, resultMonth, type).ToList().Distinct();
                if (!transmitData.Any())
                {
                    return Result.Failure("Data not found in this month");
                }

                //if (transmitData.Any())
                //{
                int index = 1;
                //header
                var dataString = "";
                var bpYear = _globalConfig.GetGlobalConfigByKey("BP_Year");
                if (type == "BP")
                {
                    dataString = GetSequenceNumber(index.ToString()) + "01" + "03"
                   + customerCode + AddBlankSpace(8) + bpYear.ToString()
                   + AddBlankSpace(4) + "0138" + DateTime.Now.ToString("yyyyMMddhhmmssz") + "00"
                   + AddBlankSpace(1) + customerCode + customerCode + AddBlankSpace(66) + "\r\n";
                }
                else
                {
                    dataString = GetSequenceNumber(index.ToString()) + "01" + "03"
                   + customerCode + AddBlankSpace(8) + resultMonth.ToString()
                   + AddBlankSpace(2) + "0138" + DateTime.Now.ToString("yyyyMMddhhmmssz") + "00"
                   + AddBlankSpace(1) + customerCode + customerCode + AddBlankSpace(66) + "\r\n";
                }
                transmitData = transmitData.Distinct();
                foreach (var transmit in transmitData.Where(x => x.SalesSequenceTypeText == "P "))
                {
                    index++;
                    dataString += GetSequenceNumber(index.ToString()) + "02" +
                        transmit.SaleSequenceType
                        + AddBlankSpace(8)
                        + SetMaterialCode(transmit.MaterialCode)

                        + AddBlankSpace(9)
                        + AddBlankSpace(8)//suppliercode
                        + AddSign((int)transmit.Qty)
                        + RemoveSign((int)transmit.Qty).PadLeft(9, '0')
                        + AddSign((int)transmit.Amount)
                        + RemoveSign((int)transmit.Amount).PadLeft(15, '0')
                        + AddSign((int)transmit.SaleValue)
                        + RemoveSign((int)transmit.SaleValue).PadLeft(15, '0')
                        + AddBlankSpace(42) + "\r\n";


                }
                foreach (var transmit in transmitData.Where(x => x.SalesSequenceTypeText == "S "))
                {
                    index++;
                    dataString += GetSequenceNumber(index.ToString()) + "02" +
                        transmit.SaleSequenceType
                        + AddBlankSpace(8)
                        + SetMaterialCode(transmit.MaterialCode)

                        + AddBlankSpace(9)
                        + AddBlankSpace(8)//suppliercode
                        + AddBlankSpace(30)
                        + AddSign((int)transmit.Qty)
                        + RemoveSign((int)transmit.Qty).PadLeft(9, '0')
                        + AddSign((int)transmit.SaleValue)
                        + RemoveSign((int)transmit.SaleValue).PadLeft(15, '0')
                        + AddBlankSpace(1)
                        + PaddingString("0", 9)
                        + AddBlankSpace(1)
                        + PaddingString("0", 15)
                        + AddBlankSpace(2)
                        + "\r\n";


                }
                foreach (var transmit in transmitData.Where(x => x.SalesSequenceTypeText == "I "))
                {
                    index++;
                    dataString += GetSequenceNumber(index.ToString()) + "02" +
                        transmit.SaleSequenceType
                        + AddBlankSpace(8)
                        + SetMaterialCode(transmit.MaterialCode)

                        + AddBlankSpace(9)
                        + AddBlankSpace(8)//suppliercode
                        + AddSign((int)transmit.Qty)
                        + RemoveSign((int)transmit.Qty).PadLeft(9, '0')
                        + AddSign((int)transmit.Amount)
                        + RemoveSign((int)transmit.Amount).PadLeft(15, '0')
                        + AddBlankSpace(1)
                        + PaddingString("0", 9)
                        + AddBlankSpace(1)
                        + PaddingString("0", 15)
                         + AddSign((int)transmit.SaleValue)
                        + RemoveSign((int)transmit.SaleValue).PadLeft(15, '0')
                        + AddBlankSpace(1)
                        + PaddingString("0", 15)
                        + "\r\n";


                }
                index++;
                //trailer
                dataString += GetSequenceNumber(index.ToString()) + "03" + "03" + GetSequenceNumber(index.ToString()) + AddBlankSpace(124);
                var result = "";
                if (type == "BP")
                {
                    _attachmentService.DeleteFileFromBlob("transmission", $"Dist_result_{customerCode}_BP_{bpYear}");
                    result = await _attachmentService.UploadFiles($"Dist_result_{customerCode}_BP_{bpYear}", dataString, "transmission");
                    //var result = WriteFileFTP($"Dist_result_{customerCode}_{resultMonth}", dataString);// check and replace file name
                }
                else
                {
                    _attachmentService.DeleteFileFromBlob("transmission", $"Dist_result_{customerCode}_{resultMonth}");
                    result = await _attachmentService.UploadFiles($"Dist_result_{customerCode}_{resultMonth}", dataString, "transmission");
                    //var result = WriteFileFTP($"Dist_result_{customerCode}_{resultMonth}", dataString);// check and replace file name
                }
                if (result == "Success")
                {
                    var dtIdList = new DataTable();
                    dtIdList.Columns.Add(new DataColumn("ID", typeof(string)));
                    foreach (var ID in transmitData.Select(x => x.ID).ToList())
                    {
                        dtIdList.Rows.Add(ID);
                    }
                    var tvpIdList = new SqlParameter("@TVP_ID_LIST", SqlDbType.Structured);
                    tvpIdList.Value = dtIdList;

                    tvpIdList.TypeName = "dbo.TVP_ID_LIST";
                    var param = new SqlParameter[] {
                    tvpIdList
                    };
                    var data = _context.SP_ResponseResult.FromSqlRaw("dbo.SP_Transmission_Update @TVP_ID_LIST", param).AsNoTracking().ToList();
                }
                else
                {
                    return Result.Failure("Error in connect to FTP server");
                }
                return Result.Success;
            }
            catch (Exception ex)
            {

                Log.Error($"Transmission error:Db operation failed{ex.Message}");
                return Result.Failure("Error in adding Transmission,contact to support team");
            }

        }

        private string SetMaterialCode(string materialCode)
        {

            return materialCode.Length < 20 ? materialCode + AddBlankSpace(20 - materialCode.Length) : materialCode;

        }
        private int IsLocalProcurementItem(string materialCode, int monthYear, List<DashMaterial> dashMaterials)
        {
            int result = 1;
            var loadDashMaster = dashMaterials.Where(x => x.MaterialCode == materialCode && x.StartMonth <= monthYear && x.EndMonth >= monthYear).Take(1).OrderByDescending(x => x.DashMaterialId).ToList();
            return loadDashMaster.Count() > 0 ? 0 : 1;
        }
        private string GetSequenceNumber(string number)
        {
            return number.PadLeft(5, '0');

        }
        private string PaddingString(string value, int padLength)
        {
            return (value ?? "").PadLeft(padLength, '0');
        }
        private string AddBlankSpace(int number)
        {
            return new string(' ', number);

        }
        private string AddSign(int number)
        {
            return number >= 0 ? AddBlankSpace(1) : "-";
        }
        private string RemoveSign(int number)
        {
            return number >= 0 ? Convert.ToString(number) : Convert.ToString(number).Replace("-", "");
        }

        private string WriteFileFTP(string fileName, string data)
        {
            string message = "Success";
            try
            {
                // "ftp://192.168.1.100/"
                //.T
                WebRequest ftpRequest = WebRequest.Create(_config["AppConfig:ftpUrl"].ToString() + fileName);
                ftpRequest.Method = WebRequestMethods.Ftp.UploadFile;
                ftpRequest.Credentials = new NetworkCredential(_config["AppConfig:ftpUserId"], _config["AppConfig:ftpPwd"]);
                byte[] bytes = Encoding.UTF8.GetBytes(data);

                using (Stream requestStream = ftpRequest.GetRequestStream())
                {
                    requestStream.Write(bytes, 0, bytes.Length);
                }

                //Local File Write
                //byte[] bytes = Encoding.UTF8.GetBytes(data);
                //string path = @"C:\FtpUpload\" + fileName + "";
                //File.WriteAllBytes(path, bytes);
                //return "success";


            }
            catch (WebException e)
            {
                message = ((FtpWebResponse)e.Response).StatusDescription;
            }
            return message;

        }
        public async Task<LoadResult> GetTransmitdataList(DataSourceLoadOptions loadOptions)
        {
            var result = await _mediator.Send(new TransmitDataListQuery(loadOptions));
            return result;
        }


        private string AddLoanProcurementType(string materialCode)
        {
            // Validate model is Non-Matsushita Model.
            // But time being return false
            return AddBlankSpace(1);

        }



    }
}
