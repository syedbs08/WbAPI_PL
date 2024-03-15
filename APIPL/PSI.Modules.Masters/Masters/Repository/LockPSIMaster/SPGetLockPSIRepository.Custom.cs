using Microsoft.Data.SqlClient;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.PSILockMaster;

namespace PSI.Modules.Backends.Masters.Repository.LockPSIMaster
{
    public partial interface ISPGetLockPSIRepository
    {
        List<SP_GETLOCKPSI> GetAll(PSILockSearchItems items);

    }
    public partial class SPGetLockPSIRepository
    {
        public List<SP_GETLOCKPSI> GetAll(PSILockSearchItems items)
        {

            var result = ExecuteProcedure("SP_GETLOCKPSI",
            //new SqlParameter
            //        (
            //             "@CUSTOMERCODES",
            //            (object)items.CustomerCodes
            //         ),
             new SqlParameter("@CUSTOMERCODES", (object)items.CustomerCodes ?? DBNull.Value),
              new SqlParameter("@SUBCATEGORIES", (object)items.SubcategoryCodes ?? DBNull.Value)
                ,
            //new SqlParameter
            //    (
            //         "@SUBCATEGORIES",
            //          (object)items.SubcategoryCodes
            //     ),
            //new SqlParameter
            //    (
            //         "@USERID",
            //          (object)items.UserIds
            //     )
            new SqlParameter("@USERID", (object)items.UserIds ?? DBNull.Value)
                );


            return result.ToList();
        }
    }
}
