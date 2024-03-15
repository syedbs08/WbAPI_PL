
using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;



namespace PSI.Modules.Backends.Masters.Repository.AttachmentMaster
{
    // your custom query goes in here 
    public partial interface IAttachmentRepository
    {
        Attachment GetAttachmentById(int id);
    }
    public partial class AttachmentRepository
    {
        public Attachment GetAttachmentById(int id)
        {
            var result = FirstOrDefault(Query.WithFilter(Filter<Attachment>
                   .Create(p => p.Id == id
                   )));
            return result;
        }
        

    }
}