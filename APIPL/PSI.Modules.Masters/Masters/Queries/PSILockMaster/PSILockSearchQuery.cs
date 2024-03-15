using MediatR;
using PSI.Domains.Entity;

namespace PSI.Modules.Backends.Masters.Queries.PSILockMaster
{
    public class PSILockSearchQuery : IRequest<LockPSI>
    {
        public PSILockSearchQuery(string userId, string serachItem)
        {
          
            UserId = userId;
            SerachItem = serachItem;

        }
       
        public string? SerachItem { get; set; }
        public string? UserId { get; set; }
        
    }
}
