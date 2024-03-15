using Core.BaseUtility.TableSearchUtil;
using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using PSI.Domains.Entity;


namespace PSI.Modules.Backends.Masters.Queries.CompanyMaster
{
    public class CompanySearchQuery : IRequest<LoadResult>
    {
        public CompanySearchQuery(DataSourceLoadOptions loadOptions)
        {
            LoadOptions = loadOptions;
        }
        public DataSourceLoadOptions LoadOptions;

    }
}

