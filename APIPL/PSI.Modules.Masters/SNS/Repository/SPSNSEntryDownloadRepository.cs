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

    public partial interface ISPSNSEntryDownloadRepository : IBaseRepository<SP_SNSEntryDownload>
    {
    }
    public partial class SPSNSEntryDownloadRepository : BaseRepository<SP_SNSEntryDownload>, ISPSNSEntryDownloadRepository
    {
        public SPSNSEntryDownloadRepository() : base(new PSIDbContext()) { }
    }
 
}
