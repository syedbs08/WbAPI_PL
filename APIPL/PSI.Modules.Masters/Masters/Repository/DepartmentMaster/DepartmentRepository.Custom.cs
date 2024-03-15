using Core.BaseEntitySql.BaseRepository;
using Core.BaseUtility.TableSearchUtil;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Command.Department;
using PSI.Modules.Backends.Masters.Queries.CountryMaster;
using PSI.Modules.Backends.Masters.Queries.DepartmentMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.DepartmentMaster
{
    public partial interface IDepartmentMasterRepository
    {
        Department GetDepartment(string departmentCode, string departmentName);
        IEnumerable<DepartmentLookupCommand> DepartmentLookup();
        PagingResponse<Department> GetDepartments(PagingRequest searchItems);
        IEnumerable<Department> GetDepartments();
        Department GetDepartmentbyCodeNameId(string departmentCode, string departmentName, int departmentId);
        public bool CheckCompanyExistInDepartment(string? companyId);
    }
    public partial class DepartmentRepository
    {
        public Department GetDepartment(string departmentCode, string departmentName)
        {

            var result = FirstOrDefault(Query.WithFilter(Filter<Department>
                   .Create(p => p.IsActive == true
                   && p.DepartmentCode == departmentCode
                   || p.DepartmentName == departmentName)));
            return result;

        }
        public bool CheckCompanyExistInDepartment(string? companyId)
        {

            var result = FirstOrDefault(Query.WithFilter(Filter<Department>
                   .Create(p => p.IsActive == true
                   && p.CompanyId == companyId
                  )));
            
            return result==null?false:true;

        }
        public Department GetDepartmentbyCodeNameId(string departmentCode, string departmentName, int departmentId)
        {
            if (departmentId == 0)
            {
                var result = FirstOrDefault(Query.WithFilter(Filter<Department>
                  .Create(p => p.IsDeleted != true
                  && (p.DepartmentCode == departmentCode
                  || p.DepartmentName == departmentName
                  ))));
                return result;
            }
            else
            {
                var result = FirstOrDefault(Query.WithFilter(Filter<Department>
                 .Create(p => p.IsDeleted != true && p.DepartmentId != departmentId
                 && (p.DepartmentCode == departmentCode
                 || p.DepartmentName == departmentName)
                 )));
                return result;
            }
        }

        public PagingResponse<Department> GetDepartments(PagingRequest searchItems)
        {
            var filterMain = Filter<Department>.Create(p => p.IsDeleted != true);
            var query = Query.WithFilter(filterMain);
            if (!string.IsNullOrWhiteSpace(searchItems.Search.Value))
            {
                query = Query.WithFilter(filterMain.And(Filter<Department>
                  .Create(p => p.DepartmentName.Contains(searchItems.Search.Value)
                   || p.DepartmentCode.Contains(searchItems.Search.Value)
                  )));
            }
            var result = Get(query);
            return PagingDataResult.GetPagingResponse(result, searchItems);
        }
        public IEnumerable<DepartmentLookupCommand> DepartmentLookup()
        {
            var filterMain = Filter<Department>.Create(p => p.IsActive == true && p.IsDeleted != true);
            var query = Query.WithFilter(filterMain);
            var result= Get(query).Select(p => new DepartmentLookupCommand
            {
                DepartmentCode = p.DepartmentCode,
                DepartmentName = p.DepartmentName,
                DepartmentId = p.DepartmentId
            });
            return result;
        }
        public IEnumerable<Department> GetDepartments()
        {
            var filterMain = Filter<Department>.Create(p => p.IsDeleted != true);
            var query = Query.WithFilter(filterMain);
            return Get(query);
        }
    }
}
