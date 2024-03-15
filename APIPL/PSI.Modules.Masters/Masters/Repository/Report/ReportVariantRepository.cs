using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Domains;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.Report
{
   
    public partial interface IReportVariantRepository : IBaseRepository<ReportVariant>
    {
    }
    public partial class ReportVariantRepository : BaseRepository<ReportVariant>, IReportVariantRepository
    {
        public ReportVariantRepository() : base(new PSIDbContext()) { }
    }
}
