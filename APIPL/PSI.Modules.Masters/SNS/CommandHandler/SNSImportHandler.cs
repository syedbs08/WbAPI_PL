using AttachmentService;
using AttachmentService.Command;
using AttachmentService.Result;
using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Graph;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Constants;
using PSI.Modules.Backends.DirectSales.Command;
using PSI.Modules.Backends.Masters.Repository.AccountMaster;
using PSI.Modules.Backends.Masters.Repository.CustomerMaster;
using PSI.Modules.Backends.Masters.Repository.GlobalConfigMaster;
using PSI.Modules.Backends.Masters.Repository.MaterialMaster;
using PSI.Modules.Backends.Masters.Repository.ProductCategoryMaster;
using PSI.Modules.Backends.SNS.Command;
using PSI.Modules.Backends.SNS.Repository;
using System.Data;
using System.Globalization;
using System.Text.RegularExpressions;
using static PSI.Modules.Backends.Constants.Contants;

namespace PSI.Modules.Backends.SNS.CommandHandler
{
    public class SNSImportHandler : IRequestHandler<SNSEntryUploadCommand, Result>
    {
        private readonly PSIDbContext _context;
        private readonly IAttachmentService _attachmentService;
        private readonly ISNSEntryImportRepository _SNSEntryImportRepository;
        private readonly IMaterialRepository _materialReopsitory;
        private readonly ICustomerRepository _customerRepository;
        private readonly ICustomerDIDRepository _customerDIDRepository;
        private readonly IProductCategoryRepository _productCategoryRepository;
        private readonly IGlobalConfigRepository _globalConfigRepository;
        private readonly IAccountRepository _accountRepository;
        private readonly ISNSEntryRepository _sNSEntryRepository;
        public SNSImportHandler(IAttachmentService attachmentService, ISNSEntryImportRepository SNSEntryImportRepository, IMaterialRepository materialReopsitory, ICustomerRepository customerRepository, ICustomerDIDRepository customerDIDRepository,
            IProductCategoryRepository productCategoryRepository,
            IGlobalConfigRepository globalConfigRepository, IAccountRepository accountRepository, ISNSEntryRepository sNSEntryRepository)
        {
            _attachmentService = attachmentService;
            _SNSEntryImportRepository = SNSEntryImportRepository;
            _materialReopsitory = materialReopsitory;
            _customerRepository = customerRepository;
            _customerDIDRepository = customerDIDRepository;
            _productCategoryRepository = productCategoryRepository;
            _globalConfigRepository = globalConfigRepository;
            _context = new PSIDbContext();
            _accountRepository = accountRepository;
            _sNSEntryRepository = sNSEntryRepository;
        }

        public async Task<Result> Handle(SNSEntryUploadCommand request, CancellationToken cancellationToken)
        {
            try
            {
                string subtype = "";
                if (request.SNSEntryDetails.SaleSubType == "Monthly")
                {
                    subtype = Contants.global_config_psi_year_key;
                }
                else
                {
                    subtype = Contants.global_config_BP_year_key;
                }
                var psiDateData = _globalConfigRepository.GetAll().FirstOrDefault(c => c.ConfigKey == subtype);
                if (psiDateData == null)
                {

                    var result = new List<SP_InsertSNSEntryDetails>(){
                        new SP_InsertSNSEntryDetails{
                           ResponseCode = "107",
                        ResponseMessage = $"Year is not available in the configuration."
                        }
                    };
                    return Result.SuccessWith<List<SP_InsertSNSEntryDetails>>(result);

                }


                FileCommand fileCommand = new FileCommand
                {
                    File = request?.SNSEntryDetails.File,
                    FileTypeId = request.SNSEntryDetails.FileTypeId,
                    FolderPath = request.SNSEntryDetails.FolderPath,
                };

                var uploadedResult = await _attachmentService.UploadFiles(fileCommand, request.SessionData, true);
                if (uploadedResult == null)
                {
                    var result = new List<SP_InsertSNSEntryDetails>(){
                        new SP_InsertSNSEntryDetails{
                            ResponseCode = "500",
                            ResponseMessage = "Error while uploading SNS Entries file in blob",
                        }
                    };
                    return Result.SuccessWith<List<SP_InsertSNSEntryDetails>>(result);
                }
                //Get Account code
                var account = _accountRepository.GetById(request.SNSEntryDetails.OACAccountId).Result;
                var SNSEntryData = ReadExcelFile(request, uploadedResult, account.AccountCode, psiDateData.ConfigValue);
                if (SNSEntryData == null)
                {
                    var result = new List<SP_InsertSNSEntryDetails>(){
                        new SP_InsertSNSEntryDetails{
                            ResponseCode = "500",
                            ResponseMessage = "Error while uploading SNS Entries file in blob",
                        }
                    };
                    return Result.SuccessWith<List<SP_InsertSNSEntryDetails>>(result);
                }
                if (SNSEntryData.ResponseList.Count > 0)
                {
                    return Result.SuccessWith<List<SP_InsertSNSEntryDetails>>(SNSEntryData.ResponseList);
                }

                //Need to do changes after disussion
                 bool isValidMonth = ValidateMonth(SNSEntryData, psiDateData);


                return PrepareAndSavSNSEntry(SNSEntryData, request, uploadedResult);

            }
            catch (Exception ex)
            {

                Log.Error($"Error in uploading/reading file with Message - {ex.Message}. StackTrace - {ex.StackTrace}");
                var result = new List<SP_InsertSNSEntryDetails>(){
                        new SP_InsertSNSEntryDetails{
                            ResponseCode = "500",
                            ResponseMessage = Contants.ERROR_MSG,
                        }
                    };
                return Result.SuccessWith<List<SP_InsertSNSEntryDetails>>(result);
            }

        }

