using AttachmentService.Repository;
using MediatR;
using Microsoft.EntityFrameworkCore;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.MaterialMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.QueriesHandler.MaterialMaster
{
    public class MaterialByMgSearchHandler : IRequestHandler<MaterialByMgSearchQuery, List<SP_MATERIALSEARCH>>
    {
        private readonly PSIDbContext _context;
        public MaterialByMgSearchHandler()
        {
            _context = new PSIDbContext();
        }
        public async Task<List<SP_MATERIALSEARCH>> Handle(MaterialByMgSearchQuery request, CancellationToken cancellationToken)
        {
            string mg2 = string.Join(", ", request.MaterilSearch.MG1);
            string? mg3 = null;
            if (request.MaterilSearch.MG2.Count()> 0)
            {
                mg3 = string.Join(", ", request.MaterilSearch.MG2);
            }

            var data = _context.SP_MATERIALSEARCH.FromSql($"SP_MATERIALSEARCH  {mg2}, {mg3}").AsNoTracking().ToList();
            return await Task.FromResult(data);
        }
    }
}
