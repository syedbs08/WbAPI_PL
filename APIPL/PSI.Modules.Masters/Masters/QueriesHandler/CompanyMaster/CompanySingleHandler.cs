

using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.CompanyMaster;
using PSI.Modules.Backends.Masters.Repository.CompanyMaster;
namespace PSI.Modules.Backends.Masters.QueriesHandler.AccountMaster
{
    public class CompanySingleHandler : IRequestHandler<CompanySingleQuery, Company>
    {

        private readonly ICompanyRepository _companyRepository;
        public CompanySingleHandler(ICompanyRepository companyRepository)
        {
            _companyRepository = companyRepository;
        }

        public async Task<Company> Handle(CompanySingleQuery request, CancellationToken cancellationToken)
        {
            return await Task.Run(() =>
            {
                var result = _companyRepository.GetCompany(request.CompanyCode, request.CompanyName,request.CompanyId);

                return result;
            });

        }
    }
}