using Core.BaseUtility.Utility;
using MediatR;

namespace PSI.Modules.Backends.Masters.Command.CountryMaster
{
    public class DeleteCountryCommand : IRequest<Result>
    {
        public DeleteCountryCommand(int countryId, string updateBy)
        {
            CountryId = countryId;
            UpdateBy = updateBy;
        }
        public int CountryId { get; set; }
        public string UpdateBy { get; set; }
    }
}
