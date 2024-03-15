using Core.BaseUtility.Utility;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Constants;
using PSI.Modules.Backends.Masters.Command.LockPSIMaster;
using PSI.Modules.Backends.Masters.Repository.LockPSIMaster;

namespace PSI.Modules.Backends.Masters.CommandHandler.LockPSIMaster
{
    public class CreateLockPSICommandHandler : IRequestHandler<CreateLockPSICommand, Result>
    {
        private readonly ILockPSIRepository _lockPSIRepository;
        public CreateLockPSICommandHandler(ILockPSIRepository lockPSIRepository)
        {
            _lockPSIRepository = lockPSIRepository;
        }
        public async Task<Result> Handle(CreateLockPSICommand request, CancellationToken cancellationToken)
        {
            try
            {
                List<LockPSI> addlist = new List<LockPSI>();
                List<LockPSI> updatelist = new List<LockPSI>();
                var lockPsidata = _lockPSIRepository.GetAll();
                foreach (var item1 in request.LockPSI.UserIds)
                {
                    LockPSI lockPSI = new LockPSI();
                    lockPSI= GetlockPSI(request.LockPSI.Types);
                    var exist = lockPsidata.Where(x => x.UserId == item1).FirstOrDefault();
                    if (exist == null)
                    {
                        lockPSI.UserId = item1;
                        //lockPSI.CustomerCode = request.LockPSI.CustomerId;
                        //lockPSI.SubcategoryId = request.LockPSI.SubcategoryId;
                        lockPSI.CreatedDate = DateTime.Now;
                        lockPSI.CreatedBy = request.Session.Name;
                        addlist.Add(lockPSI);

                    }
                    else
                    {
                        lockPSI.UserId = item1;
                       // lockPSI.CustomerId = request.LockPSI.CustomerId;
                       // lockPSI.SubcategoryId = request.LockPSI.SubcategoryId;
                        lockPSI.UpdatedDate = DateTime.Now;
                        lockPSI.LockPSIId = exist.LockPSIId;
                        lockPSI.UpdatedBy = request.Session.Name;
                        updatelist.Add(lockPSI);
                    }

                }
                var result = await _lockPSIRepository.AddBulk(addlist);
                var updateresult = await _lockPSIRepository.UpdateBulk(updatelist);
                if (result == null)
                {
                    Log.Error($"Lock PSI Add:Db operation failed{result}");
                    return Result.Failure("Error in adding Lock PSI,contact to support team");
                }
                return Result.Success;
            }
            catch (Exception ex)
            {
                Log.Error($"Execption occured while adding Lock PSI {request.LockPSI}", ex.Message);
                return Result.Failure("Problem in adding Lock PSI ,try later");
            }
        }
        public LockPSI GetlockPSI(string[] Types)
        {
            LockPSI lockPSI = new LockPSI();
            if (Types.Length > 0)
            {
                foreach (var item in Types)
                {
                    if (item == Contants.OPSI_Upload)
                    {
                        lockPSI.OPSI_Upload = true;
                    }
                    
                    if (item == Contants.COG_Upload)
                    {
                        lockPSI.COG_Upload = true;
                    }
                   
                    if (item == Contants.O_LockMonthConfirm)
                    {
                        lockPSI.O_LockMonthConfirm = true;
                    }
                    
                    if (item == Contants.OC_IndicationMonth)
                    {
                        lockPSI.OC_IndicationMonth = true;
                    }
                   
                    if (item == Contants.BP_Upload_DirectSale)
                    {
                        lockPSI.BP_Upload_DirectSale = true;
                    }
                  
                    if (item == Contants.BP_Upload_SNS)
                    {
                        lockPSI.BP_Upload_SNS = true;
                    }
                   
                    if (item == Contants.BP_COG_Upload)
                    {
                        lockPSI.BP_COG_Upload = true;
                    }
                    
                    if (item == Contants.ADJ_Upload)
                    {
                        lockPSI.ADJ_Upload = true;
                    }
                    
                    if (item == Contants.SSD_Upload)
                    {
                        lockPSI.SSD_Upload = true;
                    }
                    
                    if (item == Contants.SNS_Sales_Upload)
                    {
                        lockPSI.SNS_Sales_Upload = true;
                    }
                   
                    if (item == Contants.Forecast_Projection)
                    {
                        lockPSI.Forecast_Projection = true;
                    }
                    if (item == Contants.SNS_Planning)
                    {
                        lockPSI.SNS_Planning = true;
                    }
                }
            }
            else
            {

                lockPSI.OPSI_Upload = false;
                lockPSI.COG_Upload = false;
                lockPSI.O_LockMonthConfirm = false;
                lockPSI.OC_IndicationMonth = false;
                lockPSI.OC_IndicationMonth = false;
                lockPSI.BP_Upload_SNS = false;
                lockPSI.BP_COG_Upload = false;
                lockPSI.ADJ_Upload = false;
                lockPSI.SSD_Upload = false;
                lockPSI.SNS_Sales_Upload = false;
                lockPSI.Forecast_Projection = false;
                lockPSI.SNS_Planning = false;
            }
            return lockPSI;
        }
    }
}
