using Core.BaseUtility.Utility;
using MediatR;
using PSI.Modules.Backends.SNS.Results;

namespace PSI.Modules.Backends.SNS.Command
{
    public class UpdateSNSPlanningCommand : IRequest<Result>
    {
        public UpdateSNSPlanningCommand(UpdateSNSPlanning updateSNSPlanning, SessionData sessionData)
        {
            UpdateSNSPlanning = updateSNSPlanning;
            SessionData = sessionData;
        }
        public UpdateSNSPlanning UpdateSNSPlanning { get; set; }
        public SessionData SessionData { get; set; }
    }

    public class UpdateSNSPlanning
    {
        public SNSPlanning SNSPlanning {get; set;}
        public List<SNSPlanningDetail> SNSPlanningList { get; set; }
    }
}
