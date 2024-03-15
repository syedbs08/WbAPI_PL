using Core.BaseUtility.MapperProfiles;
using Core.BaseUtility.Utility;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Command.RegionMaster;
using PSI.Modules.Backends.Masters.Repository.RegionMaster;


namespace PSI.Modules.Backends.Masters.CommandHandler.RegionMaster
{
    public class DeleteRegionCommandHandler : IRequestHandler<DeleteRegionCommand, Result>
    {
        private readonly IRegionRepository _regionRepository;
        public DeleteRegionCommandHandler(IRegionRepository regionRepository)
        {
            _regionRepository =regionRepository;
        }
        public async Task<Result> Handle(DeleteRegionCommand request, CancellationToken cancellationToken)
        {
            try
            {
                //update operatio will be seperated later
                if (request.RegionId > 0)
                {
                    var Region = await _regionRepository.GetById(request.RegionId);
                    if (Region == null)
                    {
                        return Result.Failure($"Region not found to delete {request.RegionId}");
                    }
                    Region.IsDeleted = true;
                    Region.IsActive = false;
                    Region.UpdateBy = request.UpdateBy;
                    var updateResult = _regionRepository.Update(Region);
                    if (updateResult == null)
                    {
                        Log.Error($"Region delete: Error occured while  {request.RegionId}");
                        return Result.Failure("Seems input value is not correct,Failed to delete Region");
                    }
                    return Result.Success;
                }
                return Result.Failure($"Region not found to delete {request.RegionId}");
            }
            catch (Exception ex)
            {
                Log.Error($"Execption occured while delete region {request.RegionId}", ex.Message);
                return Result.Failure("Problem in delete ,try later");
            }
        }
    }
}
