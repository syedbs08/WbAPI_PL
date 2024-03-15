using Core.BaseUtility.Utility;
using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using Microsoft.Graph.CallRecords;
using PSI.Modules.Backends.DirectSales.Command;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.DirectSales.Queries
{
    public class OCIndicationMonthConfirmSearchQuery : IRequest<LoadResult>
    {
        public OCIndicationMonthConfirmSearchQuery(DataSourceLoadOptions loadOptions, OCIndicationMonthSearchCommand oCIndicationMonthCommand,
            SessionData session)
        {
            LoadOptions = loadOptions;  
            OCIndicationMonthCommand= oCIndicationMonthCommand;
            Session = session;
        }
        public DataSourceLoadOptions LoadOptions;
        public SessionData Session { get; set; }
        public OCIndicationMonthSearchCommand OCIndicationMonthCommand { get; set; }
    }
}
