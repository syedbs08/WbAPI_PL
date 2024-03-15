using AttachmentService;
using AttachmentService.Command;
using AttachmentService.Result;
using Core.BaseUtility.Utility;
using DevExtreme.AspNet.Data;
using DevExtreme.AspNet.Data.ResponseModel;
using EFCore.BulkExtensions;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Transmission.Repository;

namespace PSI.Modules.Backends.Transmission
{
    public interface IDashTransmitService
    {
        Result UploadTransmit(FileCommand command, SessionData sessionData
           );
        LoadResult GetDashTransmit(DataSourceLoadOptions loadOptions);
    }
    public class DashTransmitService : IDashTransmitService
    {
        private readonly IAttachmentService _attachmentService;
        private readonly IDashTransmitRepository _transmitRepo;
       
        public DashTransmitService(IDashTransmitRepository transmitRepo,
            IAttachmentService attachmentService)
        {
            _transmitRepo = transmitRepo;
            _attachmentService = attachmentService;
           
        }

        public Result UploadTransmit(FileCommand command, SessionData sessionData
           )
        {
            try
            {
                if (command == null)
                {
                    return Result.Failure("Input data is not valid ,kindly select file ");

                }

                var uploadedResult =  _attachmentService.UploadFiles(command, sessionData, true).Result;
                if (uploadedResult == null)
                {
                    return Result.Failure("Error while uploading dash transmit in blob.,contact to support team");
                }
                var result = ReadExcel(command, uploadedResult, sessionData);
                if (result.IsSuccess)
                {
                    Task.Run(() => _attachmentService.ActivateFile(uploadedResult.Id));
                }
                 return result;

            }
           
            catch (Exception ex)
            {
                Log.Error($"Execption occured while uploading dash transmit ", ex.Message);
                return Result.Failure("Problem in adding dash transmit ,try later");
            }
           
        }

