
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using PSI.Modules.Backends.Constants;

namespace PSI.Modules.Backends.Services.ExcelServices
{

    public abstract class ExcelExport : IExcelExport
    {
        protected string _sheetName;       
        protected List<string> _headers;
        protected List<string> _type;
        protected IWorkbook _workbook;
        protected ISheet _sheet;

    
        public MemoryStream Export<T>(List<T> exportData,       
            string sheetName = Contants.DEFAULT_SHEET_NAME)
        {
            _sheetName = sheetName;
            #region Generation of Workbook, Sheet and General Configuration
            _workbook = new XSSFWorkbook();
            _sheet = _workbook.CreateSheet(_sheetName);

            var headerStyle = _workbook.CreateCellStyle();
            var headerFont = _workbook.CreateFont();
            headerFont.IsBold = true;
            headerStyle.SetFont(headerFont);
            #endregion

            WriteData(exportData);

            #region Generating Header Cells
            var header = _sheet.CreateRow(0);
            for (var i = 0; i < _headers.Count; i++)
            {
                var cell = header.CreateCell(i);
                cell.SetCellValue(_headers[i]);
                cell.CellStyle = headerStyle;
                // It's heavy, it slows down your Excel if you have large data                
                _sheet.AutoSizeColumn(i);
            }
            #endregion

            #region Generating and Returning Stream for Excel
              var memoryStream = new MemoryStream();        
                _workbook.Write(memoryStream,true);
                memoryStream.Position = 0;
                return memoryStream;
         
            #endregion
        }

        /// <summary>
        /// Generic Definition to handle all types of List
        /// Overrride this function to provide your own implementation
        /// </summary>
        /// <param name="exportData"></param>
        public abstract void WriteData<T>(List<T> exportData);
    }


}