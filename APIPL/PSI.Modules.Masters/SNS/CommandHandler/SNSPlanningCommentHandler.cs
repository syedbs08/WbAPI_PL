using Core.BaseUtility.MapperProfiles;
using Core.BaseUtility.Utility;
using MediatR;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.SNS.Command;
using PSI.Modules.Backends.SNS.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.SNS.CommandHandler
{
    public class SNSPlanningCommentHandler : IRequestHandler<SNSPlanningCommentCommand, Result>
    {
        private readonly ISNSPlanningCommentRepository _sNSPlanningCommentRepository;
        public SNSPlanningCommentHandler(ISNSPlanningCommentRepository sNSPlanningCommentRepository)
        {
            _sNSPlanningCommentRepository = sNSPlanningCommentRepository;
        }
        public async Task<Result> Handle(SNSPlanningCommentCommand request, CancellationToken cancellationToken)
        {
            try
            {

                SNS_Planning_Comment obj = new SNS_Planning_Comment();
                obj.MaterialCode = request.SNSComments.MaterialCode;
                obj.AccountCode = request.SNSComments.OACAccountCode;
                obj.Comment = request.SNSComments.Comment;
                obj.CreatedBy = request.SessionData.Name;
                obj.CreatedDate = DateTime.Now;
                var result = await _sNSPlanningCommentRepository.Add(obj);
                if (result == null)
                {
                    Log.Error($"SNS planning comment Add:Db operation failed{result}");
                    return Result.Failure("Error in adding SNS planning comment,contact to support team");
                }
                return Result.Success;
            }
            catch (Exception ex)
            {
                Log.Error($"Execption occured while adding SNS planning comment {request.SNSComments.MaterialCode}", ex.Message);
                return Result.Failure("Problem in adding SNS planning comment ,try later");

            }
        }
    }
}

