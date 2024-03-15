using Core.BaseUtility.Utility;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Command.ProductCategoryMaster
{
    public class DeleteProductCategoryCommand : IRequest<Result>
    {
        public DeleteProductCategoryCommand(int productCategoryId, string updateBy)
        {
            ProductCategoryId = productCategoryId;
            UpdateBy = updateBy;
        }
        public int ProductCategoryId { get; set; }
        public string UpdateBy { get; set; }
    }
}
