using SAP.Middleware.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSISAPCore
{
    public  class   SapConnectionConfig 
    {
       
        public static RfcConfigParameters GetParameters(string destinationName)
        {
            RfcConfigParameters parms = new RfcConfigParameters();

            parms.Add(RfcConfigParameters.Name, "R3Q");
            parms.Add(RfcConfigParameters.AppServerHost, "10.85.192.14");
            parms.Add(RfcConfigParameters.SystemNumber, "22");
            parms.Add(RfcConfigParameters.User, "BAPIADMIN");
            parms.Add(RfcConfigParameters.Password, "init1234");
            parms.Add(RfcConfigParameters.Client, "430");
            parms.Add(RfcConfigParameters.Language, "EN");
            parms.Add(RfcConfigParameters.PoolSize, "5");


            return parms;

        }
    }
}
