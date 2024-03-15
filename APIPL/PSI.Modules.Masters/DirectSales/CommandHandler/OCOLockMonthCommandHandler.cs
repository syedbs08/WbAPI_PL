using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.EntityFrameworkCore;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.DirectSales.Command;
using PSI.Modules.Backends.DirectSales.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.DirectSales.CommandHandler
{
    /// <summary>
    /// 
    /// </summary>
    public class OCOLockMonthCommandHandler : IRequestHandler<CreateOCOLockMonthCommand, Result>
    {
        private readonly IOcoLockMonthRepository _lockMonthRepository;
        private readonly ISalesEntryPriceQuantityRepository _salesEntryPriceQuantity;
        private readonly ISalesEntryRepository _salesEntryRepository;
        private readonly ISaleEntryHeaderRepository _saleEntryHeaderRepository;
        private readonly PSIDbContext _context;

        public OCOLockMonthCommandHandler(IOcoLockMonthRepository ocoLockMonthRepository, 
            ISalesEntryPriceQuantityRepository salesEntryPriceQuantity,
            ISalesEntryRepository salesEntryRepository,
            ISaleEntryHeaderRepository saleEntryHeaderRepository
            )
        {
            _lockMonthRepository = ocoLockMonthRepository;
            _salesEntryPriceQuantity = salesEntryPriceQuantity;
            _salesEntryRepository = salesEntryRepository;
            _saleEntryHeaderRepository = saleEntryHeaderRepository;
            _context = new PSIDbContext();
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        /// <param name="cancellationToken"></param>
        /// <returns></returns>
        public async Task<Result> Handle(CreateOCOLockMonthCommand request, CancellationToken cancellationToken)
        {
            try
            {
                if (request.OCOLockMonths != null && request.OCOLockMonths.Count() > 0)
                {

                    //Remove sale entry data which has confirmed 
                    var oldPriceQtyId = request.OCOLockMonths.Select(x => x.OldSaleEntryId).ToList();
                    var saleEntryEntryQty = _salesEntryRepository.GetSalesEntryBySalesEntryIds(oldPriceQtyId).ToList();
                    List<string> customerCodes = saleEntryEntryQty.Select(x=>x.CustomerCode).ToList();
                    List<string> materialCodes = saleEntryEntryQty.Select(x => x.MaterialCode).ToList();
                    List<string> subCateCodes = (from m in _context.Materials
                                                 join p in _context.ProductCategories
                                                 on m.ProductCategoryId2 equals p.ProductCategoryId
                                                 where p.CategoryLevel == 2 && materialCodes.Contains(m.MaterialCode)
                                                 select p.ProductCategoryCode).Distinct().ToList();

                    var checkPermissionToUpdateRecord = _context.LockPSI.Where(x => x.UserId == request.Session.ADUserId && customerCodes.Contains(x.CustomerCode) && x.OC_IndicationMonth == true && subCateCodes.Contains(x.SubCategoryCode)).Distinct().ToList();
                    if (checkPermissionToUpdateRecord.Any())
                    {
                        string customer = string.Join(", ", checkPermissionToUpdateRecord.Select(item => item.CustomerCode).Distinct());
                        string mg1s = string.Join(", ", checkPermissionToUpdateRecord.Select(item => item.SubCategoryCode).Distinct());
                        return Result.Failure("You don't have permission to update oc indication month of these customer(" + customer + ") and MG1(" + mg1s + ").Please contact to admin");
                    }
                 
                    await _salesEntryRepository.Delete(saleEntryEntryQty);
                    //Get all sales entry records from repo
                    List<int> salesEntryPriceQuantityIds = request.OCOLockMonths.Select(x=>x.SalesEntryId).ToList();
                   // List<int> salesEntryIds = request.OCOLockMonths.Select(x => x.SalesEntryId).ToList();
                    var salesEntryPriceResult = _lockMonthRepository.GetSalesEntryPriceByIds(salesEntryPriceQuantityIds).ToList();
                    salesEntryPriceResult.ForEach(f => f.OCstatus = "Y");
                    await _salesEntryRepository.UpdateBulk(salesEntryPriceResult);

                   
                    
                    return Result.Success;
                }
                else
                {
                    return Result.Failure("Error in OCO Lock & Current Month Confirm");
                }
            }
            catch (Exception ex)
            {
                Log.Error($"Execption occured while updating OCO Lock & Current Month", ex.Message);
                return Result.Failure("Problem in OCO Lock & Current Month Confirm ,try later");
            }

        }
    }
}
