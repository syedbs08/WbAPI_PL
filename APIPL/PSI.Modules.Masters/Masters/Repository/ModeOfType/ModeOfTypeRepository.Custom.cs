using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;


namespace PSI.Modules.Backends.Masters.Repository.RegionMaster
{
    public partial interface IModeofTypeRepository
    {
        List<ModeofType> Get();
        ModeofType Get(string code);

    }
    public partial class ModeofTypeRepository
    {
        public List<ModeofType> Get()
        {
            return GetAll().ToList();
        }

        public ModeofType Get(string code)
        {
            var result = FirstOrDefault(Query.WithFilter(Filter<ModeofType>.Create( m => m.ModeofTypeCode == code)));

            return result;
        }

    }
}
