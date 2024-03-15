using PSI.Modules.Backends.Constants;
using System.Collections.Generic;
using System.Net.Http;

namespace PSI.Modules.Backends.Services.ExcelServices
{
    public interface IExcelExport
    {
        MemoryStream Export<T>(List<T> exportData, string sheetName = Contants.DEFAULT_SHEET_NAME);
    }
}
