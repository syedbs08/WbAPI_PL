using Core.BaseUtility.Utility;
using MediatR;
using PSI.Domains.Entity;
using PSI.Domains;
using PSI.Modules.Backends.SNS.Command;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace PSI.Modules.Backends.SNS.CommandHandler
{
    public class RollingInventorySnsBPHandler : IRequestHandler<RollingInventorySnsBPCommand, Result>
    {
        private readonly PSIDbContext _context;
     
        public RollingInventorySnsBPHandler()
        {
            _context = new PSIDbContext();
        }
        public async Task<Result> Handle(RollingInventorySnsBPCommand request, CancellationToken cancellationToken)
        {
            try
            {
           
                var result = await _context.SP_Insert_TRNSalesPlanning_BP.FromSql($"SP_INSERT_TRNSALESPLANNING_BP {request.UserId},{request.AccountCode}").AsNoTracking().ToListAsync();
                if (result.Any())
                {

                    if (result.Where(x=>x.ResponseCode== "500").Count()>0)
                    {
                        Log.Error($"Execption occured while RollingInventory BP");
                        return Result.Failure("Problem in  RollingInventory BP ,try later");
                    }
                    else
                    {
                        var resultPriceplanning = await _context.SP_Insert_TRNSalesPlanning_BP.FromSql($"SP_CALCULATE_ROLLINGINVENTORY_BP {request.UserId},{request.AccountCode}").AsNoTracking().ToListAsync();
                        if (resultPriceplanning.Count() > 0)
                        {
                            Log.Error($"Execption occured while RollingInventory BP");
                            return Result.Failure("Problem in  RollingInventory BP ,try later");
                        }
                        else
                        {
                            return Result.Success;
                        }
                    }
                }

                return Result.Success;
            }
            catch (Exception ex)
            {
                Log.Error($"Execption occured while RollingInventory BP data", ex.Message);
                return Result.Failure("Problem in  RollingInventory BP ,try later");
            }
        }

    }
}

