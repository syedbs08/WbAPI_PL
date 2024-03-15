using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;

namespace PSI.Modules.Backends.Masters.Queries.DashMaster
{
    internal class DashMasterBPSearchQuery:IRequest<LoadResult>
    {
        public DashMasterBPSearchQuery(DataSourceLoadOptions loadOptions
          )
        {
            LoadOptions = loadOptions;

        }


        public DataSourceLoadOptions LoadOptions;
    
    }
}
