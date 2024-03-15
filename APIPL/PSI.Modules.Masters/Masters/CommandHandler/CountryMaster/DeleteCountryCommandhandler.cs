using Core.BaseUtility.Utility;
using MediatR;
using PSI.Modules.Backends.Masters.Command.CountryMaster;
using PSI.Modules.Backends.Masters.Repository.CountryMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.CommandHandler.CountryMaster
{
    public class DeleteCountryCommandhandler : IRequestHandler<DeleteCountryCommand, Result>
    {
        private readonly ICountryRepository _countryRepository;
        public DeleteCountryCommandhandler(ICountryRepository countryRepository)
        {
            _countryRepository = countryRepository;
        }
        public async Task<Result> Handle(DeleteCountryCommand request, CancellationToken cancellationToken)
        {
            try
            {
                if (request.CountryId > 0)
                {
                    var country = await _countryRepository.GetById(request.CountryId);
                    if (country == null)
                    {
                        return Result.Failure($"Country not found to delete {request.CountryId}");
                    }
                    country.IsDeleted = true;
                    country.IsActive = false;
                    country.UpdateBy = request.UpdateBy;
                    var updateResult = _countryRepository.Update(country);
                    if (updateResult == null)
                    {
                        Log.Error($"Country delete: Error occured while  {request.CountryId}");
                        return Result.Failure("Seems input value is not correct,Failed to delete Country");
                    }
                    return Result.Success;
                }
                return Result.Failure($"Country not found to delete {request.CountryId}");
            }
            catch (Exception ex)
            {
                Log.Error($"Execption occured while delete country {request.CountryId}", ex.Message);
                return Result.Failure("Problem in delete ,try later");
            }
        }
    }
}
