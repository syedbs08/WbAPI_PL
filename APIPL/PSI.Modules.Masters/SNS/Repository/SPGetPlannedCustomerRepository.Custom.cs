using Microsoft.Data.SqlClient;
using PSI.Domains.Entity;

namespace PSI.Modules.Backends.SNS.Repository
{
    public partial interface ISPGetPlannedCustomerRepository
    {
        List<SP_GET_PLANNEDCUSTOMER> GetAll(string accountCode, string materialCode);

    }
    public partial class SPGetPlannedCustomerRepository
    {
        public List<SP_GET_PLANNEDCUSTOMER> GetAll(string accountCode, string materialCode)
        {


            var result = ExecuteProcedure("SP_GET_PLANNEDCUSTOMER",
            new SqlParameter
                    (
                         "@AccountCode",
                        (object)accountCode 
                     ),
            new SqlParameter
                (
                     "@MaterialCodes",
                      (object)materialCode 
                 ));


            return result.ToList();
        }


    }

}
