using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.EntityFrameworkCore;
using PSI.Domains;
using PSI.Modules.Backends.SNS.Command;

namespace PSI.Modules.Backends.SNS.CommandHandler
{
    public class RunPriceProcessHandler : IRequestHandler<RunPriceProcessCommand, Result>
    {
        private readonly PSIDbContext _context;
        public RunPriceProcessHandler()
        {
            _context = new PSIDbContext();
        }
        public async Task<Result> Handle(RunPriceProcessCommand request, CancellationToken cancellationToken)
        {
            try
            {
                var result = await _context.USP_UpdateFinalPrice.FromSql($"SP_UPDATEPRICE {request.CurrentMonth}").AsNoTracking().ToListAsync();
                return Result.SuccessWith(result);
            }
            catch (Exception ex)
            {
                Log.Error($"Execption occured while running run price process", ex.Message);
                return Result.Failure("Problem in run price process,try later");
            }
        }
    }
}