        private Result ReadExcel(FileCommand command,
            FileUploadResult fileData
            , SessionData sessionData)
        {
           
            var file = command.File;

            var fileExt = Path.GetExtension(file.FileName);
            IWorkbook workbook = null;
            MemoryStream fs = new MemoryStream(fileData.FileBytes);
            ISheet sheet;
            if (fileExt == ".xls")
            {
                workbook = new HSSFWorkbook(fs);
            }
            else
            {
                workbook = new XSSFWorkbook(fs);
            }
            if (workbook != null)
            {
                sheet = workbook.GetSheetAt(0);
                if (sheet != null)
                {
                    var DataSheet = GetSheetData(sheet, fileData.Id, sessionData);
                    var validateResult = ValidateExcel(DataSheet);
                    if (validateResult.Length > 0)
                    {
                        return Result.Failure(validateResult);
                    }
                   

                    var existData = _transmitRepo.GetByCurrentMonth(DataSheet.FirstOrDefault()?.CurrentMonthYear).ToList();

                  //  var datatoAdd = DataSheet.Where(x => !existData.Any(y => y.ForeCastMonth == x.ForeCastMonth && y.AccountCode==x.AccountCode && 
                                        //   y.ConsigneeCode==x.ConsigneeCode && y.SalesCompany==x.SalesCompany && y.DemandModelNumber==x.DemandModelNumber)).ToList();

                  //  var datatoUpdate = existData.Where(x => DataSheet.Any(y => y.ForeCastMonth == x.ForeCastMonth && y.AccountCode == x.AccountCode &&
                                        //   y.ConsigneeCode == x.ConsigneeCode && y.SalesCompany == x.SalesCompany && y.DemandModelNumber == x.DemandModelNumber));

                    if (DataSheet.Any())
                    {
                        _transmitRepo.AddBulk(DataSheet);
                    }
                    //if (datatoUpdate.Any())
                    //{
                    //    _context.BulkUpdate(datatoUpdate);

                    //}
                    return Result.Success;
                }
                return Result.Failure("Invalid Excel Template has been selected to upload dash transmit");
            }
            return Result.Success;
        }
        private string[] ValidateExcel(List<DashTransmit> dataList)
        {
            List<string> errors = new List<string>();
            int firstIndex = 6;
            foreach (var data in dataList)
            {
                int row = Convert.ToInt32(dataList.IndexOf(data)) + firstIndex;
                if (string.IsNullOrWhiteSpace(data.CurrentMonthYear))
                {
                    errors.Add("Current Month Year be entered at row 2");
                }
                if (string.IsNullOrWhiteSpace(data.SalesCompany))
                {
                    errors.Add("Sales Company in header must be entered for  row" + row);
                }
                if (string.IsNullOrWhiteSpace(data.AccountCode))
                {
                    errors.Add("Account Code in header must be entered for row" + row);
                }
                if (string.IsNullOrWhiteSpace(data.ConsigneeCode))
                {
                    errors.Add("Consignee Code in header must be entered for row" + row);
                }

            }
            return errors.ToArray();

        }
        private List<DashTransmit> GetSheetData(ISheet excelSheet, int attachmentId, SessionData session)
        {
            var dashTransmitList = new List<DashTransmit>();
            int firstRowIndex = 6;
            string previousReplier = "";
            string previousDemandModel = "";
            string salesCompany = "";
            string accountCode = "";
            string consigneeCode = "";
            for (int row = firstRowIndex; row <= excelSheet.LastRowNum; row++)
            {

                if (excelSheet.GetRow(row) != null) //null is when the row only contains empty cells 
                {
                   

                    if (NullToString(excelSheet.GetRow(row).GetCell(0)) == "1")
                    {
                        salesCompany = NullToString(excelSheet.GetRow(row).GetCell(1));
                        accountCode = NullToString(excelSheet.GetRow(row).GetCell(2));
                        consigneeCode = NullToString(excelSheet.GetRow(row).GetCell(3));
                    }

                    if (NullToString(excelSheet.GetRow(row).GetCell(0)) != "*" 
                        && NullToString(excelSheet.GetRow(row).GetCell(0)) != "H"
                        && NullToString(excelSheet.GetRow(row).GetCell(0)) != "1")
                    {
                        var dashTransmit = new DashTransmit();
                        dashTransmit.AttachmentId = attachmentId;
                        //fix header value
                        dashTransmit.CurrentMonthYear = excelSheet.GetRow(1).GetCell(2).ToString();

                        dashTransmit.SalesCompany = salesCompany;
                        dashTransmit.AccountCode = accountCode;
                        dashTransmit.ConsigneeCode = consigneeCode;
                        if (NullToString(excelSheet.GetRow(row).GetCell(1)) != "")
                        {
                            previousReplier = NullToString(excelSheet.GetRow(row).GetCell(1));
                        }
                        dashTransmit.Replier = previousReplier;
                        if (NullToString(excelSheet.GetRow(row).GetCell(2)) != "")
                        {
                            previousDemandModel = NullToString(excelSheet.GetRow(row).GetCell(2));
                        }
                        dashTransmit.DemandModelNumber = previousDemandModel;
                        dashTransmit.ModelNumber= NullToString(excelSheet.GetRow(row).GetCell(3));

                        dashTransmit.Supplier = NullToString(excelSheet.GetRow(row).GetCell(4));
                        dashTransmit.ForeCastMonth = NullToString(excelSheet.GetRow(row).GetCell(5));

                        dashTransmit.CustomerETAWeek = NullToString(excelSheet.GetRow(row).GetCell(6));

                        dashTransmit.StatusType = NullToString(excelSheet.GetRow(row).GetCell(7));

                        dashTransmit.TranportMode = NullToString(excelSheet.GetRow(row).GetCell(8));

                        dashTransmit.DemandSlideType = NullToString(excelSheet.GetRow(row).GetCell(9));

                        dashTransmit.DemandQuantity = ToInt32(NullToString(excelSheet.GetRow(row).GetCell(10)));

                        dashTransmit.ATPSlideType = NullToString(excelSheet.GetRow(row).GetCell(11));

                        dashTransmit.ReferenceATPType = NullToString(excelSheet.GetRow(row).GetCell(12));

                        dashTransmit.ATPQuantity = ToInt32(NullToString(excelSheet.GetRow(row).GetCell(13)));

                        dashTransmit.ShipmentDate = NullToString(excelSheet.GetRow(row).GetCell(14));



                        dashTransmit.CustomerETADate = NullToString(excelSheet.GetRow(row).GetCell(15));

                        dashTransmit.OneWeekRepliedQuantity = ToInt32(NullToString(excelSheet.GetRow(row).GetCell(16)));

                        dashTransmit.OneWeekShipmentDate = NullToString(excelSheet.GetRow(row).GetCell(17));

                        dashTransmit.OneWeekCustomerETADate = NullToString(excelSheet.GetRow(row).GetCell(18));

                        dashTransmit.TwoWeekRepliedQuantity = ToInt32(NullToString(excelSheet.GetRow(row).GetCell(19)));

                        dashTransmit.TwoWeekShipmentDate = NullToString(excelSheet.GetRow(row).GetCell(20));

                        dashTransmit.TwoWeekCustomerETADate = NullToString(excelSheet.GetRow(row).GetCell(21));

                        dashTransmit.ThreeWeekRepliedQuantity = ToInt32(NullToString(excelSheet.GetRow(row).GetCell(22)));

                        dashTransmit.ThreeWeekShipmentDate = NullToString(excelSheet.GetRow(row).GetCell(23));

                        dashTransmit.ThreeWeekCustomerETADate = NullToString(excelSheet.GetRow(row).GetCell(24));

                        dashTransmit.DemandATPComaprisonType = NullToString(excelSheet.GetRow(row).GetCell(25));

                        dashTransmit.ATPPartialShipmentReply = NullToString(excelSheet.GetRow(row).GetCell(26));

                        dashTransmit.SalesRouteCode = NullToString(excelSheet.GetRow(row).GetCell(27));


                        dashTransmit.CreatedBy = session.ADUserId;
                        dashTransmit.CreatedDate = DateTime.Now;

                        dashTransmitList.Add(dashTransmit);
                    }
                    //liine item

                    

                }
            }
            return dashTransmitList;

        }

        public LoadResult GetDashTransmit(DataSourceLoadOptions loadOptions)
        {
            ///loadOptions.Filter==null?2000:5000
            var data =  _transmitRepo.GetAll(2000);
            var result = DataSourceLoader.Load(data, loadOptions);
            return result;

        }

        public  int? ToInt32(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
            {
                return null;
            }
            else
            {
                return Convert.ToInt32(value);
            }
        }

        public string NullToString(object Value)
        {
            
            return Value == null  ? "" : Value.ToString();

           


        }


    }
}
