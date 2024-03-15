using Core.BaseUtility.Utility;
using MediatR;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Transmission.Command;
using System.Data;

namespace PSI.Modules.Backends.Transmission.CommandHandler
{
    public class CreatePreTransmissionListCommandHandler : IRequestHandler<CreatePreTransmissionListCommand, Result>
    {
        private readonly PSIDbContext _context;
        public CreatePreTransmissionListCommandHandler()
        {
            _context = new PSIDbContext();
        }
        public async Task<Result> Handle(CreatePreTransmissionListCommand request, CancellationToken cancellationToken)
        {
            try
            {
                List<SP_ResponseResult> result = new List<SP_ResponseResult>();
                foreach (var customerCode in request.PreTransmissionListCommand.CustomerCode)
                {
                    var paramResultMonth = new SqlParameter("@ResultMonth", SqlDbType.Int);
                    paramResultMonth.Value = request.PreTransmissionListCommand.ResultMonth;

                    var paramCurrentMonth = new SqlParameter("@CurrentMonth", SqlDbType.Int);
                    paramCurrentMonth.Value = request.PreTransmissionListCommand.CurrentMonth;

                    var paramType = new SqlParameter("@Type", SqlDbType.NVarChar, 10);
                    paramType.Value = request.PreTransmissionListCommand.Type;

                    var paramCreatedBy = new SqlParameter("@CreatedBy", SqlDbType.NVarChar, 500);
                    paramCreatedBy.Value = request.SessionData.ADUserId;

                    var dtCustomerCodeList = new DataTable();
                    dtCustomerCodeList.Columns.Add(new DataColumn("CustomerCode", typeof(string)));
                    //foreach (var customerCode in request.PreTransmissionListCommand.CustomerCode)
                    //{
                    dtCustomerCodeList.Rows.Add(customerCode);
                    //}
                    var tvpCustomerCodeList = new SqlParameter("@TVP_CUSTOMERCODE_LIST", SqlDbType.Structured);
                    tvpCustomerCodeList.Value = dtCustomerCodeList;

                    tvpCustomerCodeList.TypeName = "dbo.TVP_CUSTOMERCODE_LIST";
                    var param = new SqlParameter[] {
                    tvpCustomerCodeList,
                     paramCurrentMonth,
                     paramResultMonth,
                     paramType,
                     paramCreatedBy
            };

                    if (request.PreTransmissionListCommand.Type.ToUpper() == "BP")
                    {
                        result = _context.SP_ResponseResult.FromSqlRaw("dbo.SP_TRANSMISSION_BP @TVP_CUSTOMERCODE_LIST,@CurrentMonth,@ResultMonth,@Type,@CreatedBy", param).AsNoTracking().ToList();

                    }
                    else
                    {
                        result = _context.SP_ResponseResult.FromSqlRaw("dbo.SP_TRANSMISSION_MONTHLY @TVP_CUSTOMERCODE_LIST,@CurrentMonth,@ResultMonth,@Type,@CreatedBy", param).AsNoTracking().ToList();

                    }
                }
                if (result == null)
                {
                    Log.Error($"Pre Transmission list Add:Db operation failed{result}");
                    return Result.Failure("Error in adding Pre Transmission,contact to support team");
                }
                else
                {
                    var spResult = result.ToList().Where(r => r.ResponseCode == "500");
                    if (spResult.Any())
                    {
                        Log.Error($"Pre Transmission list Add:Db operation failed{spResult}");
                        return Result.Failure("Error in adding Pre Transmission,contact to support team");
                    }
                    else
                    {
                        return Result.Success;

                    }
                }

            }
            catch (Exception ex)
            {
                Log.Error($"Pre Transmission list Add:Db operation failed{ex.Message}");
                return Result.Failure("Error in adding Pre Transmission List,contact to support team");
            }

        }

    }
}
