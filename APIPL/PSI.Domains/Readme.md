 # Entity generation
 Scaffold-DbContext "Server=pmmazsqldev01.database.windows.net;Database=psidevdb01;Persist Security Info=False;User ID=psidbadmin;Password=Lk#39!gF4Kd;" Microsoft.EntityFrameworkCore.SqlServer -OutputDir Entity

 Each Entity class should be inherited by BaseEntity
 PSIDbContext - is the context class where dbset can be defined
 Repository : all repository inherits base repository which contains below generic function
   
        Task<T> Add(T entity);
        Task<T> Update(T entity);
        Task<T> FindByKey(object key);
        Task<T> GetById(int id);
        T GetById(string id);
        T GetByIdSync(int id);
        TOut FirstOrDefault<TIn, TOut>(IQuery<TIn, TOut> query) where TIn : class;        
        int Count<TIn, TOut>(IQuery<TIn, TOut> query) where TIn : class;       
        IEnumerable<T> ExecuteCustomQuery(string query);
        Task<int> AddBulk(List<T> entity);
        IEnumerable<TOut> Get<TIn, TOut>(IQuery<TIn, TOut> query) where TIn : class;      
        IEnumerable<T> GetAll();
        IEnumerable<TOut> Get<TIn, TOut>(IQuery<TIn, TOut> query, int pageIndex, int pageSize) where TIn : class where TOut : class;       
        IEnumerable<T> ExecuteProcedure(string spName,  params SqlParameter[] parameters);
        Task<int> Delete(T entity);
        Task<int> Delete(List<T> entity);
        Task<int> Save();
        Task<int> Update(List<T> entity);
        Task<int> UpdateBulk(List<T> entity);

In case more custom query needed :create yourRepository.custom class and write your filter, e.g AccountRepository.custom.cs(see this repository for more idea)