using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.AspNetCore.Http;
using PSI.Domains.Entity;
using PSI.Domains.Entity.Scripts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.SNS.Command
{
    public class SNS_Price
    {
        public int FileTypeId { get; set; }
        public IFormFile? File { get; set; }
        public string FolderPath { get; set; } = string.Empty;
        public string StockPriceType { get; set; }
    }
    public class SNS_PriceCommand : IRequest<Result>
    {
        public SNS_PriceCommand(SNS_Price sSN_Price, SessionData sessionData)
        {
            SSN_Price = sSN_Price;
            SessionData = sessionData;
        }
        public SNS_Price SSN_Price { get; set; }
        public SessionData SessionData { get; set; }
    }
    /// <summary>
    /// 
    /// </summary>
    public class SNSPricingData
    {
        public SNSPricingData()
        {
            SALESRows = new List<SALESRows>();
            FOBRows = new List<FOBRows>();
            ResponseList = new List<SP_InsertSNCPrices>();
        }
        public List<SALESRows> SALESRows { get; set; }
        public List<FOBRows> FOBRows { get; set; }
        public List<SP_InsertSNCPrices> ResponseList { get; set; }
    }
    public class SALESRows
    {
        public int RowIndex { get; set; }
        public string Sales_Org { get; set; }
        public string Dist_Chnl { get; set; }
        public string Cust_Code { get; set; }
        public string Ship_Mode { get; set; }
        public string Inco_Term { get; set; }
        public string Termid{ get; set; }
        public string MaterailCode{ get; set; }
        public DateTime From_Dt { get; set; }
        public DateTime To_Dt { get; set; }
        public double Price { get; set; }
        public string Price_Unit { get; set; }
        public string Curr { get; set; }
        public string Uom { get; set; }
    }
    public class FOBRows
    {
        public int RowIndex { get; set; }
        public int? Plant { get; set; }
        public int? Vendor{ get; set; }
        public string Cust_Code { get; set; }
        public string Inco_Term { get; set; }
        public string TermId{ get; set; }
        public string MaterailCode{ get; set; }
        public DateTime From_Dt { get; set; }
        public DateTime To_Dt { get; set; }
        public double Price { get; set; }
        public int? Price_Unit { get; set; }
        public string Curr{ get; set; }
        public string Uom { get; set; }
        public string Port { get; set; }
    }
    public class SNSPriceDataExcelHeader
    {
        public int Index { get; set; }
        public string Name { get; set; } = string.Empty;
    }
}