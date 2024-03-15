using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.UserDepartmentMaster;
using PSI.Modules.Backends.Masters.Queries.UserViewProfile;
using PSI.Modules.Backends.Masters.Repository.UserViewProfile;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.QueriesHandler.UserViewProfile
{
    public class QueryUserProfileRequest : IRequestHandler<UserProfileViewQuery, IEnumerable<UserProfileView>>
    {
        private readonly IUserViewProfileRepository _profileRepository;
        public QueryUserProfileRequest(IUserViewProfileRepository profileRepository)
        {
            _profileRepository = profileRepository;
        }

        public async Task<IEnumerable<UserProfileView>> Handle(UserProfileViewQuery request, CancellationToken cancellationToken)
        {
            var result = _profileRepository.UserProfileLookUp(request);
            return await Task.FromResult(result);
        }
    }
}
