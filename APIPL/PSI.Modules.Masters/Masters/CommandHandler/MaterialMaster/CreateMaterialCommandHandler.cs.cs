using Core.BaseUtility.MapperProfiles;
using Core.BaseUtility.Utility;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Command.MaterialMaster;
using PSI.Modules.Backends.Masters.Repository.MaterialMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.CommandHandler.MaterialMaster
{
    public class CreateMaterialCommandHandler : IRequestHandler<CreateMaterialCommand, Result>
    {
        private readonly IMaterialRepository _materialRepository;
        private readonly IMaterialViewReopsitory _materialViewRepository;
        private readonly IMaterialCountryMappingRepository _materialCountryMappingRepository;
        public CreateMaterialCommandHandler(IMaterialRepository materialRepository, IMaterialViewReopsitory materialViewRepository
            , IMaterialCountryMappingRepository materialCountryMappingRepository)
        {
            _materialRepository = materialRepository;
            _materialViewRepository = materialViewRepository;
            _materialCountryMappingRepository = materialCountryMappingRepository;
        }
        public async Task<Result> Handle(CreateMaterialCommand request, CancellationToken cancellationToken)
        {
            try
            {
                if (request.Material.MaterialId > 0)
                {
                    var Material = await _materialRepository.GetById(request.Material.MaterialId);
                    if (Material == null)
                    {
                        return Result.Failure($"Material not found to update {request.Material.MaterialId}");
                    }
                    Material.CompanyId = request.Material.CompanyId;
                    Material.MaterialCode = request.Material.MaterialCode;
                    Material.MaterialShortDescription = request.Material.MaterialShortDescription;
                    Material.MaterialCode = request.Material.MaterialCode;
                    Material.BarCode = request.Material.BarCode;
                    Material.InSap = request.Material.InSap == null ? false : request.Material.InSap;
                    Material.Weight = request.Material.Weight;
                    Material.Volume = request.Material.Volume;
                    Material.SeaPortId = request.Material.SeaPortId;
                    Material.AirPortId = request.Material.AirPortId;
                    Material.SupplierId = request.Material.SupplierId;
                    Material.ProductCategoryId1 = request.Material.ProductCategoryId1;
                    Material.ProductCategoryId2 = request.Material.ProductCategoryId2;
                    Material.ProductCategoryId3 = request.Material.ProductCategoryId3;
                    Material.ProductCategoryId4 = request.Material.ProductCategoryId4;
                    Material.ProductCategoryId5 = request.Material.ProductCategoryId5;
                    Material.ProductCategoryId6 = request.Material.ProductCategoryId6;
                    Material.IsActive = request.Material.IsActive;
                    Material.UpdateDate = DateTime.Now;
                    Material.UpdateBy = request.Material.UpdateBy;
                    var updateResult = _materialRepository.Update(Material);
                    if (updateResult == null)
                    {
                        Log.Error($"Material update: Error occured while updating {request.Material}");
                        return Result.Failure("Seems input value is not correct,Failed to update Material");
                    }
                    var existdata = _materialCountryMappingRepository.GetAll().Where(x=>x.MaterialId== Material.MaterialId);
                    await _materialCountryMappingRepository.Delete(existdata.ToList());
                    List<MaterialCountryMapping> res = new List<MaterialCountryMapping>();
                    foreach (var item in request.Material.CountryIds)
                    {
                        MaterialCountryMapping data = new MaterialCountryMapping();
                        data.MaterialId = Material.MaterialId;
                        data.CountryId = Convert.ToInt32(item);
                        data.CreatedDate = DateTime.Now;
                        data.CreatedBy= request.Material.UpdateBy;
                        res.Add(data);
                    }
                    await _materialCountryMappingRepository.AddBulk(res);
                    return Result.Success;
                }

                var MaterialObject = MappingProfile<MaterialCommand, Material>.Map(request.Material);
                if (MaterialObject == null)
                {
                    Log.Error($"Material Add: operation failed due to invalid mapping{request.Material}");
                    return Result.Failure("Seems input value is not correct,Failed to add Material");
                }
                MaterialObject.CreatedBy = request.Material.CreatedBy;
                MaterialObject.CreatedDate = DateTime.Now;
                MaterialObject.InSap = request.Material.InSap == null ? false : request.Material.InSap;
                var result = await _materialRepository.Add(MaterialObject);
               List<MaterialCountryMapping> materialCountryMapping = new List<MaterialCountryMapping>();
                foreach(var item in request.Material.CountryIds)
                {
                    MaterialCountryMapping data = new MaterialCountryMapping();
                    data.MaterialId = MaterialObject.MaterialId;
                    data.CountryId = Convert.ToInt32(item);
                    materialCountryMapping.Add(data);
                }
                await _materialCountryMappingRepository.AddBulk(materialCountryMapping);
                if (result == null)
                {
                    Log.Error($"Material Add:Db operation failed{result}");
                    return Result.Failure("Error in adding Material,contact to support team");
                }
                return Result.Success;

            }
            catch (Exception ex)
            {

                Log.Error($"Execption occured while adding Material {request.Material}", ex.Message);
                return Result.Failure("Problem in adding Material ,try later");

            }
        }
    }
}