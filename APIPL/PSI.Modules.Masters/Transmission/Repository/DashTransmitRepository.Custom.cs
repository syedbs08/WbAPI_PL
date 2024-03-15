

using Core.BaseEntitySql.BaseRepository;
using Microsoft.Data.SqlClient;
using PSI.Domains.Entity;

namespace PSI.Modules.Backends.Transmission.Repository
{
    public partial interface IDashTransmitRepository
    {
        IEnumerable<DashTransmit> GetByCurrentMonth(string monthYear);
        List<DashTransmit> GetAll(int noofRecord);
    }
    public partial class DashTransmitRepository
    {
        public IEnumerable<DashTransmit> GetByCurrentMonth(string monthYear)
        {
            var result = Query.WithFilter(Filter<DashTransmit>.Create(p => p.CurrentMonthYear == monthYear));
            return Get(result);
        }


        public List<DashTransmit> GetAll(int noofRecord)
        {

            var result = ExecuteProcedure("SP_DASH_TRANSMIT",
                  new SqlParameter
                    (
                         "@TakeTop",
                        (object)noofRecord
                     ));
            return result.ToList();
        }
    }
}
