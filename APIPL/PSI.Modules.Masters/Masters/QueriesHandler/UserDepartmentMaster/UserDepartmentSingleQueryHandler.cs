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
    public class UserDepartmentSingleQueryHandler : IRequestHandler<UserDepartmentSingleQuery, UserDepartmentMapping>
    {
        private readonly IUserDepartmentMapRepository _userDepartmentMap;
        public UserDepartmentSingleQueryHandler(IUserDepartmentMapRepository userDepartmentMap)
        {
            _userDepartmentMap= userDepartmentMap;
        }
        public async Task<UserDepartmentMapping> Handle(UserDepartmentSingleQuery request, CancellationToken cancellationToken)
        {
            return await Task.Run(() =>
            {
                var result = _userDepartmentMap.GetUserDepartmentMapping((int)request.DepartmentId, request.UserId);

                return result;
            });
        }
    }
}
