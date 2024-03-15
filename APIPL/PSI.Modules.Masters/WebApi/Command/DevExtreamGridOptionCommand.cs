using DevExtreme.AspNet.Data;
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.WebApi.Command
{
    public class DevExtreamGridOptionCommand: DataSourceLoadOptionsBase
    {        
        public string Filters { get; set; }
    }
    public class FilterObject
    { 
        public string value { get; set; }
     public string Name { get; set; }
    }
}
