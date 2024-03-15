using Core.BaseUtility.Utility;
using DevExtreme.AspNet.Data.ResponseModel;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Command.MaterialMaster;
using PSI.Modules.Backends.Transmission.Command;
using PSI.Modules.Backends.Transmission.Queries;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Transmission
{
    public interface ITransmissionService
    {
        Task<List<TransmissionPlanType>> GetTransmissionPlanType();
        Task<Result> AddTransmissionList(TransmissionListCommand command,SessionData sessionData);
        Task<LoadResult> GetTransmissionList(DataSourceLoadOptions loadOptions);

        Task<Result> AddPreTransmissionList(PreTransmissionListCommand command, SessionData sessionData);
        Task<LoadResult> GetPreTransmissionCustomerList(DataSourceLoadOptions loadOptions, PreTransmissionCustomerSearch obj);
        Task<List<TransmissionListView>> getTransmissionCustomerByPlanTypeBySaleType(string planTypeCode, string saletype);
        Task<Result> WritTramissionFile(int plantype, int resultMonth, string customerCode, int currentMonth, string type);
        Task<LoadResult> GetTransmitdataList(DataSourceLoadOptions loadOptions);
    }
}
