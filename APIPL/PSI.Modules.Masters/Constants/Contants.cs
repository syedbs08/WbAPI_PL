namespace PSI.Modules.Backends.Constants
{
    //define all your enum,struct and constant here
    public class Contants
    {
        public enum MenuEnum
        {
            ALL

        }
        public enum ProductCategoryGroupEnum
        {
            MG = 1,
            MG1,
            MG2,
            MG3,
            MG4,
            MG5
        }

        public enum FileTypeEnum
        {
            Currency = 1,
            PSIDates = 2,
            TurnoverDays = 3,
            OcIndicationMonth = 4,
        }
        public enum ModeOfTypeEnum
        {
            Order = 1,
            P = 2,
            S = 3,
            I = 4,
            BP_O = 6,
            LY_O = 8,
            ADJ = 10,
            MPO = 12,
            BP_S = 18,
            LY_S = 23,
            FOB = 24,
        }
        public enum SaleTypeEnum
        {
            Direct = 1,
            SNS = 2,
            SNS_BP = 3
        }


        public const string OPSI_Upload = "OPSI_Upload";
        public const string COG_Upload = "COG_Upload";
        public const string O_LockMonthConfirm = "O_LockMonthConfirm";
        public const string OC_IndicationMonth = "OC_IndicationMonth";
        public const string BP_Upload_DirectSale = "BP_Upload_DirectSale";
        public const string BP_Upload_SNS = "BP_Upload_SNS";
        public const string BP_COG_Upload = "BP_COG_Upload";
        public const string ADJ_Upload = "ADJ_Upload";
        public const string SSD_Upload = "SSD_Upload";
        public const string SNS_Sales_Upload = "SNS_Sales_Upload";
        public const string Forecast_Projection = "Forecast_Projection";
        public const string SNS_Planning = "SNS_Planning";

        public readonly string CurrentMonthName = "Current_Month";
        public readonly string LockMonthName = "Lock_Month";
        public readonly string IndicationMonthName = "Indication_Month";


        public const string DEFAULT_SHEET_NAME = "Sheet1";
        public const string DEFAULT_FILE_DATETIME = "yyyyMMdd_HHmm";
        public const string DATETIME_FORMAT = "dd/MM/yyyy hh:mm:ss";
        public const string Excel_DATE_FORMAT = "dd/MM/yyyy";
        public const string EXCEL_MEDIA_TYPE = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        public const string DISPOSITION_TYPE_ATTACHMENT = "attachment";
       
        public const string ADMIN_ROLE = "OPSI_APPS_ADMIN";
        public const string MKTG_HEAD_ROLE = "OPSI_MKTG_HEAD";

        public const string ERROR_MSG = "Error in Processing, Please contact IT Apps Team";
        

        #region DataType available for Excel Export
        public const string STRING = "string";
        public const string INT32 = "int32";
        public const string DOUBLE = "double";
        public const string DATETIME = "datetime";
        public const string DECIMAL = "decimal";
        public const string BOOL = "boolean";
        #endregion

        #region direct sales
        public const string DirectSale_UploadFlag = "U";
        public const string DirectSale_AllowedTypes = "O,P,S,I,MPO,ADJ";
        public const string SnsSale_AllowedTypes = "S,FOB";
        public const string DirectSale_Header_Adl3 = "ADL3";
        public const string DirectSale_Header_Adl2 = "ADL2";
        public const string DirectSale_Header_Adl1 = "ADL1";
        public const string DirectSale_Header_Type = "Type";
        public const string DirectSale_Header_UploadFlag = "Upload Flag";
        public const string DirectSale_Header_Item_code = "Item_code";
        public const string direct_sales_upload_folder = "direct-sales";
        public const string sample_files_upload_folder = "sample-files";
        public const string direct_sales_upload_usd_currency = "USD";
        public const string global_config_psi_year_key = "PSI_YEAR";
        public const string global_config_BP_year_key = "BP_Year";
        public const string global_config_result_month_key = "Result_Month";
        public const short direct_sales_upload_month_count = 18;
        public const string DirectSale_Header_Price_code = "Price";
        #endregion

        #region SNS Header
        public const string SNS_Header_Customer = "Customer";
        public const string SNS_Header_CustomerName = "Customer Name";
        public const string SNS_Header_Category = "Category";
        public const string SNS_Header_MaterialCode = "MaterialCode";
        public const int SNS_Qty_column_match = 15; //14+1
        public const int SNS_Price_column_match = 15; //14+1
        public const string sns_upload_folder = "sns-files";



        #endregion

        #region Adjustment Header
        public const string Adjustment_Header_Customer = "CustomerCode";
        public const string Adjustment_Header_Type = "TYPE";
        public const string Adjustment_Header_MaterialCode = "Model";
        public const int Adjustment_Qty_Price_column_match = 18; //14+1
        public const string Adjustment_upload_folder = "adjustment-files";
        public const string Adjustment_upload_sheetname = "ADJ";


        #endregion

        #region direct sales
        public const string sns_planning_desc_modes = "GIT Arrivals,ORDER,PURCHASE,MPO,SALES,INVENTORY,ADJ,Stock Days";
        #endregion


        #region COG Header
        public const string COG_Header_Customer = "CustomerCode";
        public const string COG_Header_CustomerName = "CustomerName";
        public const string COG_Header_MaterialCode = "Model No.";
        public const string COG_Sheet_Name = "FOB";
        public const int COG_Price_column_match = 54;

        public const int COG_PriceInfo_Start_ColIndex = 3;
        public const int COG_PriceInfo_End_ColIndex = 56;

        public const int COG_First_DataRow_Index = 2;
        //need to check
        public const string cog_upload_folder = "cog-files";
        public const int cog_downoadtemplateid = 1347;


        #endregion
        #region transmission
        public const int DistResult = 101;
        public const int DistPlan = 102;
        public const int Plan = 100;
        public const int Consoli = 103;
        public const string ZeroPlan = "ZeroPlan";
        public const string Plan_For_Directsale = "DIRECT_SALE_PLN";
        public const string Plan_For_SNS = "SNS_Plan";
        #endregion
        #region report
        public const string ConsoliReport = "Consoli";
        public const string NonConsoliReport = "NonConsoli";
        public const string AccurancyReport = "Accuracy";
        #endregion

    }
}

