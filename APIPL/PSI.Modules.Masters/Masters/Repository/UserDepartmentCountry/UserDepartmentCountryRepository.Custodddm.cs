using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;


namespace PSI.Modules.Backends.Masters.Repository.UserDepartmentMaster
{
    public partial interface IUserDepartmentCountryRepository
    {
        List<UserDepartmentCountryView> GetUsersByCountryId(int countryId, List<Users> users);
    }
    public partial class UserDepartmentCountryRepository
    {
        public IEnumerable<Users> GetUserActive()
        {
            var filterExpression = Filter<Users>.Create(p => p.IsActive == true);
            var result = Get(Query.WithFilter(filterExpression));
            return result;
        }
    }
    public partial interface IUserDepartmentCountryRepository
    {
        List<UserDepartmentCountryView> GetUsersByCountryId(int countryId, List<Users> users);
    }
    public partial class UserDepartmentCountryRepository
    {
        public List<UserDepartmentCountryView> GetUsersByCountryId(int countryId, List<Users> users)
        {         
            var filterExpression = Filter<UserDepartmentCountryView>.Create(p => p.CountryId == countryId);
            var result =get
            
           
            var result = result.Select(x => new UserDepartmentCountryView
            {
                UserId = x.UserId,
                DepartmentId = x.DepartmentId,
                DepartmentName = x.DepartmentName,
                UserName =  users.FirstOrDefault(z => z.UserId == x.UserId)?.Name,
            });
            return result.DistinctBy(x => x.UserName).OrderBy(x => x.UserName).ToList();
        }
      
    }
}
