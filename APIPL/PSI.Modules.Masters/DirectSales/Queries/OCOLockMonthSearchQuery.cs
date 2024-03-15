using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using PSI.Modules.Backends.DirectSales.Command;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.DirectSales.Queries
{
    public class OCOLockMonthSearchQuery : IRequest<LoadResult>
    {
        public OCOLockMonthSearchQuery(DataSourceLoadOptions loadOption, OCOLockMonthSearchCommand cOLockMonthCommand)
        {
             LoadOptions=loadOption;
            COLockMonthCommand = cOLockMonthCommand;
        }
        public DataSourceLoadOptions LoadOptions;
        public OCOLockMonthSearchCommand COLockMonthCommand { get; set; }
    }
}
