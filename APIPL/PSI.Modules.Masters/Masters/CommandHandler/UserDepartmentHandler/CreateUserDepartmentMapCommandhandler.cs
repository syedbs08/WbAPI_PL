using Core.BaseUtility.Utility;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Command.UserDepartmentMaster;
using PSI.Modules.Backends.Masters.Repository.UserDepartmentMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.CommandHandler.UserDepartmentHandler
{
    public class CreateUserDepartmentMapCommandhandler : IRequestHandler<CreateUserDepartmentMappingCommand, Result>
    {
        private readonly IUserDepartmentMapRepository _userDepartmentMap;
        public CreateUserDepartmentMapCommandhandler(IUserDepartmentMapRepository userDepartmentMapRepository)
        {
            _userDepartmentMap=userDepartmentMapRepository;
        }
        public async Task<Result> Handle(CreateUserDepartmentMappingCommand request, CancellationToken cancellationToken)
        {
            try
            {
                var data = _userDepartmentMap.GetByUserId(request.UserDepartmentMapping.UserId);
                await _userDepartmentMap.Delete(data.ToList());
                //update operatio will be seperated later
                foreach (var item in request.UserDepartmentMapping.DepartmentId)
                {
                    var requestBody = new UserDepartmentMapping
                    {
                        UserId=request.UserDepartmentMapping.UserId,
                        DepartmentId=item,
                        CreatedBy="",
                        CreatedDate=DateTime.Now,
                    };
                    await _userDepartmentMap.Add(requestBody);
                }
                return Result.Success;

            }
            catch (Exception ex)
            {

                Log.Error($"Execption occured while adding user department {request.UserDepartmentMapping}", ex.Message);
                return Result.Failure("Problem in adding user department ,try later");

            }
        }
    }
}
