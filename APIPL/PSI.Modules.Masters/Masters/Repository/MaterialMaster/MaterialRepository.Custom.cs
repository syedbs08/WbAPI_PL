using Core.BaseEntitySql.BaseRepository;
using Microsoft.EntityFrameworkCore;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Command.MaterialMaster;
using PSI.Modules.Backends.Masters.Queries.MaterialMaster;
using PSI.Modules.Backends.Masters.Queries.TurnoverDaysMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.MaterialMaster
{
    public partial interface IMaterialRepository
    {
        IEnumerable<Material> GetMaterials();
        List<Material> GetMaterialByCategory(int productCategoryId, int productSubCategoryId);
        Material GetMaterial(int? materialId, string materialCode,int comapnyId);
        bool ValidateMaterialByCategory(int materialID, int productCategoryID);

        List<Material> GetMaterialByCategorySubCategories(int productCategoryId, List<int> productSubCategoryIds);
        List<Material> GetMaterialByMg2Mg3(int productCategoryId, int? productSubCategoryId);
       
    }
    public partial class MaterialRepository {
        public IEnumerable<Material> GetMaterials()
        {
            return  GetAll();
        }
        public Material GetMaterial(int? materialId, string materialCode, int comapnyId)
        {

            if (materialId == 0)
            {
                var result = FirstOrDefault(Query.WithFilter(Filter<Material>
                  .Create(p => (p.CompanyId == comapnyId && (p.MaterialCode == materialCode ))
                  )));
                return result;
            }
            else
            {
                var result = FirstOrDefault(Query.WithFilter(Filter<Material>
                 .Create(p => p.MaterialId != materialId && p.CompanyId == comapnyId
                 && (p.MaterialCode == materialCode )
                 )));
                return result;
            }
        }

        public List<Material> GetMaterialByCategory(int productCategoryId, int productSubCategoryId)
        {
            var result = Get(Query.WithFilter(Filter<Material>.Create(c => c.ProductCategoryId1 == productCategoryId && c.ProductCategoryId2 == productSubCategoryId)));
            return result.ToList();
        }

        public bool ValidateMaterialByCategory(int materialID, int productCategoryID)
        {

            var result = Get(Query.WithFilter(Filter<Material>.Create(c => (c.ProductCategoryId1 == productCategoryID || c.ProductCategoryId2 == productCategoryID ||
             c.ProductCategoryId3 == productCategoryID || c.ProductCategoryId4 == productCategoryID || c.ProductCategoryId5 == productCategoryID || c.ProductCategoryId6 == productCategoryID
            ) && c.MaterialId== materialID)));
            return result.ToList().Count() > 0 ? true : false;

        }
        
        public List<Material> GetMaterialByCategorySubCategories(int productCategoryId, List<int> productSubCategoryIds)
        {
            var result = Get(Query.WithFilter(Filter<Material>.Create(c => c.ProductCategoryId1 == productCategoryId && c.ProductCategoryId2 != null && productSubCategoryIds.Contains((int) c.ProductCategoryId2))));
            return result.ToList();
        }

      
        public List<Material> GetMaterialsByCategorySubCategoriesAndSearchedCode(int productCategoryId, List<int> productSubCategoryIds, string materialCode)
        {
            var result = Get(Query.WithFilter(Filter<Material>
            .Create(c => c.ProductCategoryId1 == productCategoryId 
            && c.ProductCategoryId2 != null 
            && productSubCategoryIds.Contains((int) c.ProductCategoryId2)
            && c.MaterialCode != null
            && EF.Functions.Like(c.MaterialCode, $"%{materialCode}%"))));
            return result.ToList();
        }
        public List<Material> GetMaterialByMg2Mg3(int productCategoryId, int? productSubCategoryId)
        {
            if(productSubCategoryId == null)
            {
                var result = Get(Query.WithFilter(Filter<Material>.Create(c => c.ProductCategoryId2 == productCategoryId)));
                return result.ToList();
            }
            else
            {
                var result = Get(Query.WithFilter(Filter<Material>.Create(c => c.ProductCategoryId2 == productCategoryId && c.ProductCategoryId3 == productSubCategoryId)));
                return result.ToList();
            }
            
        }
      
    }
}
