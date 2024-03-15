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
    public partial interface ISNSPlanningCommentRepository: IBaseRepository<SNS_Planning_Comment>
    {
    }
    public partial class SNSPlanningCommentRepository: BaseRepository<SNS_Planning_Comment>, ISNSPlanningCommentRepository
    {
        public SNSPlanningCommentRepository(): base(new PSIDbContext()) { }
    }
}
