using Microsoft.Data.SqlClient;
using PSI.Domains.Entity;

namespace PSI.Modules.Backends.SNS.Repository
{
    public partial interface ISPINSResultPurchaseRepository
    {
      IEnumerable<SPINSRESULTPURCHASE> SaveResultMonthPurchase(string userId);
    }
    public partial class SPINSResultPurchaseRepository
    {
        public IEnumerable<SPINSRESULTPURCHASE> SaveResultMonthPurchase(string userId)
        {


            // return Enumerable.Empty<SP_TutorsList>();
            var result = ExecuteProcedure("SP_INS_RESULTPURCHASE",
                 new SqlParameter
                (
                     "@UserId",
                    userId
                 )

                  );


            return result;
        }
    }
   
}
