using DevExtreme.AspNet.Data;
using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using PSI.Modules.Backends.DirectSales.Queries;
using PSI.Modules.Backends.DirectSales.Repository;
using PSI.Modules.Backends.DirectSales.Results;

namespace PSI.Modules.Backends.DirectSales.QueriesHandler
{
    public class OCOLockMonthSearchHandle : IRequestHandler<OCOLockMonthSearchQuery, LoadResult>
    {
        //  private readonly IOcoLockMonthRepository _lockMonthRepository;

          private readonly ISPSalesEntryOCConfirmationRepository _lockMonthRepository;
        
        public OCOLockMonthSearchHandle(
            ISPSalesEntryOCConfirmationRepository lockMonthRepository)
        {
            _lockMonthRepository = lockMonthRepository;
        }
        public Task<LoadResult> Handle(OCOLockMonthSearchQuery request, CancellationToken cancellationToken)
        {
            try
            {
                var data = _lockMonthRepository.GetCurrentMonthLock(request.COLockMonthCommand);
          
            var result = DataSourceLoader.Load(data, request.LoadOptions);
            return Task.FromResult(result);
            }
            catch (Exception ex)
            {
                return null;
            }
        }
    }
}
