using Core.BaseUtility.MapperProfiles;
using Core.BaseUtility.Utility;
using MediatR;
using NPOI.SS.Formula.Functions;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Helpers;
using PSI.Modules.Backends.Masters.Queries.MaterialMaster;
using PSI.Modules.Backends.Masters.Repository.AccountMaster;
using PSI.Modules.Backends.Masters.Repository.AirPortMaster;
using PSI.Modules.Backends.Masters.Repository.CompanyMaster;
using PSI.Modules.Backends.Masters.Repository.CountryMaster;
using PSI.Modules.Backends.Masters.Repository.DepartmentMaster;
using PSI.Modules.Backends.Masters.Repository.MaterialMaster;
using PSI.Modules.Backends.Masters.Repository.ProductCategoryMaster;
using PSI.Modules.Backends.Masters.Repository.SeaPortMaster;
using PSI.Modules.Backends.Masters.Repository.SupplierMaster;
using PSI.Modules.Backends.Masters.Results;


namespace PSI.Modules.Backends.Masters.QueriesHandler.MaterialMaster
{
    public class MaterialSearchHandler : IRequestHandler<MaterialSearchQuery, IEnumerable<MaterialView>>
    {
        private readonly IMaterialViewReopsitory _materialViewReopsitory;
        public MaterialSearchHandler(
                IMaterialViewReopsitory materialViewReopsitory
            )
        {
            _materialViewReopsitory = materialViewReopsitory;
        }
        public async Task<IEnumerable<MaterialView>> Handle(MaterialSearchQuery request, CancellationToken cancellationToken)
        {
            var data = _materialViewReopsitory.GetAll().ToList();
            return await Task.FromResult(data);
        }
    }
}