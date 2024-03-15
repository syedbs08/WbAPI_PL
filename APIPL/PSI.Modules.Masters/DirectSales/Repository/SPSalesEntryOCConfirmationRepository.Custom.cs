using Microsoft.EntityFrameworkCore;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Constants;
using PSI.Modules.Backends.DirectSales.Command;

namespace PSI.Modules.Backends.DirectSales.Repository
{
    public partial interface ISPSalesEntryOCConfirmationRepository
    {
        IEnumerable<SP_SalesEntryOCConfirmation> GetCurrentMonthLock(OCOLockMonthSearchCommand searchCommand);
    }
    public partial class SPSalesEntryOCConfirmationRepository
    {       
        public IEnumerable<SP_SalesEntryOCConfirmation> GetCurrentMonthLock(OCOLockMonthSearchCommand searchCommand)
        {
            PSIDbContext _context = new ();
            var globalconfig = _context.GlobalConfig.ToList();
            var monthyear= globalconfig.Where(x=>x.ConfigKey== "Lock_Month").Select(x=>x.ConfigValue).FirstOrDefault()+','+ globalconfig.Where(x => x.ConfigKey == "Current_Month").Select(x => x.ConfigValue).FirstOrDefault();            
            var data = _context.SP_SalesEntryOCConfirmation.FromSql($"[dbo].[SP_SalesEntryOCConfirmation] {searchCommand.CountryId},{searchCommand.CustomerId},{searchCommand.CustomerTypeId},{searchCommand.ProductCategoryId},{searchCommand.ProductSubCategoryId},{monthyear}").AsNoTracking().ToList();
            return data;
        }
    }
}
