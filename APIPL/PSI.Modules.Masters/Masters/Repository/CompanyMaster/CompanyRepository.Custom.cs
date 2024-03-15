
using Core.BaseEntitySql.BaseRepository;
using Core.BaseUtility.MapperProfiles;
using Core.BaseUtility.TableSearchUtil;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Results;
using System.Drawing;

namespace PSI.Modules.Backends.Masters.Repository.CompanyMaster
{
    public partial interface ICompanyRepository
    {
        Company GetCompany(string companyCode, string companyName, int companyId);
        IEnumerable<Company> GetAllCompanies();
        List<CompanyResult> ExportCompanies();
    }
    public partial class CompanyRepository
    {
        public Company GetCompany(string CompanyCode, string CompanyName, int companyId)
        {
            if (companyId == 0)
            {
                var result = FirstOrDefault(Query.WithFilter(Filter<Company>
                  .Create(p => p.IsDeleted != true
                  && ( p.CompanyCode == CompanyCode
                  || p.CompanyName == CompanyName
                  ))));
                return result;
            }
            else
            {
                var result = FirstOrDefault(Query.WithFilter(Filter<Company>
                 .Create(p => p.IsDeleted != true && p.CompanyId != companyId
                 && (p.CompanyCode == CompanyCode
                 || p.CompanyName == CompanyName)
                 )));
                return result;
            }
        }
        public List<CompanyResult> ExportCompanies()
        {
            var result = GetAllCompanies();
            var mapResult = MappingProfile<Company, CompanyResult>.MapList(result.ToList());
            return mapResult;
        }
        public IEnumerable<Company> GetAllCompanies()
        {
            return GetAll().Where(x => x.IsDeleted != true);
        }
    }
}
