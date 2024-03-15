using Core.BaseUtility.Utility;
using DevExtreme.AspNet.Data.ResponseModel;
using PSI.Domains.Entity;
using PSI.Modules.Backends.COG.Command;
using PSI.Modules.Backends.COG.Queries;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.COG
{
    public interface ICOGService
    {
        Task<Result> UploadFiles(COGEntryUploadCommand command);
        Task<LoadResult> GetCOGUpload(DataSourceLoadOptions loadOptions, COGUploadSearch command, string userId, bool isSupeAdmin);
    }
}