        private SNSEntryData ReadExcelFile(SNSEntryUploadCommand command, FileUploadResult fileData, string sheetName, string globalConfigYear)
        {
            string fileName;
            var file = command.SNSEntryDetails.File;
            fileName = Guid.NewGuid() + Path.GetExtension(file.FileName);
            var SNSDheetData = new SNSEntryData();
            try
            {
                if (file != null)
                {

                    var fileExt = Path.GetExtension(file.FileName);

                    MemoryStream fs = new MemoryStream(fileData.FileBytes);
                    IWorkbook workbook = null;
                    var sheetNames = new List<string>();
                    ISheet currentWorksheet;
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

                        for (int i = 0; i < workbook.NumberOfSheets; i++)
                        {
                            string name = workbook.GetSheetName(i).Trim().Replace(" ", "").ToUpper();

                            if (!string.IsNullOrEmpty(name))
                            {
                                sheetNames.Add(name);
                            }
                        }
                        var expectedSheetIndex = sheetNames.FindIndex(c => c == sheetName);
                        //Make changes for all sheet
                        if (expectedSheetIndex != -1)
                        {

                            currentWorksheet = workbook.GetSheetAt(expectedSheetIndex);
                            SNSDheetData = GetSheetData(currentWorksheet, fileData.Id, command.SessionData, command.SNSEntryDetails);
                        }
                        else
                        {
                            SNSDheetData.ResponseList.Add(new SP_InsertSNSEntryDetails()
                            {
                                ResponseCode = "107",
                                ResponseMessage = "Invalid sheet name: Sheet name should be same as the OAC Code"
                            });

                        }
                    }
                }
            }
            catch (Exception ex)
            {

                throw;

            }

            return SNSDheetData;
        }

