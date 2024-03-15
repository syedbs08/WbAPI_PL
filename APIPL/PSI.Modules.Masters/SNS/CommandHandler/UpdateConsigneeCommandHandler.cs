using AttachmentService.Repository;
using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Constants;
using PSI.Modules.Backends.Helpers;
using PSI.Modules.Backends.SNS.Command;
using System.Collections.Generic;
using System.Data;

namespace PSI.Modules.Backends.SNS.CommandHandler
{
    public class UpdateConsigneeCommandHandler : IRequestHandler<UpdateConsineeCommand, Result>
    {
        private readonly PSIDbContext _context;
        private readonly IGlobalConfigRepository _globalConfig;
        public UpdateConsigneeCommandHandler(IGlobalConfigRepository globalConfig)
        {           
            _context = new PSIDbContext();
            _globalConfig = globalConfig;
        }
        public async Task<Result> Handle(UpdateConsineeCommand request, CancellationToken cancellationToken)
        {
            try
            {
                var globalconfig = _globalConfig.GetAll();
                var resultMonthYear = Convert.ToInt32(globalconfig.Where(x => x.ConfigKey == "Result_Month").Select(x => x.ConfigValue).FirstOrDefault());
                var currentMonthYear = Convert.ToInt32(globalconfig.Where(x => x.ConfigKey == "Current_Month").Select(x => x.ConfigValue).FirstOrDefault());
                var lockMonthYear = Convert.ToInt32(globalconfig.Where(x => x.ConfigKey == "Lock_Month").Select(x => x.ConfigValue).FirstOrDefault());
                var forecasteMonthYearDate = (DateTime)(Helper.GetDateFromMonthYear(resultMonthYear.ToString()));
                var forecasteMonthYear = Convert.ToInt32(Helper.GetMonthYearFromDate(forecasteMonthYearDate.AddMonths(+7))); ;
                var resultMonthStartDate = Helper.GetDateFromMonthYear(resultMonthYear.ToString());

                var userId = new SqlParameter("@userId", SqlDbType.NVarChar,100);
                userId.Value = request.SessionData.ADUserId;

                var pAccountCode = new SqlParameter("@accountCode", SqlDbType.NVarChar,20);
                pAccountCode.Value = request.AccountCode;

                var paramCurrentMonth = new SqlParameter("@currentMonth", SqlDbType.Int);
                paramCurrentMonth.Value = currentMonthYear;

                var paramlockMonth = new SqlParameter("@lockMonth", SqlDbType.Int);
                paramlockMonth.Value = lockMonthYear;

                var paramResultMonth = new SqlParameter("@resultMonth", SqlDbType.Int);
                paramResultMonth.Value = resultMonthYear;

                var paramlastForecastMonth = new SqlParameter("@lastForecastMonth", SqlDbType.Int);
                paramlastForecastMonth.Value = forecasteMonthYear;

                var param = new SqlParameter[] {
                    userId,
                    paramCurrentMonth,
                    paramlockMonth,
                    paramResultMonth,
                    paramlastForecastMonth,
                    pAccountCode,
                };
          
                var result = _context.Sp_UpdateConsinee.FromSqlRaw("dbo.Sp_UpdateConsinee @userId ,@accountCode,@currentMonth,@lockMonth,@resultMonth,@lastForecastMonth", param).AsNoTracking().ToList();
               // var result = _context.SP_ResponseResult.FromSqlRaw("dbo.SP_Insert_TRNPricePlanning @userId ,@currentMonth,@lockMonth,@resultMonth,@lastForecastMonth,@accountCode", param).AsNoTracking().ToList();
                if (result.Count() > 0)
                {
                    var spResult = result.Where(r => r.ResponseCode == "500").FirstOrDefault();
                    if(spResult!=null)
                    {
                        var errorResult = new List<Sp_UpdateConsinee>(){
                                new Sp_UpdateConsinee{
                                    ResponseCode = "500",
                                    ResponseMessage = Contants.ERROR_MSG,
                                }
                            };
                        return Result.SuccessWith<List<Sp_UpdateConsinee>>(errorResult);
                    }
                    else
                    {
                        var successRespone = result.Where(r => r.ResponseCode == "200").ToList();
                        return Result.SuccessWith<List<Sp_UpdateConsinee>>(successRespone);
                    }
                   
                }
                else
                {
                    var successRespone = result.Where(r => r.ResponseCode == "200").ToList();
                    return Result.SuccessWith<List<Sp_UpdateConsinee>>(successRespone);

                }
              
            }
            catch (Exception ex)
            {
                Log.Error($"Error in updating consignee  - {ex.Message}. StackTrace - {ex.StackTrace}");
                return Result.Failure($"Error occurred{ex.Message}");
               
               
            }
           
        }

    }
}
