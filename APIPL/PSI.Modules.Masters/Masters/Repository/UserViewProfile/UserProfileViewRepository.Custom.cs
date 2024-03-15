using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.UserViewProfile;
using PSI.Modules.Backends.Masters.Repository.CountryMaster;
using PSI.Modules.Backends.Masters.Results;

namespace PSI.Modules.Backends.Masters.Repository.UserViewProfile
{
    public partial interface IUserViewProfileRepository
    {
        IEnumerable<UserProfileView> UserProfileLookUp(UserProfileViewQuery viewQuery);
        IEnumerable<UserProfileView> UserProfileByUserId(string userId);
        IEnumerable<CountryResult> GetUserCountry(string userId, bool isSuperAdmin, ICountryRepository countryRepo);
    }
    public partial class UserProfileViewRepository
    {
        public IEnumerable<UserProfileView> UserProfileByUserId(string userId)
        {
            var filterExpression = Filter<UserProfileView>.Create(p => p.UserId == userId);
            var result = Get(Query.WithFilter(filterExpression));
            return result;
        }
        public IEnumerable<UserProfileView> UserProfileLookUp(UserProfileViewQuery viewQuery)
        {
            var filterExpression = Filter<UserProfileView>.Create(p => p.UserId == viewQuery.UserId);
            var result = Get(Query.WithFilter(filterExpression));
            return result;
        }
        public IEnumerable<CountryResult> GetUserCountry(string userId, bool isSuperAdmin, ICountryRepository countryRepo)
        {

            if (!isSuperAdmin)
            {
                var filterExpression = Filter<UserProfileView>.Create(p => p.UserId == userId);
                var result = Get(Query.WithFilter(filterExpression));
                var filteredCountry = countryRepo.GetByIds(result.Select(x => x.CountryId).ToArray()).Where(x=>x.IsActive==true);
                return filteredCountry.Select(x => new CountryResult
                {
                    CountryCode = x.CountryCode,
                    CountryId = x.CountryId,
                    CountryName = x.CountryName,
                    IsActive = x.IsActive,
                    CountryShortDesc = x.CountryshortName
                }).OrderBy(x => x.CountryName);
            }
            var countries = countryRepo.GetAll().Where(x => x.IsActive == true);
            return countries.Select(x => new CountryResult
            {
                CountryCode = x.CountryCode,
                CountryId = x.CountryId,
                CountryName = x.CountryName,
                IsActive = x.IsActive,
                CountryShortDesc = x.CountryshortName
            }).OrderBy(x=>x.CountryName);

        }
    }
}