        public SNSEntryData GetSheetData(ISheet excelSheet, int AttachmentID, SessionData sessionData, SNSEntryDetails snsEntryDetails)
        {
            SNSEntryData objSNSEntryData = new SNSEntryData();
            List<SNSEntryQty> lstEntryQty = new List<SNSEntryQty>();
            List<SNSEntryPrice> lstEntryPrice = new List<SNSEntryPrice>();
            List<SNSData> lstSNSData = new List<SNSData>();
            var snsentries = _sNSEntryRepository.GetAll();
            try
            {

                var lastRowIndexToRead = excelSheet.LastRowNum;

                #region Validate Header
                //Validate Sheet column Header
                int firstHeaderRowIndex = 2;
                int lastHeaderRowIndex = 4;

                string[] headerRow = new string[4];
                bool flagHeader = true;

                var currentHeaderRow = excelSheet.GetRow(firstHeaderRowIndex);
                ICell cellCusomerCode = currentHeaderRow.GetCell(0);
                var cellCusomerHeader = GetCellValue(cellCusomerCode).TrimStart('0');
                headerRow[0] = Convert.ToString(cellCusomerHeader);
                ICell cellHeaderCustName = currentHeaderRow.GetCell(1);
                var cellCustNameHeader = GetCellValue(cellHeaderCustName);
                headerRow[1] = Convert.ToString(cellCustNameHeader);
                ICell cellCatIDHeader = currentHeaderRow.GetCell(2);
                var cellCategoryHeader = GetCellValue(cellCatIDHeader);
                headerRow[2] = Convert.ToString(cellCategoryHeader);
                ICell cellMaterialIDHeader = currentHeaderRow.GetCell(3);
                var cellMaterialIDHeaer = GetCellValue(cellMaterialIDHeader);
                headerRow[3] = Convert.ToString(cellMaterialIDHeaer);

                if (Convert.ToString(headerRow[0]) != Contants.SNS_Header_Customer)
                {
                    flagHeader = false;
                    objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                    {
                        ResponseCode = "111",
                        ResponseMessage = $"RowNo: {firstHeaderRowIndex + 1} : Cell:0.  Invalid column name. It should be Customer"
                    });
                }
                if (Convert.ToString(headerRow[1]) != Contants.SNS_Header_CustomerName)
                {
                    flagHeader = false;
                    objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                    {
                        ResponseCode = "111",
                        ResponseMessage = $"RowNo: {firstHeaderRowIndex + 1}  : Cell:1.  Invalid column name. It should be Customer Name"
                    });
                }
                if (Convert.ToString(headerRow[2]) != Contants.SNS_Header_Category)
                {
                    flagHeader = false;
                    objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                    {
                        ResponseCode = "111",
                        ResponseMessage = $"RowNo: {firstHeaderRowIndex + 1} : Cell:2.   Invalid column name. It should be Category"
                    });
                }
                if (Convert.ToString(headerRow[3]) != Contants.SNS_Header_MaterialCode)
                {
                    flagHeader = false;
                    objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                    {
                        ResponseCode = "111",
                        ResponseMessage = $"RowNo: {firstHeaderRowIndex + 1}  : Cell:3.  Invalid column name. It should be Material Code"
                    });
                }

                //Validate Qty Header
                int startQtyCell = 4;
                int lastQtyCell = 18;
                int TotalQtyColum = 0;
                int startPriceCell = 20;
                int endPriceCell = 34;
                int TotalPriceColumn = 0;
                var currentQtyPriceHeaderRow = excelSheet.GetRow(firstHeaderRowIndex);
                //Qty Header
                for (int qtyHeader = startQtyCell; qtyHeader <= lastQtyCell; qtyHeader++)
                {
                    ICell cellQty = currentHeaderRow.GetCell(qtyHeader);
                    var cellQtyHeader = GetCellValue(cellQty);

                    string[] arrQty = cellQtyHeader.Split('-');
                    if (arrQty.Length == 2)
                    {

                        string monthYeaResult = ConvertQtyMonthName(arrQty[0]);
                        if (string.IsNullOrEmpty(monthYeaResult))
                        {
                            flagHeader = false;
                            //Month is not a proper format
                            objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                            {
                                ResponseCode = "107",
                                ResponseMessage = $"RowNo: {firstHeaderRowIndex + 1} and CellNo :{qtyHeader}  Month is not valid"
                            });

                        }
                        else if (arrQty[1].ToLower() != "qty")
                        {
                            flagHeader = false;
                            objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                            {
                                ResponseCode = "107",
                                ResponseMessage = $"RowNo: {firstHeaderRowIndex + 1} and CellNo :{qtyHeader}  Month is not valid"
                            });
                        }
                        else
                        {
                            TotalQtyColum = TotalQtyColum + 1;
                        }
                    }
                    else
                    {
                        flagHeader = false;
                        objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                        {
                            ResponseCode = "107",
                            ResponseMessage = $"RowNo: {firstHeaderRowIndex + 1} and CellNo :{qtyHeader}  Month is not valid"
                        });

                    }
                }
                //Qty Header
                for (int priceHeader = startPriceCell; priceHeader <= endPriceCell; priceHeader++)
                {

                    ICell cellPrice = currentHeaderRow.GetCell(priceHeader);
                    var cellPriceHeader = GetCellValue(cellPrice);

                    string[] arrPrice = cellPriceHeader.Split('-');
                    if (arrPrice.Length == 2)
                    {

                        string monthYeaResult = ConvertQtyMonthName(arrPrice[0]);
                        if (string.IsNullOrEmpty(monthYeaResult))
                        {
                            flagHeader = false;
                            //Month is not a proper format
                            objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                            {
                                ResponseCode = "107",
                                ResponseMessage = $"RowNo: {firstHeaderRowIndex + 1} and CellNo :{priceHeader}  Month is not valid"
                            });

                        }
                        else if (arrPrice[1].ToLower() != "price")
                        {
                            flagHeader = false;
                            objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                            {
                                ResponseCode = "107",
                                ResponseMessage = $"RowNo: {firstHeaderRowIndex + 1} and CellNo :{priceHeader}  Month is not valid"
                            });
                        }
                        else
                        {
                            TotalPriceColumn = TotalPriceColumn + 1;
                        }
                    }
                    else
                    {
                        flagHeader = false;
                        objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                        {
                            ResponseCode = "107",
                            ResponseMessage = $"RowNo: {firstHeaderRowIndex + 1} and CellNo :{priceHeader}  Month is not valid"
                        });

                    }
                }
                // Retrun if colum less or max (14+1)
                if (TotalQtyColum > Contants.SNS_Qty_column_match || TotalQtyColum < Contants.SNS_Qty_column_match)
                {
                    flagHeader = false;
                    objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                    {
                        ResponseCode = "107",
                        ResponseMessage = $"Qty colum is more/less as expected"
                    });

                }
                // Retrun if colum less or max (14+1)
                if (TotalPriceColumn > Contants.SNS_Price_column_match || TotalPriceColumn < Contants.SNS_Price_column_match)
                {
                    flagHeader = false;
                    objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                    {
                        ResponseCode = "107",
                        ResponseMessage = $"Price column is more/less as expected"
                    });

                }
                #endregion


                if (flagHeader)
                {
                    int firstRowIndex = 3;
                    int priceQtyRowHeaderRow = 0;
                    for (int row = firstRowIndex; row <= lastRowIndexToRead; row++)
                    {
                        if (excelSheet.GetRow(row) != null) //null is when the row only contains empty cells 
                        {
                            var currentRow = excelSheet.GetRow(row);
                            ICell cellCusomerID = currentRow.GetCell(0);
                            var cellCusomerIDalue = GetCellValue(cellCusomerID).TrimStart('0');
                            ICell cellCustName = currentRow.GetCell(1);
                            var cellCustNameValue = GetCellValue(cellCustName);
                            ICell cellCatID = currentRow.GetCell(2);
                            var cellCatIDValue = GetCellValue(cellCatID);
                            ICell cellMaterialID = currentRow.GetCell(3);
                            var cellMaterialIDVaue = GetCellValue(cellMaterialID);

                            //Get Product category ID from Category
                            var flagProdcutCategory = false;
                            int ProductCategoryID = 0;
                            string CategoryName = string.Empty;
                            if (!string.IsNullOrEmpty(cellCatIDValue))
                            {
                                string[] arrProduct = Convert.ToString(cellCatIDValue).Split('-');

                                if (arrProduct != null && arrProduct.Length > 0)
                                {
                                    if (arrProduct.Length < 2)
                                    {
                                        objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                                        {
                                            ResponseCode = "107",
                                            ResponseMessage = $"RowNo: {row + 1}   ProductCategory is not valid. Category format should be combination of code and name"
                                        });
                                    }
                                    else
                                    {
                                        for (int i = 1; i < arrProduct.Length; i++)
                                        {
                                            if (CategoryName != "")
                                            {
                                                CategoryName = CategoryName + "-" + arrProduct[i];
                                            }
                                            else
                                            {
                                                CategoryName = arrProduct[i];
                                            }

                                        }

                                        if (!string.IsNullOrEmpty(arrProduct[0]))
                                        {
                                            int parsedValue;

                                            flagProdcutCategory = int.TryParse(arrProduct[0], out parsedValue);
                                            //flagProdcutCategory = IsNumber(arrProduct[0]);
                                            if (!flagProdcutCategory)
                                            {

                                                objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                                                {
                                                    ResponseCode = "107",
                                                    ResponseMessage = $"RowNo: {row + 1}   ProductCategory is not valid. It should be integer"
                                                });
                                            }
                                            ProductCategoryID = Convert.ToInt32(arrProduct[0]);
                                        }
                                        else
                                        {
                                            objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                                            {
                                                ResponseCode = "107",
                                                ResponseMessage = $"RowNo: {row + 1}   ProductCategory is not valid"
                                            });
                                        }
                                    }


                                }
                                else
                                {
                                    objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                                    {
                                        ResponseCode = "107",
                                        ResponseMessage = $"RowNo: {row + 1}   ProductCategory is not valid"
                                    });
                                }

                            }
                            else
                            {

                                objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                                {
                                    ResponseCode = "107",
                                    ResponseMessage = $"RowNo: {row + 1}   ProductCategory is empty"
                                });
                            }

                            if (string.IsNullOrEmpty(cellCusomerIDalue))
                            {
                                objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                                {
                                    ResponseCode = "107",
                                    ResponseMessage = $"RowNo: {row + 1}   CustomerCode is empty"
                                });

                            }
                            if (string.IsNullOrEmpty(cellCustNameValue))
                            {
                                objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                                {
                                    ResponseCode = "107",
                                    ResponseMessage = $"RowNo: {row + 1}   CustomerName is empty"
                                });

                            }
                            if (string.IsNullOrEmpty(cellMaterialIDVaue))
                            {
                                objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                                {
                                    ResponseCode = "107",
                                    ResponseMessage = $"RowNo: {row + 1}   MaterialCode is empty"
                                });

                            }

                            if (flagProdcutCategory && (!string.IsNullOrEmpty(cellCusomerIDalue)) && (!string.IsNullOrEmpty(cellCustNameValue)) && (!string.IsNullOrEmpty(cellMaterialIDVaue)))
                            {
                                var ExcellstSNSData = lstSNSData.Where(x => x.MaterialCode == cellMaterialIDVaue &&
                                x.CustomerCode == cellCusomerIDalue && x.Category == CategoryName).FirstOrDefault();
                                if (ExcellstSNSData != null)
                                {
                                    objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                                    {
                                        ResponseCode = "107",
                                        ResponseMessage = $"RowNo: {row + 1}   Duplicate entry found in excel"
                                    });
                                }

                                lstSNSData.Add(new SNSData()
                                {
                                    CustomerCode = cellCusomerIDalue,
                                    CustomerName = cellCustNameValue,
                                    MaterialCode = cellMaterialIDVaue,
                                    //CategoryID = cellCatIDValue,
                                    CategoryID = Convert.ToString(ProductCategoryID),
                                    Category = CategoryName,
                                    AttachmentID = AttachmentID,

                                    SalesTypeID = (int)SaleTypeEnum.SNS,
                                    ModeTypeID = (int)ModeOfTypeEnum.S,//For Testing only
                                    RowNum = row + 1
                                }); ;
                            }
                            priceQtyRowHeaderRow = 2;

                            //ObjsNSEntryQty.RowNum = row;


                            var PrevRow = excelSheet.GetRow(priceQtyRowHeaderRow);
                            for (int i = startQtyCell; i <= lastQtyCell; i++)
                            {
                                SNSEntryQty ObjsNSEntryQty = new SNSEntryQty();


                                ICell cellMonthly = PrevRow.GetCell(i);
                                var cellMonthlyDalue = GetCellValue(cellMonthly);
                                string[] monthQty = cellMonthlyDalue.Split("-");
                                string monthYeaResult = ConvertQtyMonthName(monthQty[0]);
                                ICell cellMonthlyValue = currentRow.GetCell(i);
                                var cellMonthlyQty = GetCellValue(cellMonthlyValue);
                                int Qty = 0;
                                if (!string.IsNullOrEmpty(cellMonthlyQty))
                                {

                                    var isQtryValid = Int32.TryParse(cellMonthlyQty, out Qty);
                                    if (!isQtryValid)
                                    {
                                        objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                                        {
                                            ResponseCode = "107",
                                            ResponseMessage = $"RowNo: {row + 1} and CellNo :{i}  has invalid character. It should be numeric always."
                                        });

                                    }
                                    else
                                    {

                                        if (Convert.ToInt32(cellMonthlyQty) < 0)
                                        {
                                            objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                                            {
                                                ResponseCode = "107",
                                                ResponseMessage = $"RowNo: {row + 1}  and Month : {monthYeaResult} has negative value."
                                            });

                                        }
                                        else
                                        {

                                            lstEntryQty.Add(new SNSEntryQty()
                                            {
                                                MonthYear = Convert.ToInt32(monthYeaResult),
                                                Qty = Convert.ToInt32(cellMonthlyQty),
                                                RowNum = row + 1

                                            });

                                        }

                                    }

                                }
                                else
                                {
                                    lstEntryQty.Add(new SNSEntryQty()
                                    {
                                        MonthYear = Convert.ToInt32(monthYeaResult),
                                        Qty = 0,
                                        RowNum = row + 1

                                    });

                                }
                            }
                            for (int j = startPriceCell; j <= endPriceCell; j++)
                            {
                                SNSEntryPrice objSNSEntryPrice = new SNSEntryPrice();
                                //string[] monthPrice = excelSheet.GetRow(priceQtyRow)?.GetCell(j).ToString().Split("-");
                                ICell cellMonthly = PrevRow.GetCell(j);
                                var cellMonthlyDalue = GetCellValue(cellMonthly);
                                string[] monthPrice = cellMonthlyDalue.Split("-");
                                string monthYeaResult = ConvertQtyMonthName(monthPrice[0]);

                                ICell cellMonthlyValue = currentRow.GetCell(j);
                                var cellMonthlyPrice = GetCellValue(cellMonthlyValue);
                                if (!string.IsNullOrEmpty(cellMonthlyPrice))
                                {
                                    decimal priceValue = 0;

                                    var isValid = Decimal.TryParse(cellMonthlyPrice, out priceValue);
                                    if (!isValid)
                                    {
                                        objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                                        {
                                            ResponseCode = "107",
                                            ResponseMessage = $"RowNo: {row + 1} and CellNo :{j} has invalid character. It should be decimal or numeric"
                                        });
                                    }
                                    else
                                    {
                                        if (Convert.ToDecimal(cellMonthlyPrice) < 0)
                                        {
                                            objSNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                                            {
                                                ResponseCode = "108",
                                                ResponseMessage = $"RowNo: {row + 1} and CellNo :{j}  has negative value"
                                            });
                                        }
                                        else
                                        {

                                            lstEntryPrice.Add(new SNSEntryPrice()
                                            {
                                                MonthYear = Convert.ToInt32(monthYeaResult),
                                                Price = Convert.ToDecimal(cellMonthlyPrice),
                                                RowNum = row + 1

                                            });
                                        }
                                    }

                                }
                                else
                                {
                                    lstEntryPrice.Add(new SNSEntryPrice()
                                    {
                                        MonthYear = Convert.ToInt32(monthYeaResult),
                                        Price = 0,
                                        RowNum = row + 1

                                    });
                                }
                            }



                            //}
                        }
                    }
                    objSNSEntryData.SNSData = lstSNSData;
                    objSNSEntryData.SNSEntryQty = lstEntryQty;
                    objSNSEntryData.SNSEntryPrice = lstEntryPrice;
                }

            }
            catch
            {
                throw;
            }

            return objSNSEntryData;
        }

        /// <summary>
        /// Convert Date format as per PSI Dates formats
        /// </summary>
        /// <param name="monthName"></param>
        /// <returns></returns>
        private string ConvertQtyMonthName(string monthName)
        {
            string result = "";

            if (!string.IsNullOrEmpty(monthName))
            {
                var rx = new Regex(@"[A-z]{3}\s\d{4}", RegexOptions.IgnoreCase);

                if (rx.IsMatch(monthName))
                {
                    var strSplits = monthName.Split(' ');
                    DateTime dt;
                    bool isValidDate = DateTime.TryParseExact("01" + strSplits[0] + strSplits[1], "ddMMMyyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt);
                    if (isValidDate)
                    {
                        result = dt.ToString("yyyyMM");
                    }
                }
            }
            return result;
        }

        private string GetCellValue(ICell cell)
        {
            string value = string.Empty;
            if (cell != null)
            {
                dynamic cellValue;
                switch (cell.CellType)
                {
                    case CellType.Numeric:
                        cellValue = cell.NumericCellValue;
                        value = cellValue != null ? cellValue.ToString() : "";
                        break;
                    case CellType.String:
                        cellValue = cell.StringCellValue;
                        value = cellValue != null ? cellValue.ToString() : "";
                        break;
                    case CellType.Boolean:
                        cellValue = cell.BooleanCellValue;
                        value = cellValue != null ? cellValue.ToString() : "";
                        break;
                    //in case if the cell has any formula , then we need to get its result
                    case CellType.Formula:
                        {
                            var cellFormularReturnType = cell.CachedFormulaResultType;
                            switch (cellFormularReturnType)
                            {
                                case CellType.Numeric:
                                    cellValue = cell.NumericCellValue;
                                    value = cellValue != null ? cellValue.ToString() : "0";
                                    break;
                                case CellType.Boolean:
                                    cellValue = cell.BooleanCellValue;
                                    value = cellValue != null ? cellValue.ToString() : "false";
                                    break;
                                default:
                                    cellValue = cell.StringCellValue;
                                    value = cellValue != null ? cellValue.ToString() : "";
                                    break;
                            }
                        }
                        break;
                    default:
                        value = cell != null ? cell.ToString() : "";
                        break;
                }
            }
            return value;

        }


        private Result PrepareAndSavSNSEntry(SNSEntryData SnsEntryData, SNSEntryUploadCommand command, FileUploadResult uploadedResult)
        {
            try
            {
                if (SnsEntryData != null)
                {
                    var dtSNSData = new DataTable();
                    dtSNSData.Columns.Add(new DataColumn("CustomerCode", typeof(string)));
                    dtSNSData.Columns.Add(new DataColumn("CustomerName", typeof(string)));
                    dtSNSData.Columns.Add(new DataColumn("MaterialCode", typeof(string)));
                    dtSNSData.Columns.Add(new DataColumn("CategoryID", typeof(int)));
                    dtSNSData.Columns.Add(new DataColumn("Category", typeof(string)));
                    dtSNSData.Columns.Add(new DataColumn("AttachmentID", typeof(int)));
                    dtSNSData.Columns.Add(new DataColumn("RowNum", typeof(int)));
                    dtSNSData.Columns.Add(new DataColumn("SaleTypeId", typeof(int)));
                    dtSNSData.Columns.Add(new DataColumn("ModeofTypeId", typeof(int)));

                    var dtSnsQtyInfo = new DataTable();
                    dtSnsQtyInfo.Columns.Add(new DataColumn("RowNum", typeof(int)));
                    dtSnsQtyInfo.Columns.Add(new DataColumn("MonthYear", typeof(string)));
                    dtSnsQtyInfo.Columns.Add(new DataColumn("Qty", typeof(int)));

                    var dtSnsPriceInfo = new DataTable();
                    dtSnsPriceInfo.Columns.Add(new DataColumn("RowNum", typeof(int)));
                    dtSnsPriceInfo.Columns.Add(new DataColumn("MonthYear", typeof(string)));
                    dtSnsPriceInfo.Columns.Add(new DataColumn("Price", typeof(decimal)));

                    foreach (var row in SnsEntryData.SNSData)
                    {
                        dtSNSData.Rows.Add(
                            row.CustomerCode,
                            row.CustomerName,

                            row.MaterialCode,
                              row.CategoryID,
                              row.Category,
                               row.AttachmentID,
                            row.RowNum,
                            row.SalesTypeID,
                            row.ModeTypeID
                           );
                    }
                    foreach (var row in SnsEntryData.SNSEntryQty)
                    {
                        dtSnsQtyInfo.Rows.Add(row.RowNum, row.MonthYear, row.Qty);
                    }
                    foreach (var row in SnsEntryData.SNSEntryPrice)
                    {
                        dtSnsPriceInfo.Rows.Add(row.RowNum, row.MonthYear, row.Price);
                    }

                    return SaveSNS(command, uploadedResult, dtSNSData, dtSnsQtyInfo, dtSnsPriceInfo, SnsEntryData.ResponseList);
                }
                else
                {
                    var result = new List<SP_InsertSalesEntries>(){
                        new SP_InsertSalesEntries{
                            ResponseCode = "500",
                            ResponseMessage = "No Valid Data To Process",
                        }
                    };
                    return Result.SuccessWith<List<SP_InsertSalesEntries>>(result);
                }
            }
            catch (Exception)
            {
                throw;
            }
        }


        /// <summary>
        /// Save the Direct Sales Excel information to DB
        /// </summary>
        /// <param name="command"></param>
        /// <param name="uploadedResult"></param>
        /// <param name="dtSalesEntries"></param>
        /// <param name="dtSalesQtyInfos"></param>
        /// <param name="dtSalesPriceInfos"></param>
        /// <returns></returns>
        private Result SaveSNS(SNSEntryUploadCommand command, FileUploadResult uploadedResult, DataTable dtSnsEntry, DataTable dtDsnQtyInfo, DataTable dtDnsPriceInfo, List<SP_InsertSNSEntryDetails> responseList)
        {
            try
            {

                var customerId = new SqlParameter("@OACID", SqlDbType.Int);
                //customerId.Value = command.DirectSale.CustomerId;
                customerId.Value = command.SNSEntryDetails.OACAccountId;//For Testing only

                var SnsEntry = new SqlParameter("@tvpSNSEntries", SqlDbType.Structured);
                SnsEntry.Value = dtSnsEntry;
                SnsEntry.TypeName = "dbo.TVP_SNS_ENTRIES";

                var qtyInfo = new SqlParameter("@tvpSNSQuantities", SqlDbType.Structured);
                qtyInfo.Value = dtDsnQtyInfo;
                qtyInfo.TypeName = "dbo.TVP_SNS_QTY_INFO";

                var priceInfo = new SqlParameter("@tvpSNSPrice", SqlDbType.Structured);
                priceInfo.Value = dtDnsPriceInfo;
                priceInfo.TypeName = "dbo.TVP_SNS_PRICE_INFO";

                var userId = new SqlParameter("@userId", SqlDbType.NVarChar, 100);
                userId.Value = command.SessionData.ADUserId ?? string.Empty;

                //Sale sub type
                var SaleSubType = new SqlParameter("@SaleSubType", SqlDbType.NVarChar, 10);
                SaleSubType.Value = command.SNSEntryDetails.SaleSubType ?? string.Empty;



                var param = new SqlParameter[] {
                    customerId,

                    SnsEntry,
                    qtyInfo,
                    priceInfo,
                    userId,
                    SaleSubType
                    };

                var result = _context.SP_InsertSNSEntryDetails.FromSqlRaw("dbo.USP_InsertSNSEntries @OACID, @tvpSNSEntries, @tvpSNSPrice, @tvpSNSQuantities, @userId, @SaleSubType", param).AsNoTracking().ToList();
                if (result != null && result.ToList().Any())
                {
                    var spResult = result.ToList().Where(r => r.ResponseCode != "200");
                    responseList.AddRange(spResult);
                    if (responseList.Any())
                    {
                        return Result.SuccessWith<List<SP_InsertSNSEntryDetails>>(responseList);
                    }
                    else
                    {
                        var successRespone = result.Where(r => r.ResponseCode == "200").ToList();
                        if (successRespone.Count() > 0)
                        {
                            Task.Run(() => _attachmentService.ActivateFile(uploadedResult.Id));
                            return Result.SuccessWith<List<SP_InsertSNSEntryDetails>>(successRespone);
                        }
                        else
                        {
                            var errorResult = new List<SP_InsertSNSEntryDetails>(){
                                new SP_InsertSNSEntryDetails{
                                    ResponseCode = "500",
                                    ResponseMessage = Contants.ERROR_MSG,
                                }
                            };
                            return Result.SuccessWith<List<SP_InsertSNSEntryDetails>>(errorResult);
                        }
                    }
                }
                else
                {
                    var errorResult = new List<SP_InsertSNSEntryDetails>(){
                        new SP_InsertSNSEntryDetails{
                            ResponseCode = "500",
                            ResponseMessage = Contants.ERROR_MSG,
                        }
                    };
                    return Result.SuccessWith<List<SP_InsertSNSEntryDetails>>(errorResult);
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        private bool IsNumber(string number)
        {
            bool flag = false;
            Regex nonNumericRegex = new Regex(@"\D");
            if (nonNumericRegex.IsMatch(number))
            {
                //Contains non numeric characters.
                flag = true;
            }
            return flag;

        }

        private bool ValidateMonth(SNSEntryData salesEntryData, GlobalConfig psiDateData)
        {
            //int  lst = SNSEntryData.SNSEntryQty.First().RowNum;
            int firstRowIndex = salesEntryData.SNSEntryQty.First().RowNum;
            var startMonthYear = GetDateFromMonthYear(psiDateData.ConfigValue + Convert.ToString(salesEntryData.SNSEntryQty[0].MonthYear).Substring(4, 2));
            if (!startMonthYear.HasValue)
            {

                salesEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                {
                    ResponseCode = "111",
                    ResponseMessage = "PSI Year is not valid"
                });
            }
            //DateTime? startMonthYear;
            //if (salesSubType == "BP")
            //{

            //    startMonthYear = GetDateFromMonthYear(Convert.ToString(salesEntryData.SNSEntryQty[0].MonthYear));
            //    if (!startMonthYear.HasValue)
            //    {
            //        salesEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
            //        {
            //            ResponseCode = "111",
            //            ResponseMessage = "BP Year is not valid"
            //        });
            //    }
            //}
            //else
            //{
            //    startMonthYear = GetDateFromMonthYear(psiDateData.ConfigValue + "01");
            //    if (!startMonthYear.HasValue)
            //    {
            //        salesEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
            //        {
            //            ResponseCode = "111",
            //            ResponseMessage = "PSI Year is not valid"
            //        });
            //    }
            //}
            int monthCount = 0;

            foreach (var item in salesEntryData.SNSEntryQty.Where(c => c.RowNum == firstRowIndex))
            {
                var dateMonthYear = GetDateFromMonthYear(Convert.ToString(item.MonthYear));
                if (dateMonthYear != null)
                {
                    if (monthCount == 0)
                    {
                        if (GetMonthYearFromDate(startMonthYear.Value) != GetMonthYearFromDate(dateMonthYear.Value))
                        {
                            salesEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                            {
                              
                                ResponseCode = "111",
                                ResponseMessage = $" {item.MonthYear} Qty Month is not valid PSI Year / Invalid sequence"
                            });
                        }
                    }
                    else
                    {
                        var currentMonthYear = startMonthYear.Value.AddMonths(monthCount);
                        if (GetMonthYearFromDate(currentMonthYear) != GetMonthYearFromDate(dateMonthYear.Value))
                        {
                            salesEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                            {
                               
                                ResponseCode = "111",
                                ResponseMessage = $" {item.MonthYear} Qty Month is not valid PSI Year / Invalid sequence"
                            });
                        }
                    }
                }
                else
                {
                    salesEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                    {
                        
                        ResponseCode = "111",
                        ResponseMessage = $" {item.MonthYear} Month is not valid"
                    });
                }
                monthCount++;
            }

            monthCount = 0;
            foreach (var item in salesEntryData.SNSEntryPrice.Where(c => c.RowNum == firstRowIndex))
            {
                var dateMonthYear = GetDateFromMonthYear(Convert.ToString(item.MonthYear));
                if (dateMonthYear != null)
                {
                    if (monthCount == 0)
                    {
                        if (GetMonthYearFromDate(startMonthYear.Value) != GetMonthYearFromDate(dateMonthYear.Value))
                        {
                            salesEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                            {
                                
                                ResponseCode = "111",
                                ResponseMessage = $" {item.MonthYear} Price Month is not valid PSI Year / Invalid sequence"
                            });
                        }
                    }
                    else
                    {
                        var currentMonthYear = startMonthYear.Value.AddMonths(monthCount);
                        if (GetMonthYearFromDate(currentMonthYear) != GetMonthYearFromDate(dateMonthYear.Value))
                        {
                            salesEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                            {
                               
                                ResponseCode = "111",
                                ResponseMessage = $" {item.MonthYear} Price Month is not valid PSI Year / Invalid sequence"
                            });
                        }
                    }
                }
                else
                {
                    salesEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
                    {
                        ResponseCode = "111",
                        ResponseMessage = $"    {item.MonthYear} Month is not valid"
                    });
                }
                monthCount++;
            }
            //foreach (var item in SNSEntryData.SNSEntryQty.Where(c => c.RowNum == firstRowIndex))
            //{
            //    var dateMonthYear = GetDateFromMonthYear(Convert.ToString(item.MonthYear));
            //    if (dateMonthYear != null)
            //    {
            //        string PSIYear = dateMonthYear.Value.Year.ToString();
            //        if (PSIYear != psiDateData.ConfigValue)
            //        {
            //            SNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
            //            {

            //                ResponseCode = "111",
            //                ResponseMessage = $"     {item.MonthYear} Month is not valid PSI Year for Qty."

            //            });

            //        }


            //    }
            //    else
            //    {

            //        SNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
            //        {

            //            ResponseCode = "111",
            //            ResponseMessage = $"     {item.MonthYear} Month is not valid for Qty"

            //        });
            //    }
            //    monthCount++;
            //}

            //monthCount = 0;
            //foreach (var item in SNSEntryData.SNSEntryPrice.Where(c => c.RowNum == firstRowIndex))
            //{
            //    var dateMonthYear = GetDateFromMonthYear(Convert.ToString(item.MonthYear));
            //    if (dateMonthYear != null)
            //    {
            //        string PSIYear = dateMonthYear.Value.Year.ToString();
            //        if (PSIYear != psiDateData.ConfigValue)
            //        {
            //            SNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
            //            {

            //                ResponseCode = "111",
            //                ResponseMessage = $"     {item.MonthYear} Month is not valid PSI Year for Price."

            //            });

            //        }
            //    }
            //    else
            //    {

            //        SNSEntryData.ResponseList.Add(new SP_InsertSNSEntryDetails
            //        {

            //            ResponseCode = "111",
            //            ResponseMessage = $"     {item.MonthYear} Month is not valid for Price"

            //        });
            //    }
            //    monthCount++;
            //}

            return true;
        }

        /// <summary>
        /// Get Date From MonthYear
        /// </summary>
        /// <param name="dateValue"></param>
        /// <returns></returns>
        private DateTime? GetDateFromMonthYear(string dateValue)
        {
            DateTime dt;
            if (!string.IsNullOrEmpty(dateValue))
            {
                Regex rgMonth = new Regex(@"^\d{6}$");
                if (rgMonth.IsMatch(dateValue))
                {
                    var isValid = DateTime.TryParseExact(dateValue + "01", "yyyyMMdd", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt);
                    if (isValid)
                    {
                        return dt;
                    }
                }
            }
            return null;
        }

        /// <summary>
        /// Get MonthYear From Date
        /// </summary>
        /// <param name="dateValue"></param>
        /// <returns></returns>
        private string GetMonthYearFromDate(DateTime dateValue)
        {
            return dateValue.ToString("yyyyMM");
        }
    }
}
