using Core.BaseUtility.Utility;
using MediatR;

namespace PSI.Modules.Backends.SNS.Command
{
    public class SNSMappingCommand : IRequest<Result>
    {
        public SNSMappingCommand(SNSMapping snsMapping, SessionData sessionData)
        {
            SNSMapping = snsMapping;
            SessionData = sessionData;
        }
        public SNSMapping SNSMapping { get; set; }
        public SessionData SessionData { get; set;}
    }
    public class SNSMapping
    {
        public int SNS_MappingId { get; set; }
        public string AccountCode { get; set; }
        public string FromModel { get; set; }
        public string ToModel { get; set; }
        public string? CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
    }
}
