using Core.BaseUtility.MapperProfiles;
using Core.BaseUtility.Utility;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Command.AccountMaster;
using PSI.Modules.Backends.Masters.Command.Report;
using PSI.Modules.Backends.Masters.Repository.AccountMaster;
using PSI.Modules.Backends.Masters.Repository.Report;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.CommandHandler.Report
{
    public class CreateReportCommandHandler : IRequestHandler<CreateReportCommand, Result>
    {
        private readonly IReportVariantRepository _reportVariantRepository;

        public CreateReportCommandHandler(IReportVariantRepository reportVariantRepository)
        {
            _reportVariantRepository = reportVariantRepository;

        }
        public async Task<Result> Handle(CreateReportCommand request, CancellationToken cancellationToken)
        {
            try
            {
                List<ReportVariant> variants = new List<ReportVariant>();
                if (request.report.ReportVariantId>0)
                {
                    var res = _reportVariantRepository.GetReportVariantByName(request.report.VariantName);
                    if (res == null)
                    {
                        return Result.Failure($"Variant not found to update {request.report.ReportVariantId}");
                    }
                    await _reportVariantRepository.Delete(res.ToList());
                   
                    foreach (var data in request.report.ColumnName)
                    {
                        ReportVariant reportVariant = new ReportVariant();
                        reportVariant.UserId = request.report.UserId;
                        reportVariant.ReportType = request.report.ReportType;
                        reportVariant.VariantName = request.report.VariantName;
                        reportVariant.ColumnName = data;
                        reportVariant.UserId = request.report.UserId;
                        reportVariant.CreatedDate = DateTime.Now;
                        variants.Add(reportVariant);
                    }
                    var resultUpdate = await _reportVariantRepository.AddBulk(variants);
                    if (resultUpdate == null)
                    {
                        Log.Error($"ReportVariant update:Db operation failed{resultUpdate}");
                        return Result.Failure("Error in updating variant,contact to support team");
                    }
                    return Result.Success;
                }
                var exist = _reportVariantRepository.GetVariant(request.report.UserId, request.report.ReportType, request.report.VariantName);
                if (exist != null)
                {
                    return Result.Failure("Variant name already exist in database");
                }
                foreach (var data in request.report.ColumnName)
                {
                    ReportVariant reportVariant = new ReportVariant();
                    reportVariant.UserId = request.report.UserId;
                    reportVariant.ReportType = request.report.ReportType;
                    reportVariant.VariantName = request.report.VariantName;
                    reportVariant.ColumnName = data;
                    reportVariant.UserId = request.report.UserId;
                    reportVariant.CreatedDate = DateTime.Now;
                    variants.Add(reportVariant);
                }
                var result = await _reportVariantRepository.AddBulk(variants);
                if (result == null)
                {
                    Log.Error($"ReportVariant Add:Db operation failed{result}");
                    return Result.Failure("Error in adding variant,contact to support team");
                }
                return Result.Success;

            }
            catch (Exception ex)
            {

                Log.Error($"Execption occured while adding ReportVariant {request.report}", ex.Message);
                return Result.Failure("Problem in adding variant ,try later");

            }
        }
    }
}