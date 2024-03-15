using Core.BaseUtility.MapperProfiles;
using Core.BaseUtility.Utility;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Command.CountryMaster;
using PSI.Modules.Backends.Masters.Repository.CountryMaster;

namespace PSI.Modules.Backends.Masters.CommandHandler.CountryMaster
{
    public class CreateCountryCommandHandler : IRequestHandler<CreateCountryCommand, Result>
    {
        private readonly ICountryRepository _countryRepository;
        public CreateCountryCommandHandler(ICountryRepository countryRepository)
        {
            _countryRepository = countryRepository;
        }
        public async Task<Result> Handle(CreateCountryCommand request, CancellationToken cancellationToken)
        {
            try
            {
                //update operatio will be seperated later
                if (request.Country.CountryId > 0)
                {
                    var country = await _countryRepository.GetById(request.Country.CountryId);
                    if (country == null)
                    {
                        return Result.Failure($"Country not found to update {request.Country.CountryId}");
                    }
                    country.CountryName = request.Country.CountryName;
                    country.CountryCode = request.Country.CountryCode;
                    country.IsActive = request.Country.IsActive;
                    country.CountryshortName = request.Country.CountryShortDesc;
                    country.CurrencyId = request.Country.CurrencyId;
                    country.UpdateDate = DateTime.Now;
                    var updateResult = _countryRepository.Update(country);
                    if (updateResult == null)
                    {
                        Log.Error($"Country update: Error occured while updating {request.Country}");
                        return Result.Failure("Seems input value is not correct,Failed to update Country");
                    }
                    return Result.Success;
                }
               
                var countryObject = MappingProfile<CountryCommand, Country>.Map(request.Country);
                if (countryObject == null)
                {
                    Log.Error($"Country Add: operation failed due to invalid mapping{request.Country}");
                    return Result.Failure("Seems input value is not correct,Failed to add Country");
                }                
                countryObject.CreatedDate = DateTime.Now;
                var result = await _countryRepository.Add(countryObject);
                if (result == null)
                {
                    Log.Error($"Country Add:Db operation failed{result}");
                    return Result.Failure("Error in adding Company,contact to support team");
                }
                return Result.Success;
            }
            catch (Exception ex)
            {
                Log.Error($"Execption occured while adding Company {request.Country}", ex.Message);
                return Result.Failure("Problem in adding Company ,try later");
            }
        }
    }
}
