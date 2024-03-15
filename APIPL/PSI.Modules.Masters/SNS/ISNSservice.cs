using Core.BaseUtility.Utility;
using DevExtreme.AspNet.Data.ResponseModel;
using Microsoft.AspNetCore.Mvc;
using PSI.Domains.Entity;
using PSI.Modules.Backends.SNS.Command;
using PSI.Modules.Backends.SNS.Queries;
using PSI.Modules.Backends.SNS.Results;

namespace PSI.Modules.Backends.SNS
{
    public interface ISNSService
    {
        //Upload sns entries
        Task<Result> UploadFiles(SNSEntryUploadCommand command);
        //sns archive
        Task<LoadResult> ArchiveData(DataSourceLoadOptions loadOptions, SNSArchiveSearch obj);
        Task<Result> Archive(SNSArchiveCommand command);
        Task<Result> RunPriceProcess(RunPriceProcessCommand command);
        Task<Result> SNSUploadFiles(SNS_PriceCommand command);
        Task<Result> GetOrDownloadSNSEntry(SNSEntryDownloadCommand command);
        Task<Result> CreateSNSComment(SNSPlanningCommentCommand command);
        Task<IEnumerable<VW_SNSPlanningComment>> GetPlanningComment(string materialcode, string accountcode);

        Task<Result> GetSNSPlanning(SNSPlanningCommand command);
        Task<Result> UpdateSNSPlanning(UpdateSNSPlanningCommand command);

        Task<SapRfcResponseResult> TriggerMonthClosing(string type, string userId);
        Task<Result> TriggerRollingInventorySnsBP(RollingInventorySnsBPCommand command);

        SapRfcResponseResult SaveResultPurchase(string userId);

        Task<Result> UpdateConsinee(UpdateConsineeCommand command);

        List<SP_GET_PLANNEDCUSTOMER> GetPlannedCustomer(string accountCode, string materialCode);
        Task<Result> AddSNSMapping(SNSMappingCommand command);
        Task<LoadResult> GetSNSMapping(DataSourceLoadOptions loadOptions);
        Task<Result> RollingInventory(string accountCode);
        Task<Result> MapSNSModel(string accountCode, string userid);
    }
}
