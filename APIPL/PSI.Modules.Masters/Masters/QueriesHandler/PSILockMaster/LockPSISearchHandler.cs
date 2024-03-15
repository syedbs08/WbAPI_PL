using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.AccountMaster;
using PSI.Modules.Backends.Masters.Queries.PSILockMaster;
using PSI.Modules.Backends.Masters.Repository.AccountMaster;
using PSI.Modules.Backends.Masters.Repository.LockPSIMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.QueriesHandler.PSILockMaster
{
    public class LockPSISearchHandler : IRequestHandler<PSILockSearchQuery, LockPSI>
    {
        private readonly ILockPSIRepository _lockPSIRepository;
        public LockPSISearchHandler(ILockPSIRepository lockPSIRepository)
        {
            _lockPSIRepository = lockPSIRepository;

        }
        public async Task<LockPSI> Handle(PSILockSearchQuery request, CancellationToken cancellationToken)
        {
            var data = _lockPSIRepository.CheckLockPSIByUserId(request);
            return await Task.FromResult(data);

        }
    }
}
