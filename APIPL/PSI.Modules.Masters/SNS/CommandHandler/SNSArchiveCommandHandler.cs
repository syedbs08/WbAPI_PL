using Core.BaseUtility.Utility;
using DevExtreme.AspNet.Data.ResponseModel;
using DevExtreme.AspNet.Data;
using MediatR;
using Microsoft.EntityFrameworkCore;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.DirectSales.Command;
using PSI.Modules.Backends.SNS.Command;
using PSI.Modules.Backends.SNS.Queries;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PSI.Modules.Backends.Masters.Repository.GlobalConfigMaster;

namespace PSI.Modules.Backends.SNS.CommandHandler
{
    public class SNSArchiveCommandHandler : IRequestHandler<SNSArchiveCommand, Result>
    {
        private readonly PSIDbContext _context;
        private readonly IGlobalConfigRepository _globalConfigRepository;
        public SNSArchiveCommandHandler(IGlobalConfigRepository globalConfigRepository)
        {
            _context = new PSIDbContext();
            _globalConfigRepository = globalConfigRepository;
        }
        public async Task<Result> Handle(SNSArchiveCommand request, CancellationToken cancellationToken)
        {
            try
            {
                DateTime current_Month;
                DateTime lock_Month;
                string currentMonth = "";
                string lockMonth = "";
                List<GlobalConfig> globalConfigs = new List<GlobalConfig>();
                if (request.SNSArchiveData.Type == "Direct & SNS")
                {
                    DateTime nextmonth = DateTime.ParseExact(Convert.ToString(request.SNSArchiveData.Month), "yyyyMM", CultureInfo.InvariantCulture);
                    current_Month = nextmonth.AddMonths(1);
                    lock_Month = nextmonth.AddMonths(2);
                    currentMonth = current_Month.ToString("yyyyMM");
                    lockMonth = lock_Month.ToString("yyyyMM");
                }
                request.SNSArchiveData.Type = request.SNSArchiveData.Type == "BP" ? "BP" : "Monthly";
                if (request.SNSArchiveData.Type == "BP")
                {
                    var archivesDirect = await _context.SP_ResponseResult.FromSql($"SP_DIRECTSALE_BP_ARCHIVE {request.SNSArchiveData.Month},{request.SessionData.ADUserId},{request.SNSArchiveData.Type}").AsNoTracking().ToListAsync();
                    var archives = await _context.SP_ResponseResult.FromSql($"SP_SNS_BP_ARCHIVE {request.SNSArchiveData.Month},{request.SessionData.ADUserId},{request.SNSArchiveData.Type}").AsNoTracking().ToListAsync();
                    var archives_cog = await _context.SP_ResponseResult.FromSql($"SP_COG_BP_ARCHIVE {request.SNSArchiveData.Month},{request.SessionData.ADUserId},{request.SNSArchiveData.Type}").AsNoTracking().ToListAsync();
                    if (archivesDirect.Count() == 0 && archives.Count()==0 && archives_cog.Count() == 0)
                    {
                        return Result.Success;
                    }
                    else
                    {

                        Log.Error($"Execption occured while BP archive data{archivesDirect} +' '+{archives} +' '+{archives_cog}");
                        return Result.Failure("Problem in  archive data ,try later");
                    }
                }
                else
                {
                    var archives_direct = await _context.SP_ResponseResult.FromSql($"SP_DIRECTSALE_MONTHLY_ARCHIVE {request.SNSArchiveData.Month},{request.SessionData.ADUserId},{request.SNSArchiveData.Type}").AsNoTracking().ToListAsync();
                    var archives_sns = await _context.SP_ResponseResult.FromSql($"SP_SNS_MONTHLY_ARCHIVE {request.SNSArchiveData.Month},{request.SessionData.ADUserId},{request.SNSArchiveData.Type}").AsNoTracking().ToListAsync();
                    var archives_adj = await _context.SP_ResponseResult.FromSql($"SP_ADJ_MONTHLY_ARCHIVE {request.SNSArchiveData.Month},{request.SessionData.ADUserId},{request.SNSArchiveData.Type}").AsNoTracking().ToListAsync();
                    var archives_ssd = await _context.SP_ResponseResult.FromSql($"SP_SSD_MONTHLY_ARCHIVE {request.SNSArchiveData.Month},{request.SessionData.ADUserId},{request.SNSArchiveData.Type}").AsNoTracking().ToListAsync();
                    var archives_cog = await _context.SP_ResponseResult.FromSql($"SP_COG_MONTHLY_ARCHIVE {request.SNSArchiveData.Month},{request.SessionData.ADUserId},{request.SNSArchiveData.Type}").AsNoTracking().ToListAsync();
                    if (archives_sns.Count()==0 && archives_direct.Count()==0 && archives_adj.Count() == 0 && archives_ssd.Count() == 0 && archives_cog.Count() == 0)
                    {
                        return Result.Success;

                    }
                    else
                    {
                        Log.Error($"Execption occured while monthly archive data{archives_direct} +' '+{archives_sns} +' '+{archives_adj} +' '+{archives_ssd} +' '+{archives_cog}");
                        return Result.Failure("Problem in  archive data ,try later");
                    }
                }




                return Result.Success;
            }
            catch (Exception ex)
            {
                Log.Error($"Execption occured while archive data", ex.Message);
                return Result.Failure("Problem in  archive data ,try later");
            }
        }

    }
}
