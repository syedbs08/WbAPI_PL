using DevExtreme.AspNet.Data;
using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using PSI.Domains;
using PSI.Modules.Backends.Masters.Queries.DashMaster;


namespace PSI.Modules.Backends.Masters.QueriesHandler.DashMaster
{
    public class DashMonthlyQueryHandler : IRequestHandler<DashMonthlySearchQuery, LoadResult>
    {
        private readonly PSIDbContext _context;
        public DashMonthlyQueryHandler()
        {
            _context = new PSIDbContext();
        }
        public async Task<LoadResult> Handle(DashMonthlySearchQuery request, CancellationToken cancellationToken)
        {

            var loadOptions = request?.LoadOptions;
            // loadOptions.Filter = null;
            var result = DataSourceLoader.Load(_context.VW_DashMasterMonthWise, loadOptions);
            return result;

        }
        private bool? GetJArrayValueLastBool(JArray? array)
        {
            if (array == null)
                return null;

            return Convert.ToBoolean(((JValue)array.LastOrDefault()).Value);
        }
        private string? GetJArrayValueLast(JArray? array)
        {
            if (array == null)
                return null;

            return ((JValue)array.LastOrDefault()).Value.ToString();
        }

        private string? GetJArrayValueFirst(JArray? array)
        {
            if (array == null)
                return null;

            return ((JValue)array.FirstOrDefault()).Value.ToString();
        }
        private string? GetFilterValue(string? value)
        {
            if (string.IsNullOrWhiteSpace(value))
                return null;
            else
                return value;

        }

    }
}
