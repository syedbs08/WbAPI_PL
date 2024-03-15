using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.UserDepartmentMaster;
using PSI.Modules.Backends.Masters.Repository.UserDepartmentMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.QueriesHandler.UserDepartmentMaster
{

    public class UserDepartmentByUserIdQueryHendler : IRequestHandler<UserDepartmentByUserIdQuery, IEnumerable<UserDepartmentMapping>>
    {
        private readonly IUserDepartmentMapRepository _userDepartmentMap;
        public UserDepartmentByUserIdQueryHendler(IUserDepartmentMapRepository userDepartmentMap)
        {
            _userDepartmentMap = userDepartmentMap;
        }

        public async Task<IEnumerable<UserDepartmentMapping>> Handle(UserDepartmentByUserIdQuery request, CancellationToken cancellationToken)
        {
            var result = _userDepartmentMap.GetByUserId(request.UserId);
            return await Task.FromResult(result);
        }
    }
}
