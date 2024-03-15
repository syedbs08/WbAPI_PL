using Core.BaseEntitySql.BaseRepository;
using Microsoft.EntityFrameworkCore;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Constants;
using PSI.Modules.Backends.DirectSales.Command;
using PSI.Modules.Backends.DirectSales.Results;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.DirectSales.Repository
{
    public partial interface IOcoLockMonthRepository
    {
        IEnumerable<SalesEntry> GetSalesEntryByIds(List<int> ids);
        IEnumerable<SalesEntry> GetSalesEntryPriceByIds(List<int> ids);
        IEnumerable<OCOLockMonthResult> GetCurrentMonthLock(OCOLockMonthSearchCommand searchCommand);
    }
    public partial class OcoLockMonthRepository
    {
        public IEnumerable<SalesEntry> GetSalesEntryPriceByIds(List<int> ids)
        {
            var result = Query.WithFilter(Filter<SalesEntry>.Create(p => ids.Contains(p.SalesEntryId) && p.OCstatus == "N"));
            return Get(result);
        }
        public IEnumerable<SalesEntry> GetSalesEntryByIds(List<int> ids)
        {
            var result = Query.WithFilter(Filter<SalesEntry>.Create(p => ids.Contains(p.SalesEntryId) && p.OCstatus == "N"));
            return Get(result);
        }
        public IEnumerable<OCOLockMonthResult> GetCurrentMonthLock(OCOLockMonthSearchCommand searchCommand)
        {
            PSIDbContext _context = new ();
            var globalconfig = _context.GlobalConfig.ToList();
            var monthyear = globalconfig.Where(x => x.ConfigKey == "Lock_Month").Select(x => x.ConfigValue).FirstOrDefault() + ',' + globalconfig.Where(x => x.ConfigKey == "Current_Month").Select(x => x.ConfigValue).FirstOrDefault();
            var data = _context.SP_OcoLockMonths.FromSql($"[dbo].[SP_OcoLockMonth]  {searchCommand.CountryId},{searchCommand.CustomerId},{searchCommand.CustomerTypeId},{searchCommand.ProductCategoryId},{searchCommand.ProductSubCategoryId},{monthyear}").AsNoTracking().ToList();
            var ocoLockMonth = data.Select(x => new OCOLockMonthResult
            {
                Difference = x.Difference,
                IsSNS = x.IsSNS,
                ConfirmedQty = x.ConfirmedQty,
                CurrentMonthQty = x.CurrentMonthQty,
                LockConfirmedQty  = x.LockConfirmedQty,
                LockCurrentQty= x.LockCurrentQty,              
                SalesEntryId = x.SalesEntryId,
                CustomerCode = x.CustomerCode,
                CustomerName = x.CustomerName,
                Mg = x.Mg,
                Mg1 = x.Mg1,
                MaterialCode = x.MaterialCode,
                MonthYear = x.MonthYear,
            });
            return ocoLockMonth;
        }
    }
}
