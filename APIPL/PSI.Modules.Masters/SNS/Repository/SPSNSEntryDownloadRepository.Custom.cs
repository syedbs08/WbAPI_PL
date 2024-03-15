using Core.BaseEntitySql.BaseRepository;
using Microsoft.EntityFrameworkCore;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.SNS.Command;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.SNS.Repository
{

    public partial interface ISPSNSEntryDownloadRepository 
    {
        IEnumerable<SP_SNSEntryQtyPriceForDownload> GetSNSEntryQtyPriceForDownload(SNSEntryDownload command);
    }
    public partial class SPSNSEntryDownloadRepository
    {
        public IEnumerable<SP_SNSEntryQtyPriceForDownload> GetSNSEntryQtyPriceForDownload(SNSEntryDownload command)
        {

            if (command.OACCode == "null")
            {
                command.OACCode = null;
            }
            if (command.CustomerCode == "null")
            {
                command.CustomerCode = null;
            }
            if (command.CountryCode == "null")
            {
                command.CountryCode = null;
            }
            if (command.ProductCategoryId == "null")
            {
                command.ProductCategoryId = null;
            }
            if (command.ProductSubCategoryId == "null")
            {
                command.ProductSubCategoryId = null;
            }

            PSIDbContext _context = new();
            List<SP_SNSEntryQtyPriceForDownload> data = new List<SP_SNSEntryQtyPriceForDownload>();
            if(command.SaleSubType.ToUpper()=="BP")
            {
                 data = _context.SP_SNSEntryQtyPriceForDownload.FromSql($"[dbo].[SP_GET_SNSENTRYQTYPRICE_SUMMARY_DOWNLOAD_BP] {command.OACCode},{command.CountryCode},{command.CustomerCode},{command.ProductCategoryId},{command.ProductSubCategoryId} ,{command.SaleSubType},{command.FromMonth},{command.ToMonth}").AsNoTracking().ToList();

            }
            else
            {
                 data = _context.SP_SNSEntryQtyPriceForDownload.FromSql($"[dbo].[SP_GET_SNSENTRYQTYPRICE_SUMMARY_DOWNLOAD] {command.OACCode},{command.CountryCode},{command.CustomerCode},{command.ProductCategoryId},{command.ProductSubCategoryId} ,{command.SaleSubType},{command.FromMonth},{command.ToMonth}").AsNoTracking().ToList();

            }
            return data;
        }

    }



}
