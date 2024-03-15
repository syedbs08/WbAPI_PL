using System.Globalization;
using System.Text.RegularExpressions;
using Microsoft.AspNetCore.Components.Forms;
using NPOI.SS.UserModel;

namespace PSI.Modules.Backends.Helpers
{
    public static class  Helper
    {
        public static decimal? ConvertStringToDecimal(string value)
        {
            if (value == null || string.IsNullOrWhiteSpace(value))
            {
                return null;
            }
            if (decimal.TryParse(value, out decimal result))
            {
                return result;
            }
            return null;
        
        }
        public static int[] SplitToInt(string dataToSplit, char separator = ',')
        {
            return dataToSplit.Split(separator).Select(int.Parse).ToArray();
        }
        public static int? ConvertStringToInteger(string value)
        {
            if (value == null || string.IsNullOrWhiteSpace(value))
            {
                return null;
            }
            
            if (int.TryParse(value, out int result))
            {
                return result;
            }
            return null;

        }
        //public static bool? CheckIfYearValid(string value)
        //{
        //    if (value == null || string.IsNullOrWhiteSpace(value))
        //    {
        //        return null;
        //    }
            
        //    if (DateTime.TryParse(string.Format("1/1/{0}", value), out DateTime dateTime))
        //    {
        //        return dateTime;
        //    }
        //    return 0;

        //}

        /// <summary>
        /// Get Cell Value
        /// </summary>
        /// <param name="cell"></param>
        /// <returns></returns>
        public static string GetCellValue(ICell cell)
        {
            string value = string.Empty;
            dynamic cellValue;
            if(cell == null)
                return value;
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

            return value;

        }

        /// <summary>
        /// Get MonthYear From Date
        /// </summary>
        /// <param name="dateValue"></param>
        /// <returns></returns>
        public static string GetMonthYearFromDate(DateTime dateValue)
        {
            return dateValue.ToString("yyyyMM");
        }

        /// <summary>
        /// Get MonthYear From Date
        /// </summary>
        /// <param name="dateValue"></param>
        /// <returns></returns>
        public static string GetLongMonthYearFromDate(DateTime dateValue)
        {
            return dateValue.ToString("MMM yyyy");
        }

        /// <summary>
        /// Get Date From MonthYear
        /// </summary>
        /// <param name="dateValue"></param>
        /// <returns></returns>
        public static DateTime? GetDateFromMonthYear(string dateValue)
        {
            DateTime dt;
            if (!string.IsNullOrEmpty(dateValue))
            {
                Regex rgMonth = new Regex(@"^\d{6}$");
                if (rgMonth.IsMatch(dateValue))
                {
                    var isValid = DateTime.TryParseExact(dateValue + "01", "yyyyMMdd", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt);
                    if(isValid){
                        return dt;
                    }
                }
            }
            return null;
        }
        public static string ResultMonthYYYYMM(DateTime currentMonthStartDate)
        {
            return GetMonthYearFromDate(currentMonthStartDate.AddMonths(-1));
        }
        public static string AddMonthYYYYMM(string monthYear,int month)
        {
            DateTime dateTime = DateTime.ParseExact(monthYear, "yyyyMM", System.Globalization.CultureInfo.InvariantCulture);
            return GetMonthYearFromDate(dateTime.AddMonths(month));
        }

        public static List<string> PrepareMonthListYYYYMM(DateTime resultMonthStartDate, DateTime lastForecastDate)
        {
            var monthList = new List<string>();
            while (resultMonthStartDate <= lastForecastDate)
            {
                monthList.Add(GetMonthYearFromDate(resultMonthStartDate));
                resultMonthStartDate = resultMonthStartDate.AddMonths(1);
            }
            return monthList;
        }
        public static List<string> PrepareMonthList(DateTime resultMonthStartDate, DateTime lastForecastDate)
        {
            var monthList = new List<string>();
            while(resultMonthStartDate <= lastForecastDate)
            {
                monthList.Add(GetLongMonthYearFromDate(resultMonthStartDate));
                resultMonthStartDate = resultMonthStartDate.AddMonths(1);
            }
            return monthList;
        }

        public static int GetLastForecastMonthYear(int periodId,DateTime date)
        {
            var lastForecastMonthyear = 0;
            switch (periodId)
            {
                case 1: // 1+7
                    lastForecastMonthyear = Convert.ToInt32(Helper.GetMonthYearFromDate(date.AddMonths(+6)));
                break;
                case 2: // 1+10
                    lastForecastMonthyear = Convert.ToInt32(Helper.GetMonthYearFromDate(date.AddMonths(+9)));
                break;
                case 3: // 1+12
                    lastForecastMonthyear = Convert.ToInt32(Helper.GetMonthYearFromDate(date.AddMonths(+11)));
                break;
                case 4: // 1+8
                    lastForecastMonthyear = Convert.ToInt32(Helper.GetMonthYearFromDate(date.AddMonths(+7)));
                    break;
            }
            return lastForecastMonthyear;
        }
    }

}
