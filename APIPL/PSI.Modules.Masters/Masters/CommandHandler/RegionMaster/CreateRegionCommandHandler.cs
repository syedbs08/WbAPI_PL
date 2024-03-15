using Core.BaseUtility.MapperProfiles;
using Core.BaseUtility.Utility;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Command.RegionMaster;
using PSI.Modules.Backends.Masters.Repository.RegionMaster;


namespace PSI.Modules.Backends.Masters.CommandHandler.RegionMaster
{
    public class CreateRegionCommandHandler : IRequestHandler<CreateRegionCommand, Result>
    {
        private readonly IRegionRepository _regionRepository;
        public CreateRegionCommandHandler(IRegionRepository regionRepository)
        {
            _regionRepository =regionRepository;
        }
        public async Task<Result> Handle(CreateRegionCommand request, CancellationToken cancellationToken)
        {
            try
            {
                //update operatio will be seperated later
                if (request.Region.RegionId > 0)
                {
                    var Region = await _regionRepository.GetById(request.Region.RegionId);
                    if (Region == null)
                    {
                        return Result.Failure($"Region not found to update {request.Region.RegionId}");
                    }
                    Region.RegionName = request.Region.RegionName;
                    Region.RegionCode = request.Region.RegionCode;
                    Region.IsActive = request.Region.IsActive;
                    Region.RegionShortDescription = request.Region.RegionShortDescription;
                    Region.UpdateBy= request.Region.UpdateBy;
                    var updateResult = _regionRepository.Update(Region);
                    if (updateResult == null)
                    {
                        Log.Error($"Region update: Error occured while updating {request.Region}");
                        return Result.Failure("Seems input value is not correct,Failed to update Region");
                    }
                    return Result.Success;
                }

                var RegionObject = MappingProfile<RegionCommand, Region>.Map(request.Region);
                if (RegionObject == null)
                {
                    Log.Error($"Region Add: operation failed due to invalid mapping{request.Region}");
                    return Result.Failure("Seems input value is not correct,Failed to add Region");
                }
                RegionObject.CreatedBy = request.Region.CreatedBy;
                var result = await _regionRepository.Add(RegionObject);
                if (result == null)
                {
                    Log.Error($"Region Add:Db operation failed{result}");
                    return Result.Failure("Error in adding Region,contact to support team");
                }
                return Result.Success;

            }
            catch (Exception ex)
            {

                Log.Error($"Execption occured while adding Region {request.Region}", ex.Message);
                return Result.Failure("Problem in adding Region ,try later");

            }
        }
    }
}
