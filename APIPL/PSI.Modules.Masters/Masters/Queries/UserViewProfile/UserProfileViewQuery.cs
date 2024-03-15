using MediatR;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Queries.UserViewProfile
{
    public class UserProfileViewQuery : IRequest<IEnumerable<UserProfileView>>
    {
        public UserProfileViewQuery(string userId = "")
        {
            UserId = userId;
        }
        public string UserId { get; set; }
    }
}
