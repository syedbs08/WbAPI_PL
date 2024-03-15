using Core.BaseUtility.Utility;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.SNS.Command;
using PSI.Modules.Backends.Transmission.Command;
using PSI.Modules.Backends.Transmission.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Transmission.CommandHandler
{
    public class CreateTransmissionListCommandHandler : IRequestHandler<CreateTransmissionListCommand, Result>
    {
        private readonly ITransmissionListRepository _transmissionListRepository;

        public CreateTransmissionListCommandHandler(ITransmissionListRepository transmissionListRepository)
        {
            _transmissionListRepository = transmissionListRepository;
        }

        public async Task<Result> Handle(CreateTransmissionListCommand request, CancellationToken cancellationToken)
        {
            try
            {
                if (request.TransmissionListCommand.TransmissionListId > 0)
                {
                    var transmission = await _transmissionListRepository.GetById(request.TransmissionListCommand.TransmissionListId);
                    if (transmission == null)
                    {
                        return Result.Failure($"Transmission not found to delete {request.TransmissionListCommand.TransmissionListId}");
                    }
                    transmission.IsActive = false;
                    transmission.UpdateDate = DateTime.Now;
                    transmission.UpdateBy = request.SessionData.ADUserId;
                    var updateResult = _transmissionListRepository.Update(transmission);
                    if (updateResult == null)
                    {
                        Log.Error($"Transmission delete: Error occured while deleting {request.TransmissionListCommand.TransmissionListId}");
                        return Result.Failure("Seems input value is not correct,Failed to update Transmission");
                    }
                    return Result.Success;
                }
                TransmissionList transmissionList = new TransmissionList();
                transmissionList.PlanTypeCode = request.TransmissionListCommand.PlanTypeCode;
                transmissionList.CustomerCode = request.TransmissionListCommand.CustomerCode;
                transmissionList.SalesType = request.TransmissionListCommand.SalesType;
                transmissionList.IsActive = true;
                transmissionList.CreatedDate = DateTime.Now;
                transmissionList.CreatedBy = request.SessionData.ADUserId;
                var result = await _transmissionListRepository.Add(transmissionList);
                if (result == null)
                {
                    Log.Error($"Transmission list Add:Db operation failed{result}");
                    return Result.Failure("Error in adding Transmission,contact to support team");
                }
                return Result.Success;
            }
            catch (Exception ex)
            {
                Log.Error($"Transmission list Add:Db operation failed{ex.Message}");
                return Result.Failure("Error in adding Transmission list");
            }
        }
    }
}
