using Core.BaseUtility.Utility;
using MediatR;

namespace PSI.Modules.Backends.Masters.Command.Department
{
    public class DeleteDepartmentCommand : IRequest<Result>
    {
        public DeleteDepartmentCommand(int departmentId, string updateBy)
        {
            DepartmentId = departmentId;
            UpdateBy = updateBy;
        }
        public int DepartmentId { get; set; }
        public string UpdateBy { get; set; }
    }
}
