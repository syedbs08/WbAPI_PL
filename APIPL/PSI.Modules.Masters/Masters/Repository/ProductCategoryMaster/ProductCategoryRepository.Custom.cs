using Core.BaseEntitySql.BaseRepository;
using Core.BaseUtility.TableSearchUtil;
using NPOI.Util;
using Org.BouncyCastle.Crypto;
using PSI.Domains.Entity;
using PSI.Modules.Backends.SNS.Command;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.ProductCategoryMaster
{

    public partial interface IProductCategoryRepository
    {
        List<ProductCategory> GetProductCategories();
        ProductCategory GetProductCategory(string? parentCategoryId, string productCategoryName, int? categoryLevel, int? productCategoryId,string productCategoryCode);
        bool IsValidProductCategory(int productCategoryID);
        List<ProductCategory> GetProductCategoriesByMG(List<int?> mgIds);
        List<ProductCategory> GetAllMG1();
    }
    public partial class ProductCategoryRepository
    {
        public List<ProductCategory> GetProductCategories()
        {
            var result = Get(Query.WithFilter(Filter<ProductCategory>
                 .Create(p => p.IsActive == true )));
            return result.ToList();
        }
        public ProductCategory GetProductCategory(string? parentCategoryId, string productCategoryName, int? categoryLevel, int? productCategoryId, string productCategoryCode)
        {
            if (productCategoryId == 0)
            {
                var result = FirstOrDefault(Query.WithFilter(Filter<ProductCategory>
                  .Create(p => p.Isdeleted != true
                  && (p.ProductCategoryName == productCategoryName ) && (p.CategoryLevel == categoryLevel && p.ParentCategoryId== parentCategoryId)
                  )));
                return result;
            }
            else
            {
                var result = FirstOrDefault(Query.WithFilter(Filter<ProductCategory>
                 .Create(p => p.Isdeleted != true && p.ProductCategoryId != productCategoryId
                 && (p.ProductCategoryName == productCategoryName ) && (p.CategoryLevel == categoryLevel && p.ParentCategoryId == parentCategoryId)
                 )));
                return result;
            }
        }
        
        public bool IsValidProductCategory(int productCategoryID)
        {
            return  GetAll().Any(x => x.ProductCategoryId == productCategoryID);
         
        }
        public List<ProductCategory> GetProductCategoriesByMG(List<int?> mgIds)
        {
            try
            {
                List<string> stringList = mgIds.Select(i => i.HasValue ? i.Value.ToString() : "null").ToList();
                var result = GetAll().Where(x =>x.CategoryLevel==2 && (x.ParentCategoryId != null && x.ParentCategoryId.Split(",").Any(c => stringList.Contains(c))));
                return result.ToList();
            }
            catch(Exception ex)
            {
                return null;
            }
        }
        public List<ProductCategory> GetAllMG1()
        {
            try
            {
                var result = Get(Query.WithFilter(Filter<ProductCategory>
                   .Create(p => p.IsActive == true && p.CategoryLevel==2)));
                return result.ToList();
            }
            catch (Exception ex)
            {
                return null;
            }
        }
    }
}
