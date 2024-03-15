using NPOI.SS.UserModel;
using PSI.Modules.Backends.Constants;

using System.ComponentModel;
using System.Data;

using System.Text.RegularExpressions;

namespace PSI.Modules.Backends.Services.ExcelServices
{

    public class GenerateExcel : ExcelExport
    {
        public GenerateExcel()
        {
            _headers = new List<string>();
            _type = new List<string>();
        }

        public sealed override void WriteData<T>(List<T> exportData)
        {
            PropertyDescriptorCollection properties = TypeDescriptor.GetProperties(typeof(T));
            DataTable table = new DataTable();

            #region Reading property name to generate cell header
            foreach (PropertyDescriptor prop in properties)
            {
                var type = Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType;
                _type.Add(type.Name);
                table.Columns.Add(prop.Name, Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType);
                //string name = Regex.Replace(prop.Name, "([A-Z])", " $1").Trim(); //space seperated name by caps for header
                string name = Regex.Replace(prop.Name, "([A-Z0-9]+)", " $1").Trim(); //space seperated name by caps for header
                _headers.Add(name);
            }
            #endregion

            #region Generating Datatable from List
            foreach (T item in exportData)
            {
                DataRow row = table.NewRow();
                foreach (PropertyDescriptor prop in properties)
                    row[prop.Name] = prop.GetValue(item) ?? DBNull.Value;
                table.Rows.Add(row);
            }
            #endregion

            #region Generating SheetRow based on datatype
            IRow sheetRow = null;

            for (int i = 0; i < table.Rows.Count; i++)
            {
                sheetRow = _sheet.CreateRow(i + 1);
                for (int j = 0; j < table.Columns.Count; j++)
                {
                    ICell Row1 = sheetRow.CreateCell(j);
                    string cellvalue = Convert.ToString(table.Rows[i][j]);

                    // TODO: move it to switch case

                    if (string.IsNullOrWhiteSpace(cellvalue))
                    {
                        Row1.SetCellValue(string.Empty);
                    }
                    else if (_type[j].ToLower() == Contants.STRING)
                    {
                        Row1.SetCellValue(cellvalue);
                    }
                    else if (_type[j].ToLower() == Contants.INT32)
                    {
                        Row1.SetCellValue(Convert.ToInt32(table.Rows[i][j]));
                    }
                    else if (_type[j].ToLower() == Contants.DOUBLE)
                    {
                        Row1.SetCellValue(Convert.ToDouble(table.Rows[i][j]));
                    }
                    else if (_type[j].ToLower() == Contants.DATETIME)
                    {
                        Row1.SetCellValue(Convert.ToDateTime
                             (table.Rows[i][j]).ToString(Contants.DATETIME_FORMAT));
                    }
                    else if (_type[j].ToLower() == Contants.DECIMAL)
                    {
                        Row1.SetCellValue(Convert.ToDouble(table.Rows[i][j]));
                    }
                    else if (_type[j].ToLower() == Contants.BOOL)
                    {
                        Row1.SetCellValue(Convert.ToBoolean(table.Rows[i][j]));
                    }
                    else
                    {
                        Row1.SetCellValue(string.Empty);
                    }
                }
            }
            #endregion
        }
    }
}