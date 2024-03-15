using SAP.Middleware.Connector;
using System;


namespace PSISAPCore
{
    //public interface IResultMonthSales
    //{
    //    void GetResultMonthSales();
    //}
    public class ResultMonthSales
    {
        public void TestSapConnectivity()
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

            //22
            RfcDestination dest = RfcDestinationManager.GetDestination(parms);

            try
            {
                dest.Ping();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        
    }
}
