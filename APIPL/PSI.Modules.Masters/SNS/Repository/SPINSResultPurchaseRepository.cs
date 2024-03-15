using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.SNS.Repository
{
    public partial interface ISPINSResultPurchaseRepository : IBaseRepository<SPINSRESULTPURCHASE>
    {
    }
    public partial class SPINSResultPurchaseRepository : BaseRepository<SPINSRESULTPURCHASE>, ISPINSResultPurchaseRepository 
    {
        public SPINSResultPurchaseRepository() : base(new PSIDbContext()) { }
    }
   
}
