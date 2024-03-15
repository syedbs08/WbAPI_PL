

using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.CompanyMaster;
using PSI.Modules.Backends.Masters.Repository.CompanyMaster;
namespace PSI.Modules.Backends.Masters.QueriesHandler.AccountMaster
{
    public class CompanyByIdQueryHandler : IRequestHandler<CompanyByIdQuery, Company>
    {

        private readonly ICompanyRepository _companyRepository;
        public CompanyByIdQueryHandler(ICompanyRepository companyRepository)
        {
            _companyRepository = companyRepository;
        }

        public async Task<Company> Handle(CompanyByIdQuery request, CancellationToken cancellationToken)
        {
            return await Task.Run(() =>
            {
                var result = _companyRepository.GetById(request.Id);
                return result;
            });

        }
    }
}