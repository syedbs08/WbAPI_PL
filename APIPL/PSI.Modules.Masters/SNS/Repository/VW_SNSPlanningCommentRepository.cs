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
    public partial interface IVW_SNSPlanningCommentRepository: IBaseRepository<VW_SNSPlanningComment>
    {
    }
    public partial class VW_SNSPlanningCommentRepository: BaseRepository<VW_SNSPlanningComment>, IVW_SNSPlanningCommentRepository
    {
        public VW_SNSPlanningCommentRepository(): base(new PSIDbContext()) { }
    }
}
