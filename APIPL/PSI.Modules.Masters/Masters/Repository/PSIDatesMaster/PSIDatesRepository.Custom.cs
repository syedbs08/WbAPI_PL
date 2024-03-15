using Core.BaseEntitySql.BaseRepository;
using Core.BaseUtility.MapperProfiles;
using Core.BaseUtility.TableSearchUtil;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Results;

namespace PSI.Modules.Backends.Masters.Repository.PSIDatesMaster
{
    public partial interface IPSIDatesRepository
    {
        List<PSIDates> GetPSIDates();
        PSIDates GetPSIDate(string month);

    }
    public partial class PSIDatesRepository
    {
        public PSIDates GetPSIDate(string month)
        {
            var result = FirstOrDefault(Query.WithFilter(Filter<PSIDates>
              .Create(p =>
               p.Month == month
              )));
            return result;
        }
        public List<PSIDates> GetPSIDates()
        {
            var result = GetAll();
            return result.ToList();
        }
    }
}
