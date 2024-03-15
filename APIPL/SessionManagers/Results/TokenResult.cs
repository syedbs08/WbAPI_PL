using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SessionManagers.Results
{
    public class TokenResult
    {
        public string Token { get; set; }
        public DateTimeOffset ExpiresOn { get; set; }
    }
}
