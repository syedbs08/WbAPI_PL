using Core.BaseUtility.Utility;
using DevExtreme.AspNet.Data.ResponseModel;
using PSI.Modules.Backends.Adjustments.Command;
using PSI.Modules.Backends.Adjustments.Queries;
using PSI.Modules.Backends.DirectSales.Command;
using PSI.Modules.Backends.SNS.Command;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Adjustments
{
    public interface IAdjustmentService
    {//Upload Adjustment entries
        Task<Result> UploadFiles(AdjustmentEntryUploadCommand command);
        Task<LoadResult> GetAdjustmentUpload(DataSourceLoadOptions loadOptions, AdjustmentUploadSearch command, string userId, bool isSupeAdmin);
    }
}
