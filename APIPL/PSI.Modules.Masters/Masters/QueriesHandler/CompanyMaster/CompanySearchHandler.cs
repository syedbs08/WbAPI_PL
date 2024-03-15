

using Core.BaseUtility.TableSearchUtil;
using DevExtreme.AspNet.Data;
using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using Microsoft.AspNetCore.Server.HttpSys;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.AccountMaster;
using PSI.Modules.Backends.Masters.Queries.CompanyMaster;
using PSI.Modules.Backends.Masters.Repository;
using PSI.Modules.Backends.Masters.Repository.AccountMaster;
using PSI.Modules.Backends.Masters.Repository.CompanyMaster;
using System.Net.NetworkInformation;

namespace PSI.Modules.Backends.Masters.QueriesHandler.AccountMaster
{
    public class CompanySearchHandler : IRequestHandler<CompanySearchQuery, LoadResult>
    {
        private readonly ICompanyRepository _companyRepository;
        public CompanySearchHandler(ICompanyRepository companyRepository)
        {
            _companyRepository = companyRepository;
        }
        public async Task<LoadResult> Handle(CompanySearchQuery request, CancellationToken cancellationToken)
        {
            var data = _companyRepository.GetAllCompanies();
            var result = DataSourceLoader.Load(data, request.LoadOptions);
            return await Task.FromResult(result);
        }

    }
}
