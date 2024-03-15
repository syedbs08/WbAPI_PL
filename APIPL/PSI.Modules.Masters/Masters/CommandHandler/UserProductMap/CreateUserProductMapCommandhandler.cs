using Core.BaseUtility.Utility;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Command.UserProductMap;
using PSI.Modules.Backends.Masters.Repository.UserProductMap;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.CommandHandler.UserProductMap
{
    public class CreateUserProductMapCommandhandler : IRequestHandler<CreateUserProductMappingCommand, Result>
    {
        private readonly IUserProductMappingRepository _userProductMapping;
        public CreateUserProductMapCommandhandler(IUserProductMappingRepository userProductMapping)
        {
            _userProductMapping = userProductMapping;
        }

        public async Task<Result> Handle(CreateUserProductMappingCommand request, CancellationToken cancellationToken)
        {
            try
            {
                var data = _userProductMapping.GetUserProductByUserIds(request.ProductMappingCommand.UserId);
                await _userProductMapping.Delete(data.ToList());
                List<UserProductMapping> list=new List<UserProductMapping>();
                foreach (var item in request.ProductMappingCommand.ProductIdId)
                {   
                    var requestBody = new UserProductMapping
                    {
                        UserId = request.ProductMappingCommand.UserId,
                        ProductId = item,
                        CreatedBy = "",
                        CreatedDate = DateTime.Now,
                    };
                    list.Add(requestBody);


                }
                await _userProductMapping.AddBulk(list);
                return Result.Success;
            }
            catch (Exception ex)
            {
                Log.Error($"Execption occured while adding user department {request.ProductMappingCommand}", ex.Message);
                return Result.Failure("Problem in adding user department ,try later");
            }
        }
    }
}
