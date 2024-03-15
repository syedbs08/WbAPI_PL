using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;


namespace PSI.Modules.Backends.Masters.Repository.MaterialMaster
{
    public partial interface IMaterialViewReopsitory
    {
        MaterialView GetMaterialByCode(string materialCode);
        List<MaterialView> GetMaterialByCodes(string[] materialCode);
    }
    public partial class MaterialViewReopsitory
    {
        public MaterialView GetMaterialByCode(string materialCode)
        {
            var query = Query.WithFilter(
                 Filter<MaterialView>.Create(p => p.MaterialCode == materialCode)
                 );
            var result = FirstOrDefault(query);
            return result;
        }


        public List<MaterialView> GetMaterialByCodes(string[] materialCode)
        {
            var filterExpression = Filter<MaterialView>.Create(p => materialCode.Contains(p.MaterialCode));
            var result = Get(Query.WithFilter(filterExpression));
            return result.ToList();


        }

    }
}
