using Core.BaseEntitySql.BaseRepository;
using Org.BouncyCastle.Crypto;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Transmission.Repository
{
    public partial interface ITransmissionListRepository
    {
        IEnumerable<TransmissionList> GetTransmissionListActive();
        TransmissionList GetTransmissionList(string? planTypeCode, string? customerCode, string? salesType);
        IEnumerable<TransmissionListView> GetTransmissionCustomerByPlanTypeBySaleType(string? planTypeCode, string? salesType);
    }
    public partial class TransmissionListRepository
    {
        public IEnumerable<TransmissionList> GetTransmissionListActive()
        {
            var result = Query.WithFilter(Filter<TransmissionList>.Create(p => p.IsActive == true));
            return Get(result);
        }
        public TransmissionList GetTransmissionList(string? planTypeCode, string? customerCode, string? salesType)
        {
            var result = FirstOrDefault(Query.WithFilter(Filter<TransmissionList>
                    .Create(p =>p.PlanTypeCode == planTypeCode
                    && p.CustomerCode == customerCode && p.SalesType == salesType && p.IsActive==true
                    )));
            return result;
        }
        public IEnumerable<TransmissionListView> GetTransmissionCustomerByPlanTypeBySaleType(string? planTypeCode, string? salesType)
        {
            var result=  Get(Query.WithFilter(Filter<TransmissionListView>
                  .Create(p => p.PlanTypeCode == planTypeCode
                    && p.SalesType == salesType 
                  ))).ToList();
            return result;
        }
    }
}
