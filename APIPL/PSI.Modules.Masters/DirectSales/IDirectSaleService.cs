using Core.BaseUtility.Utility;
using DevExtreme.AspNet.Data.ResponseModel;
using PSI.Domains.Entity;
using PSI.Modules.Backends.DirectSales.Command;
using PSI.Modules.Backends.DirectSales.Queries;

namespace PSI.Modules.Backends.DirectSales
{
    public interface IDirectSaleService
    {
        #region OcIndicationMonth
        Task<LoadResult> GetOcIndicationMonth(DataSourceLoadOptions loadOptions, OCIndicationMonthSearchCommand oCIndicationMonthCommand, string userId, bool isSupeAdmin, SessionData SessionMain);
        Task<Result> UpdateOCIndicationMonth(OCIndicationMonthCommand obj, SessionData session);
        #endregion 

        #region Direct Sales Agency Upload
        Task<Result> UploadFiles(DirectSalesCommand command);
        Task<Result> GetOrDownloadAgentSaleSummary(DirectSalesDownloadCommand directSalesDownloadCommand);
        #endregion

        #region Direct Sale OCO-Current lock months
        Task<LoadResult> GetOCOLockMonth(DataSourceLoadOptions loadOptions, OCOLockMonthSearchCommand oCOLockMonth, string userId, bool isSupeAdmin);
        Task<Result> UpdateSaleEntryStatus(List<OCOLockMonthCommand> commands, SessionData sessionMain);
        #endregion

        //#region archive
        //Task<SalesArchivalEntry> DirectSaleArchive(string month, string createdby);
        //#endregion

        #region SSD
            Task<Result> UploadSSDForeCast(SSDForecastUploadCommand command);
        #endregion

        Task<Result> GetDirectSaleReport(DirectSaleReportSearchQuery query);
    }
}
