

namespace PSI.Modules.Backends.Masters.Command.RegionMaster
{
    public class RegionCommand
    {
        public int RegionId { get; set; }

        public string? RegionName { get; set; }

        public string? RegionCode { get; set; }
        public string? RegionShortDescription { get; set; }

        public string? CreatedBy { get; set; }
        public string? UpdateBy { get; set; }
        public bool? IsActive { get; set; }
    }
}
