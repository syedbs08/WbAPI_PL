using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AttachmentService
{
    public class AttachmentConstant
    {
        public enum FileTypes
        { 
         Currency=1,
         DirectSales=2,
         SNS=3,
         StockPrice=4,
         PSIDates=5,
         Adjustment=6,
         TurnOverDates=7,
         OCIndicationMonth=8,
         SSDForecast = 9

        }
        public static readonly string[] FolderNames = { "direct-sales", "adjustment-files", "currency-master",
                                                        "ocindicationmonth", "psidates", "sns-files", "stock-price", "turnoverdays",
                                                        "ssd-forecast" , "cog-files","dash-transmit" };
    }
}
