using Core.BaseUtility.MapperProfiles;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.CustomerMaster;
using PSI.Modules.Backends.Masters.Repository.CustomerMaster;
using PSI.Modules.Backends.Masters.Results;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.QueriesHandler.CustomerMaster
{
    public class CustomerSearchHandler : IRequestHandler<CustomerSearchQuery, IEnumerable<CustomerResult>>
    {
        private readonly ICustomerViewReopsitory _customerViewReopsitory;
        public CustomerSearchHandler(
                ICustomerViewReopsitory customerViewReopsitory
            )
        {
            _customerViewReopsitory = customerViewReopsitory;
        }
        public async Task<IEnumerable<CustomerResult>> Handle(CustomerSearchQuery request, CancellationToken cancellationToken)
        {
            try
            {
                var data = _customerViewReopsitory.GetAll().ToList();
                var mapResult = MappingProfile<CustomerView, CustomerResult>.MapList(data);
                return await Task.FromResult(mapResult);
            }
            catch (Exception ex)
            {
                return null;
            }
            
        }
    }
}