using Core.BaseUtility.MapperProfiles;
using Core.BaseUtility.Utility;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Command.CustomerMaster;
using PSI.Modules.Backends.Masters.Command.CustomerMaster;
using PSI.Modules.Backends.Masters.Repository.AccountMaster;
using PSI.Modules.Backends.Masters.Repository.CustomerMaster;
using PSI.Modules.Backends.Masters.Repository.MaterialMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static PSI.Modules.Backends.Constants.Contants;

namespace PSI.Modules.Backends.Masters.CommandHandler.CustomerMaster
{
    public class CreateCustomerCommandHandler : IRequestHandler<CreateCustomerCommand, Result>
    {
        private readonly ICustomerRepository _customerRepository;
      
        private readonly ICustomerDIDRepository _customerDIDRepository;
        private readonly IMaterialRepository _materialRepository;
        private readonly IAccountRepository _accountRepository;

        public CreateCustomerCommandHandler(ICustomerRepository customerRepository,
            ICustomerDIDRepository customerDIDRepository,
            IMaterialRepository materialRepository,
            IAccountRepository accountRepository
           )
        {
            _customerRepository = customerRepository;
            _customerDIDRepository = customerDIDRepository;
            _materialRepository = materialRepository;
            _accountRepository = accountRepository;

        }
        public async Task<Result> Handle(CreateCustomerCommand request, CancellationToken cancellationToken)
        {
            try
            {
                var material = _materialRepository.GetAll();
                string accountcode = _accountRepository.GetAll().Where(x => x.AccountId == request.Customer.AccountId).Select(x => x.AccountCode).FirstOrDefault();
                if (request.Customer.CustomerId > 0)
                {
                    var Customer = await _customerRepository.GetById(request.Customer.CustomerId);
                    if (Customer == null)
                    {
                        return Result.Failure($"Customer not found to update {request.Customer.CustomerId}");
                    }
                    Customer.CustomerId = request.Customer.CustomerId;
                    Customer.CustomerCode = request.Customer.CustomerCode;
                    Customer.CustomerName = request.Customer.CustomerName;
                    Customer.CustomerShortName = request.Customer.CustomerShortName;
                    Customer.EmailId = request.Customer.EmailId;
                    Customer.SalesOfficeId = request.Customer.SalesOfficeId;
                    Customer.RegionId = request.Customer.RegionId;
                    Customer.CountryId = request.Customer.CountryId;
                    Customer.DepartmentId = request.Customer.DepartmentId;
                    Customer.PersonInChargeId = request.Customer.PersonInChargeId;
                    Customer.IsActive = request.Customer.IsActive;
                    Customer.IsPsi = request.Customer.IsPSI == null ? false : request.Customer.IsPSI;
                    Customer.IsBp = request.Customer.IsBP == null ? false : request.Customer.IsBP;
                    Customer.IsActive = request.Customer.IsActive;
                    Customer.IsCollabo = request.Customer.IsCollabo == null ? false : request.Customer.IsCollabo;
                    Customer.IsActive = request.Customer.IsActive;
                    Customer.UpdateDate = DateTime.Now;
                    Customer.UpdateBy = request.Customer.UpdateBy;
                    Customer.CurrencyCode = request.Customer.CurrencyCode;

                    var updateResult = _customerRepository.Update(Customer);
                    if (updateResult == null)
                    {
                        Log.Error($"Customer update: Error occured while updating {request.Customer}");
                        return Result.Failure("Seems input value is not correct,Failed to update Customer");
                    }
                    var existdata = _customerDIDRepository.GetAll().Where(x => x.CustomerId == Customer.CustomerId);
                    await _customerDIDRepository.Delete(existdata.ToList());
                    List<CustomerDID> customerDIDupdate = new List<CustomerDID>();
                    foreach (var item in request.Customer.SalesTypeIds)
                    {
                        CustomerDID data = new CustomerDID();
                        data.CustomerId = Customer.CustomerId;
                        if(item== (int)SaleTypeEnum.SNS)
                        {
                            data.AccountId = request.Customer.AccountId;
                            data.AccountCode = accountcode;
                        }
                        data.CustomerCode = Customer.CustomerCode;
                        data.SalesOrganizationCode = request.Customer.SalesOrganizationCode;
                        data.SaleTypeId = item;
                        data.CreatedDate = DateTime.Now;
                        data.CreatedBy = request.Customer.CreatedBy;
                        customerDIDupdate.Add(data);
                    }
                    await _customerDIDRepository.AddBulk(customerDIDupdate);
                    return Result.Success;
                }

                var CustomerObject = MappingProfile<CustomerCommand, Customer>.Map(request.Customer);
                if (CustomerObject == null)
                {
                    Log.Error($"Customer Add: operation failed due to invalid mapping{request.Customer}");
                    return Result.Failure("Seems input value is not correct,Failed to add Customer");
                }
                CustomerObject.CreatedBy = request.Customer.CreatedBy;
                CustomerObject.CreatedDate = DateTime.Now;
                CustomerObject.IsPsi = CustomerObject.IsPsi == null ? false : CustomerObject.IsPsi;
                CustomerObject.IsBp = CustomerObject.IsBp == null ? false : CustomerObject.IsBp;
                CustomerObject.IsCollabo = CustomerObject.IsCollabo == null ? false : CustomerObject.IsCollabo;
                
                var result = await _customerRepository.Add(CustomerObject);
                List<CustomerDID> customerDID = new List<CustomerDID>();
                foreach (var item in request.Customer.SalesTypeIds)
                {
                    CustomerDID data = new CustomerDID();
                    data.CustomerId = CustomerObject.CustomerId;
                    data.CustomerCode = CustomerObject.CustomerCode;
                    data.AccountCode = accountcode;
                    data.AccountId = request.Customer.AccountId;
                    data.SalesOrganizationCode = request.Customer.SalesOrganizationCode;
                    data.SaleTypeId = item;
                    data.CreatedDate = DateTime.Now;
                    data.CreatedBy = request.Customer.CreatedBy;
                    customerDID.Add(data);
                }
                await _customerDIDRepository.AddBulk(customerDID);
                if (result == null)
                {
                    Log.Error($"Customer Add:Db operation failed{result}");
                    return Result.Failure("Error in adding Customer,contact to support team");
                }
                return Result.Success;

            }
            catch (Exception ex)
            {

                Log.Error($"Execption occured while adding Customer {request.Customer}", ex.Message);
                return Result.Failure("Problem in adding Customer ,try later");

            }
        }
    }
}