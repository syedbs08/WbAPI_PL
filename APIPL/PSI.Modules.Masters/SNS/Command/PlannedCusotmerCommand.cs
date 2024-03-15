using System.ComponentModel.DataAnnotations;

namespace PSI.Modules.Backends.SNS.Command
{
    public class PlannedCusotmerCommand
    {
        [Required]
        public string AccountCode { get; set; }
        [Required]
        public string MaterialCode { get; set; }
    }
}
