using Core.BaseEntitySql.BaseRepository;
using Core.BaseUtility.MapperProfiles;
using Core.BaseUtility.TableSearchUtil;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.DepartmentMaster;
using PSI.Modules.Backends.Masters.Queries.TurnoverDaysMaster;
using PSI.Modules.Backends.Masters.Results;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.TurnoverDaysMaster
{
    public partial interface ITurnoverDaysRepository
    {
        List<TurnoverDays> GetTurnoverDays();
        TurnoverDays GetTurnoverDays(string SubGroupProductCategoryCode, string monthYear, int turnoverDay, int turnoverDaysId);
    }
    public partial class TurnoverDaysRepository
    {
        public List<TurnoverDays> GetTurnoverDays()
        {
            var result = GetAll();
            return result.ToList();
        }
        public TurnoverDays GetTurnoverDays(string SubGroupProductCategoryCode, string monthYear, int turnoverDay, int turnoverDaysId)
        {
            var result = FirstOrDefault(Query.WithFilter(Filter<TurnoverDays>
              .Create(p =>
               p.SubGroupProductCategoryCode == SubGroupProductCategoryCode
              || p.Month == monthYear
              || p.TurnoverDay == turnoverDay
              )));
            return result;
        }
      
    }
}

