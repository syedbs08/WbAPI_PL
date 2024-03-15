using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.AspNetCore.Http;
using PSI.Domains.Entity;

namespace PSI.Modules.Backends.DirectSales.Command
{
    public class DirectSale
    {
        public int FileTypeId { get; set; }
        public IFormFile? File { get; set; }
        public string FolderPath { get; set; } = string.Empty;
        public int CustomerType { get; set; }
        public int CustomerId { get; set; }
        public int ProductCategoryId { get; set; }
        public int? ProductSubCategoryId { get; set; }
        public string SaleSubType { get; set; } = string.Empty;
    }

    public class DirectSalesCommand : IRequest<Result>
    {
        public DirectSalesCommand(DirectSale directSale,SessionData sessionData)
        {
            DirectSale = directSale;
            SessionData = sessionData;
        }
        public DirectSale DirectSale { get; set; }
        public SessionData SessionData { get; set; }
    }



    public class SalesDataExcelHeader
    {
        public int Index { get; set; }
        public string Name { get; set; } = string.Empty;
    }

    public class SalesQtyInfo
    {
        public int ColIndex { get; set; }
        public int RowIndex { get; set; }
        public string QtyMonthName { get; set; } = string.Empty;
        public long Qty { get; set; } = 0;
    }

    public class SalesPriceInfo
    {
        public int ColIndex { get; set; }
        public int RowIndex { get; set; }
        public string PriceMonthName { get; set; } = string.Empty;
        public decimal Price { get; set; } = 0;
    }

    public class SalesEntryRow
    {
        public int RowIndex { get; set; }
        public string UploadFlag { get; set; } = string.Empty;
        public string Class1 { get; set; } = string.Empty;
        public string Class2 { get; set; } = string.Empty;
        public string Class3 { get; set; } = string.Empty;
        public string Class4 { get; set; } = string.Empty;
        public string Class5 { get; set; } = string.Empty;
        public string Class6 { get; set; } = string.Empty;
        public string Class7 { get; set; } = string.Empty;
        public string Class8 { get; set; } = string.Empty;
        public string ItemCode { get; set; } = string.Empty;
        public string ModelNumber { get; set; } = string.Empty;
        public string TypeCode { get; set; } = string.Empty;
        public string Comments { get; set; } = string.Empty;
        public string Currency { get; set; } = string.Empty;
    }

    public class SalesEntryData
    {
        public SalesEntryData()
        {
            SalesEntryRows = new List<SalesEntryRow>();
            SalesQtyInfos = new List<SalesQtyInfo>();
            SalesPriceInfos = new List<SalesPriceInfo>();
            ResponseList = new List<SP_InsertSalesEntries>();
            IsValidSheet = false;
        }
        public List<SalesEntryRow> SalesEntryRows { get; set; }
        public List<SalesQtyInfo> SalesQtyInfos { get; set; }
        public List<SalesPriceInfo> SalesPriceInfos { get; set; }
        public List<SP_InsertSalesEntries> ResponseList { get; set; }
        public bool IsValidSheet { get; set; }
    }
}
