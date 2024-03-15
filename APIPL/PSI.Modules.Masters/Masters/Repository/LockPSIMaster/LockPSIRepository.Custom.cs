using Core.BaseEntitySql.BaseRepository;
using Core.BaseUtility.Utility;
using NPOI.HSSF.Record;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.PSILockMaster;
using System.Linq;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;

namespace PSI.Modules.Backends.Masters.Repository.LockPSIMaster
{
    public partial interface ILockPSIRepository
    {
        LockPSI CheckLockPSIByUserId(PSILockSearchQuery searchItems);
        IEnumerable<LockPSI> GetByUserIdCustomerCode(string[] userIds, string[] customerCode, string[] productCategory);
        Result UpdateOrInsertLockPSI(IEnumerable<LockPSI> command, string userId, string loggedInUser);
        Result UpdateOrInsertAllLockUser(bool isBlock, string loggedInUser, string[] customerCodes, string[] productCodes, string[] userIds);
    }
    public partial class LockPSIRepository
    {
        public LockPSI CheckLockPSIByUserId(PSILockSearchQuery search)
        {           
          return Get(Query.WithFilter(Filter<LockPSI>.Create(p => p.UserId == search.UserId))).FirstOrDefault();          
        }
        public IEnumerable<LockPSI> GetByUserIdCustomerCode(string[] userIds, string[] customerCode, string[] productCategory)
        {
            return Get(Query.WithFilter(Filter<LockPSI>.Create(p => userIds.Contains( p.UserId)
                && productCategory.Contains(p.SubCategoryCode) && customerCode.Contains(p.CustomerCode)
                )));
        }

        public Result UpdateOrInsertLockPSI(IEnumerable<LockPSI> command,string userId,string loggedInUser)
        {
            try
            {
                var customerCodes = command.Select(x => x.CustomerCode).ToArray();
                var productCodes = command.Select(x => x.SubCategoryCode).ToArray();
                var userIds = command.Select(x => x.UserId).ToArray();
                var existingRecord = GetByUserIdCustomerCode(userIds, customerCodes, productCodes).ToList();

                var datatoAdd = command.Where(x => !existingRecord.Any(y => y.UserId == x.UserId && y.CustomerCode == x.CustomerCode &&
                 y.SubCategoryCode == x.SubCategoryCode)).ToList();

                var datatoUpdate = existingRecord.Where(x => command.Any(y => y.UserId == x.UserId && y.CustomerCode == x.CustomerCode &&
                 y.SubCategoryCode == x.SubCategoryCode)).ToList();

                if (datatoAdd.Any())
                {
                    datatoAdd.ForEach(x => { x.CreatedDate = DateTime.Now; x.CreatedBy = loggedInUser; });
                    AddBulk(datatoAdd);
                }
                if (datatoUpdate.Any())
                {
                    datatoUpdate.ForEach(x =>
                    {
                        x.UpdatedDate = DateTime.Now;
                        x.UpdatedBy = loggedInUser;
                        x.OPSI_Upload = GetUpdatedData(x.UserId, x.CustomerCode, x.SubCategoryCode, command)?.OPSI_Upload ?? false;
                        x.COG_Upload = GetUpdatedData(x.UserId, x.CustomerCode, x.SubCategoryCode, command)?.COG_Upload ?? false;
                        x.O_LockMonthConfirm = GetUpdatedData(x.UserId, x.CustomerCode, x.SubCategoryCode, command)?.O_LockMonthConfirm ?? false;
                        x.OC_IndicationMonth = GetUpdatedData(x.UserId, x.CustomerCode, x.SubCategoryCode, command)?.OC_IndicationMonth ?? false;
                        x.BP_Upload_DirectSale = GetUpdatedData(x.UserId, x.CustomerCode, x.SubCategoryCode, command)?.BP_Upload_DirectSale ?? false;
                        x.BP_Upload_SNS = GetUpdatedData(x.UserId, x.CustomerCode, x.SubCategoryCode, command)?.BP_Upload_SNS ?? false;
                        x.BP_COG_Upload = GetUpdatedData(x.UserId, x.CustomerCode, x.SubCategoryCode, command)?.BP_COG_Upload ?? false;
                        x.ADJ_Upload = GetUpdatedData(x.UserId, x.CustomerCode, x.SubCategoryCode, command)?.ADJ_Upload ?? false;
                        x.SSD_Upload = GetUpdatedData(x.UserId, x.CustomerCode, x.SubCategoryCode, command)?.SSD_Upload ?? false;
                        x.SNS_Sales_Upload = GetUpdatedData(x.UserId, x.CustomerCode, x.SubCategoryCode, command)?.SNS_Sales_Upload ?? false;
                        x.Forecast_Projection = GetUpdatedData(x.UserId, x.CustomerCode, x.SubCategoryCode, command)?.Forecast_Projection ?? false;
                        x.SNS_Planning = GetUpdatedData(x.UserId, x.CustomerCode, x.SubCategoryCode, command)?.SNS_Planning ?? false;
                    });
                    UpdateBulk(datatoUpdate);
                }
                return Result.Success;

            }
            catch (Exception ex)
            {
                return Result.Failure(ex.Message);
            }
            


        }
        private LockPSI GetUpdatedData(string userId, string customerCode, string subCategoryCode,IEnumerable<LockPSI> command)
        {
            return command.FirstOrDefault(x => x.UserId == userId && x.CustomerCode == customerCode && x.SubCategoryCode == subCategoryCode);
        
        }
        public Result UpdateOrInsertAllLockUser(bool isBlock,  string loggedInUser, string[] customerCodes, string[]  productCodes, string[] userIds)
        {
            try
            {
             
                var existingRecord = GetByUserIdCustomerCode(userIds, customerCodes, productCodes).ToList();
                var data=  GetAll();
                var datatoAdd = data.Where(x => !existingRecord.Any(y => y.UserId == x.UserId && y.CustomerCode == x.CustomerCode &&
                y.SubCategoryCode == x.SubCategoryCode)).ToList();

                var datatoUpdate = existingRecord.Where(x => data.Any(y => y.UserId == x.UserId && y.CustomerCode == x.CustomerCode &&
                 y.SubCategoryCode == x.SubCategoryCode)).ToList();

                if (datatoAdd.Any())
                {
                    datatoAdd.ForEach(x => { x.CreatedDate = DateTime.Now; x.CreatedBy = loggedInUser; });
                    AddBulk(datatoAdd);
                }
                if (datatoUpdate.Any())
                {
                    datatoUpdate.ForEach(x =>
                    {
                        x.UpdatedDate = DateTime.Now;
                        x.UpdatedBy = loggedInUser;
                        x.OPSI_Upload = isBlock;
                        x.COG_Upload = isBlock;
                        x.O_LockMonthConfirm = isBlock;
                        x.OC_IndicationMonth = isBlock;
                        x.BP_Upload_DirectSale = isBlock;
                        x.BP_Upload_SNS = isBlock;
                        x.BP_COG_Upload = isBlock;
                        x.ADJ_Upload = isBlock;
                        x.SSD_Upload = isBlock;
                        x.SNS_Sales_Upload = isBlock;
                        x.Forecast_Projection = isBlock;
                        x.SNS_Planning = isBlock;
                    });
                    UpdateBulk(datatoUpdate);
                }
                return Result.Success;

            }
            catch (Exception ex)
            {
                return Result.Failure(ex.Message);
            }

        }
    }
}
