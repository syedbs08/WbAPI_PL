using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Graph;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Repository.DepartmentMaster;
using PSI.Modules.Backends.SNS.Command;
using PSI.Modules.Backends.SNS.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;

namespace PSI.Modules.Backends.SNS.CommandHandler
{
    public class SNSMappingCommandHandler : IRequestHandler<SNSMappingCommand, Result>
    {
        private readonly ISNS_MappingRepository _sNS_MappingRepository;
        private readonly PSIDbContext _context;
        public SNSMappingCommandHandler(ISNS_MappingRepository sNS_MappingRepository)
        {
            _sNS_MappingRepository = sNS_MappingRepository;
            _context = new PSIDbContext();
        }
        public async Task<Result> Handle(SNSMappingCommand request, CancellationToken cancellationToken)
        {
            try
            {
                var data = await _sNS_MappingRepository.GetById(request.SNSMapping.SNS_MappingId);
                if (request.SNSMapping.IsDeleted == true)
                {
                    if (data == null)
                    {
                        return Result.Failure($"Data not found to delete");
                    }
                    var deleteResult = await _sNS_MappingRepository.Delete(data);
                    if (deleteResult == null)
                    {
                        Log.Error($"SNS mapping delete: Error occured while  {request.SNSMapping.SNS_MappingId}");
                        return Result.Failure("Seems input value is not correct,Failed to delete SNS mapping");
                    }
                    return Result.Success;
                }
                var dataExist = _sNS_MappingRepository.GetSNS_Mapping(request.SNSMapping.SNS_MappingId, request.SNSMapping.AccountCode, request.SNSMapping.FromModel, request.SNSMapping.ToModel);
                if (dataExist != null)
                {
                    return Result.Failure($"Data already exists in database");
                }


                SNS_Mapping sNSMapping = new SNS_Mapping();
                sNSMapping.AccountCode = request.SNSMapping.AccountCode;
                sNSMapping.FromModel = request.SNSMapping.FromModel;
                sNSMapping.ToModel = request.SNSMapping.ToModel;
                sNSMapping.IsActive = request.SNSMapping.IsActive;
                sNSMapping.CreatedBy = request.SessionData.Name;
                sNSMapping.CreatedDate = DateTime.Now;
                var result = _context.SNS_Mapping.Add(sNSMapping);
                _context.SaveChanges();
                if (result == null)
                {
                    Log.Error($"Company Add:Db operation failed{result}");
                    return Result.Failure("Error in adding Company,contact to support team");
                }
                return Result.Success;

            }
            catch (Exception ex)
            {

                Log.Error($"Execption occured while adding SNS mapping {request.SNSMapping.FromModel}", ex.Message);
                return Result.Failure("Problem in SNS mapping ,try later");

            }
        }
    }
}
