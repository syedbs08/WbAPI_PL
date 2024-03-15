using Core.BaseUtility.Utility;
using EFCore.BulkExtensions;
using Microsoft.EntityFrameworkCore;
using Microsoft.Graph;
using PSI.Domains;
using PSI.Domains.BWEntity;
using Log = Core.BaseUtility.Utility.Log;

namespace PSI.Modules.Backends.BWIntegration
{
    public class BWIntegrationService : IBWIntegrationService
    {


        public BWIntegrationService(

            )
        {


        }
        public Result SaveBWData()
        {
            try
            {

                Task.Run(() => RunAgentBPOPSI());
                Task.Run(() => RunLMAgentOPSI());
                Task.Run(() => RunForeCaseAgentSales());
                Task.Run(() => RunForeCastAgentOPSI());
                Task.Run(() => RunAgentBPSales());
                Task.Run(() => RunSLMAgentSNS());

            }
            catch (Exception ex)
            {
                Log.Error($"exception occured {ex}");

            }
            return Result.Success;
        }

        private void RunAgentBPOPSI()
        {
            //
            using (var psicontext = new PSIDbContext())
            {
                var agentOPSI = psicontext.SP_BI_BP_AGENT_OPSI.FromSqlRaw($"SP_BI_BP_AGENT_OPSI").ToList();

                Log.Information($"total record to insert for SP_BI_BP_AGENT_OPSI : {agentOPSI.Count}");
                if (agentOPSI.Any())
                {
                    var bwTable = agentOPSI.Select(x => new BI_BP_AGENT_OPSI
                    {
                        COMPANY = x.COMPANY,
                        PSI_CONS_CODE = x.PSI_CONS_CODE,
                        SALESOFFICE = x.SALESOFFICE,
                        REGION = x.REGION,
                        DEPARTMENT = x.DEPARTMENT,
                        PSI_ITEM_CODE = x.PSI_ITEM_CODE,
                        COUNTRY = x.COUNTRY,
                        PSI_YYYYMM = x.PSI_YYYYMM,
                        MG1 = x.MG1,
                        MG2 = x.MG2,
                        MG3 = x.MG3,
                        MG4 = x.MG4,
                        MG5 = x.MG5,
                        SALES_TYPE = x.SALES_TYPE,
                        MGGROUP = x.MGGroup,
                        BP_I_AMT = x.BP_I_AMT,
                        BP_I_AMT_USD = x.BP_I_AMT_USD,
                        BP_I_QTY = x.BP_I_QTY,
                        BP_O_AMT = x.BP_O_AMT,
                        BP_O_AMT_USD = x.BP_O_AMT_USD,
                        BP_O_QTY = x.BP_O_QTY,
                        BP_P_AMT = x.BP_P_AMT,
                        BP_P_AMT_USD = x.BP_P_AMT_USD,
                        BP_P_QTY = x.BP_P_QTY,
                        BP_S_AMT = x.BP_S_AMT,
                        BP_S_AMT_USD = x.BP_S_AMT_USD,
                        BP_S_QTY = x.BP_S_QTY,
                        CREATEDON = DateTime.Now,
                        UPDATEDON = DateTime.Now
                    });

                    using (var context = new BWDbConext())
                    {

                        UpdateInsertBI_BP_AGENT_OPSI(context, bwTable.ToList());
                        var agenOpsiDate = psicontext.BWExecutionLog.FirstOrDefault(x => x.Process == "BI_BP_AGENT_OPSI");
                        agenOpsiDate.LastExecutionDateTime = DateTime.Now;
                        psicontext.BWExecutionLog.Update(agenOpsiDate);
                        psicontext.SaveChanges();

                    }
                }

                Log.Information($"successful insertion in bw SP_BI_BP_AGENT_OPSI");

            }
        }
        private void RunLMAgentOPSI()
        {
            using (var psicontext = new PSIDbContext())
            {

                var lmAgentOPSI = psicontext.SP_BI_LM_AGENT_OPSI.FromSqlRaw($"SP_BI_LM_Agent_OPSI").ToList();
                Log.Information($"total record to insert SP_BI_LM_Agent_OPSI:  {lmAgentOPSI.Count}");
                if (lmAgentOPSI.Any())
                {
                    var agentbwTable = lmAgentOPSI.Select(x => new BI_LM_AGENT_OPSI
                    {
                        COMPANY = x.COMPANY,
                        PSI_CONS_CODE = x.PSI_CONS_CODE,
                        SALESOFFICE = x.SALESOFFICE,
                        REGION = x.REGION,
                        DEPARTMENT = x.DEPARTMENT,
                        PSI_ITEM_CODE = x.PSI_ITEM_CODE,
                        COUNTRY = x.COUNTRY,
                        PSI_YYYYMM = x.PSI_YYYYMM,
                        MG1 = x.MG1,
                        MG2 = x.MG2,
                        MG3 = x.MG3,
                        MG4 = x.MG4,
                        MG5 = x.MG5,
                        MGGROUP = x.MGGroup,
                        LM_O_QTY = x.LM_O_QTY,
                        LM_O_AMT = x.LM_O_AMT,
                        LM_O_AMT_USD = x.LM_O_AMT_USD,
                        LM_P_QTY = x.LM_P_QTY,
                        LM_P_AMT = x.LM_P_AMT,
                        LM_P_AMT_USD = x.LM_P_AMT_USD,
                        LM_S_QTY = x.LM_S_QTY,
                        LM_S_AMT = x.LM_S_AMT,
                        LM_S_AMT_USD = x.LM_S_AMT_USD,
                        LM_I_QTY = x.LM_I_QTY,
                        LM_I_AMT = x.LM_I_AMT,
                        LM_I_AMT_USD = x.LM_I_AMT_USD,
                        CREATEDON = DateTime.Now,
                        UPDATEDON = DateTime.Now,
                        SALES_TYPE=x.SALES_TYPE
                    });



                    using (var context = new BWDbConext())
                    {

                        UpdateInsertBI_LM_Agent_OPSI(context, agentbwTable.ToList());
                        var agenOpsiDate = psicontext.BWExecutionLog.FirstOrDefault(x => x.Process == "BI_LM_Agent_OPSI");
                        agenOpsiDate.LastExecutionDateTime = DateTime.Now;
                        psicontext.BWExecutionLog.Update(agenOpsiDate);
                        psicontext.SaveChanges();
                    }
                }
                //_agentOpsiRepository.AddBulk(bwTable.ToList());

                Log.Error($"successful insertion in bw SP_BI_LM_Agent_OPSI");

                //

            }

        }

        private void RunForeCaseAgentSales()
        {
            using (var psicontext = new PSIDbContext())
            {
                var ForeCastAgentOPSI = psicontext.SP_BI_FORECAST_AGENT_SNS_SALES.FromSqlRaw($"SP_BI_Forecast_AGENT_SNS_SALES").ToList();
                Log.Information($"total record to insert SP_BI_Forecast_AGENT_SNS_SALES: {ForeCastAgentOPSI.Count}");
                if (ForeCastAgentOPSI.Any())
                {
                    var ForeCastAgen = ForeCastAgentOPSI.Select(x => new BI_FCS_AGENT_SNS_SALES
                    {
                        COMPANY = x.COMPANY,
                        PSI_CONS_CODE = x.PSI_CONS_CODE,
                        SALESOFFICE = x.SALESOFFICE,
                        REGION = x.REGION,
                        DEPARTMENT = x.DEPARTMENT,
                        PSI_ITEM_CODE = x.PSI_ITEM_CODE,
                        COUNTRY = x.COUNTRY,
                        MGGROUP = x.MGGroup,

                        MG1 = x.MG1,
                        MG2 = x.MG2,
                        MG3 = x.MG3,
                        MG4 = x.MG4,
                        MG5 = x.MG5,
                        SALES_TYPE = x.SALES_TYPE,
                        PSI_YYYYMM = x.PSI_YYYYMM,

                        CURRENT_PLAN_QTY = x.CURRENT_PLAN_QTY,
                        CURRENT_PLANAMT = x.CURRENT_PLAN_AMT,
                        CURRENT_COSTAMT = x.CURRENT_COST_AMT,
                        CURRENT_GPAMT = x.CURRENT_GPAMT,
                        CURRENT_SALES_QTY = x.CURRENT_SALES_QTY,
                        CURRENT_SALES_AMT = x.CURRENT_SALES_AMT,
                        CURRENT_SALES_GPAMT = x.CURRENT_SALES_GPAMT,
                        LY_PLAN_QTY = x.LY_PLAN_QTY,
                        LY_PLANAMT = x.LY_PLAN_AMT,
                        LY_COSTAMT = x.LY_COST_AMT,
                        LY_GPAMT = x.LY_GPAMT,
                        LY_SALES_QTY = x.LY_SALES_QTY,
                        LY_SALES_AMT = x.LY_SALES_AMT,
                        LY_SALES_GPAMT = x.LY_SALES_GPAMT,
                        CREATEDON = DateTime.Now,
                        UPDATEDON = DateTime.Now
                    });

                    using (var context = new BWDbConext())
                    {

                        UpdateInsertBI_Forecast_AGENT_SNS_SALES(context, ForeCastAgen.ToList());
                        var agenOpsiDate = psicontext.BWExecutionLog.FirstOrDefault(x => x.Process == "BI_FORECAST_AGENT_SNS_SALES");
                        agenOpsiDate.LastExecutionDateTime = DateTime.Now;
                        psicontext.BWExecutionLog.Update(agenOpsiDate);
                        psicontext.SaveChanges();
                    }
                    //_agentOpsiRepository.AddBulk(bwTable.ToList());


                }
                Log.Error($"successful insertion in bw SP_BI_Forecast_AGENT_SNS_SALES");
            }

        }
        private void RunForeCastAgentOPSI()
        {
            using (var psicontext = new PSIDbContext())
            {
                var BiAgentOPSI = psicontext.SP_BI_FORECAST_AGENT_OPSI.FromSqlRaw($"SP_BI_FORECAST_AGENT_OPSI").ToList();
                Log.Error($"total record to insert SP_BI_FORECAST_AGENT_OPSI: {BiAgentOPSI.Count}");
                if (BiAgentOPSI.Any())
                {
                    var foreCastAgent = BiAgentOPSI.Select(x => new BI_FORECAST_AGENT_OPSI
                    {
                        COMPANY = x.COMPANY,
                        PSI_CONS_CODE = x.PSI_CONS_CODE,
                        SALESOFFICE = x.SALESOFFICE,
                        REGION = x.REGION,
                        DEPARTMENT = x.DEPARTMENT,
                        PSI_ITEM_CODE = x.PSI_ITEM_CODE,
                        COUNTRY = x.COUNTRY,
                        MGGROUP = x.MGGroup,

                        MG1 = x.MG1,
                        MG2 = x.MG2,
                        MG3 = x.MG3,
                        MG4 = x.MG4,
                        MG5 = x.MG5,
                        SALES_TYPE = x.SALES_TYPE,
                        PSI_YYYYMM = Convert.ToInt32(x.PSI_YYYYMM),
                        O_QTY = x.O_QTY,
                        O_AMT = x.O_AMT,
                        O_AMT_USD = x.O_AMT_USD,
                        P_QTY = x.P_QTY,
                        P_AMT = x.P_AMT,
                        P_AMT_USD = x.P_AMT_USD,
                        S_QTY = x.S_QTY,
                        S_AMT = x.S_AMT,
                        S_AMT_USD = x.S_AMT_USD,
                        I_QTY = x.I_QTY,
                        I_AMT = x.I_AMT,
                        I_AMT_USD = x.I_AMT_USD,
                        PSI_COST_AMT = x.PSI_COST_AMT,

                        LY_O_QTY = x.LY_O_QTY,
                        LY_O_AMT = x.LY_O_AMT,
                        LY_O_AMT_USD = x.LY_O_AMT_USD,
                        LY_P_QTY = x.LY_P_QTY,
                        LY_P_AMT = x.LY_P_AMT,
                        LY_P_AMT_USD = x.LY_P_AMT_USD,
                        LY_S_QTY = x.LY_S_QTY,
                        LY_S_AMT = x.LY_S_AMT,
                        LY_S_AMT_USD = x.LY_S_AMT_USD,
                        LY_I_QTY = x.LY_I_QTY,
                        LY_I_AMT = x.LY_I_AMT,
                        LY_I_AMT_USD = x.LY_I_AMT_USD,
                        NXT_SALE_AMT = x.NXT_SALE_AMT,
                        NXT_SALE_AMT_USD = x.NXT_SALE_AMT_USD,


                        CREATEDON = DateTime.Now,
                        UPDATEDON = DateTime.Now
                    });

                    using (var context = new BWDbConext())
                    {

                        UpdateInsertBI_FORECAST_AGENT_OPSI(context, foreCastAgent.ToList());
                        var agenOpsiDate = psicontext.BWExecutionLog.FirstOrDefault(x => x.Process == "BI_FORECAST_AGENT_OPSI");
                        agenOpsiDate.LastExecutionDateTime = DateTime.Now;
                        psicontext.BWExecutionLog.Update(agenOpsiDate);
                        psicontext.SaveChanges();

                    }

                }
                Log.Error($"successful insertion in bw SP_BI_FORECAST_AGENT_OPSI");


            }


        }

        private void RunAgentBPSales()
        {

            using (var psicontext = new PSIDbContext())
            {
                var AgentSNS = psicontext.SP_BI_BP_AGENT_SNS.FromSqlRaw($"SP_BI_BP_AGENT_SNS").ToList();
                Log.Information($"total record to insert SP_BI_BP_AGENT_SNS {AgentSNS.Count}");
                if (AgentSNS.Any())
                {
                    var foreCastAgent = AgentSNS.Select(x => new BI_BP_AGENT_SNS
                    {
                        COMPANY = x.COMPANY,
                        PSI_CONS_CODE = x.PSI_CONS_CODE,
                        SALESOFFICE = x.SALESOFFICE,
                        REGION = x.REGION,
                        DEPARTMENT = x.DEPARTMENT,
                        COUNTRY = x.COUNTRY,
                        MGGROUP = x.MGGroup,
                        MG1 = x.MG1,
                        MG2 = x.MG2,
                        MG3 = x.MG3,
                        MG4 = x.MG4,
                        MG5 = x.MG5,
                        PSI_ITEM_CODE = x.PSI_ITEM_CODE,
                        PSI_YYYYMM = x.PSI_YYYYMM,
                        SALES_TYPE = x.SALES_TYPE,
                        BP_QTY = x.BP_QTY,
                        BP_AMT = x.BP_AMT,
                        BP_COST_AMT = x.BP_COST_AMT,
                        BP_GPAMT = x.BP_GPAMT,
                        CREATEDON = DateTime.Now,
                        UPDATEDON = DateTime.Now
                    });

                    using (var context = new BWDbConext())
                    {

                        UpdateInsertBI_BP_AGENT_SNS(context, foreCastAgent.ToList());

                        var agenOpsiDate = psicontext.BWExecutionLog.FirstOrDefault(x => x.Process == "BI_BP_AGENT_SNS");
                        agenOpsiDate.LastExecutionDateTime = DateTime.Now;
                        psicontext.BWExecutionLog.Update(agenOpsiDate);
                        psicontext.SaveChanges();
                    }

                }
                Log.Information($"successful insertion in bw SP_BI_BP_AGENT_SNS");
                //_agentOpsiRepository.AddBulk(bwTable.ToList());


            }
        }

        private void RunSLMAgentSNS()
        {
            using (var psicontext = new PSIDbContext())
            {

                var LMAgentSNSI = psicontext.SP_BI_LM_AGENT_SNSI.FromSqlRaw($"SP_BI_LM_Agent_SNS").ToList();
                Log.Information($"total record to insert SP_BI_LM_Agent_SNS {LMAgentSNSI.Count}");
                if (LMAgentSNSI.Any())
                {
                    var BILMAgentSNSI = LMAgentSNSI.Select(x => new BI_LM_AGENT_SNS
                    {
                        COMPANY = x.COMPANY,
                        PSI_CONS_CODE = x.PSI_CONS_CODE,
                        SALESOFFICE = x.SALESOFFICE,
                        REGION = x.REGION,
                        DEPARTMENT = x.DEPARTMENT,
                        COUNTRY = x.COUNTRY,
                        MGGROUP = x.MGGroup,
                        MG1 = x.MG1,
                        MG2 = x.MG2,
                        MG3 = x.MG3,
                        MG4 = x.MG4,
                        MG5 = x.MG5,
                        PSI_ITEM_CODE = x.PSI_ITEM_CODE,
                        PSI_YYYYMM = x.PSI_YYYYMM,
                        SALES_TYPE = x.SALES_TYPE,
                        LM_QTY = x.LM_QTY,
                        LM_AMT = x.LM_AMT,
                        CREATEDMONTH = x.CREATEDMONTH,
                        CREATEDON = DateTime.Now,
                        UPDATEDON = DateTime.Now
                    });

                    using (var context = new BWDbConext())
                    {


                        UpdateInsertBI_LM_Agent_SNS(context, BILMAgentSNSI.ToList());

                        var agenOpsiDate = psicontext.BWExecutionLog.FirstOrDefault(x => x.Process == "BI_LM_Agent_SNS");
                        agenOpsiDate.LastExecutionDateTime = DateTime.Now;
                        psicontext.BWExecutionLog.Update(agenOpsiDate);
                        psicontext.SaveChanges();

                    }
                    //_agentOpsiRepository.AddBulk(bwTable.ToList());

                }
                Log.Information($"successful insertion in bw SP_BI_LM_AGENT_SNS");

            }


        }
        private void UpdateInsertBI_BP_AGENT_OPSI(BWDbConext context, List<BI_BP_AGENT_OPSI> Data)
        {
            Log.Information($"BI_BP_AGENT_OPSI :Total record to insert {Data.Count}");
            var existingData = context.BI_BP_AGENT_OPSI.ToList();
            var recordToUpdate = existingData.Where(x => Data.Any(y => x.PSI_YYYYMM == y.PSI_YYYYMM && x.PSI_CONS_CODE == y.PSI_CONS_CODE &&
                                            x.PSI_ITEM_CODE == y.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)).ToList();

            var recordToInsert = Data.Where(x => !existingData.Any(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                    y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)).ToList();

            recordToUpdate.ForEach(x =>
            {
                x.BP_P_QTY = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.BP_P_QTY;
                x.BP_P_AMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.BP_P_AMT;
                x.BP_P_AMT_USD = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.BP_P_AMT_USD;

                x.BP_S_QTY = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.BP_S_QTY;
                x.BP_S_AMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.BP_S_AMT;
                x.BP_S_AMT_USD = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.BP_S_AMT_USD;

                x.BP_I_QTY = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                     y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.BP_I_QTY;
                x.BP_I_AMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.BP_I_AMT;
                x.BP_I_AMT_USD = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.BP_I_AMT_USD;

                x.BP_O_QTY = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                     y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.BP_O_QTY;
                x.BP_O_AMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.BP_O_AMT;
                x.BP_O_AMT_USD = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.BP_O_AMT_USD;
                x.UPDATEDON = DateTime.Now;
            });
            context.BulkUpdate(recordToUpdate.ToList());
            Log.Information($"BI_BP_AGENT_OPSI :Update record  {recordToUpdate.Count}");
            context.BulkInsert(recordToInsert);
            Log.Information($"BI_BP_AGENT_OPSI :inserted record  {recordToInsert.Count}");
            context.SaveChanges();


        }
        private void UpdateInsertBI_Forecast_AGENT_SNS_SALES(BWDbConext context, List<BI_FCS_AGENT_SNS_SALES> Data)
        {
            var existingData = context.BI_FCS_AGENT_SNS_SALES.ToList();
            var recordToUpdate = existingData.Where(x => Data.Any(y => x.PSI_YYYYMM == y.PSI_YYYYMM && x.PSI_CONS_CODE == y.PSI_CONS_CODE &&
                                            x.PSI_ITEM_CODE == y.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)).ToList();




            var recordToInsert = Data.Where(x => !existingData.Any(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                    y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)).ToList();

            recordToUpdate.ForEach(x =>
            {
                x.CURRENT_PLAN_QTY = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.CURRENT_PLAN_QTY;
                x.CURRENT_COSTAMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.CURRENT_COSTAMT;
                x.CURRENT_GPAMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.CURRENT_GPAMT;

                x.CURRENT_PLANAMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.CURRENT_PLANAMT;

                x.CURRENT_SALES_AMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.CURRENT_SALES_AMT;
                x.CURRENT_SALES_QTY = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.CURRENT_SALES_QTY;

                x.CURRENT_SALES_GPAMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                     y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.CURRENT_SALES_GPAMT;
                x.LY_PLAN_QTY = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LY_PLAN_QTY;
                x.LY_SALES_AMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LY_SALES_AMT;

                x.LY_COSTAMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                     y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LY_COSTAMT;
                x.LY_GPAMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LY_GPAMT;
                x.LY_SALES_QTY = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LY_SALES_QTY;
                x.LY_SALES_GPAMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LY_SALES_GPAMT;
                x.LY_PLANAMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                     y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LY_PLANAMT;

                x.UPDATEDON = DateTime.Now;
            });
            context.BulkUpdate(recordToUpdate.ToList());
            Log.Information($"BI_Forecast_AGENT_SNS_SALES :Update record  {recordToUpdate.Count}");
            context.BulkInsert(recordToInsert);
            Log.Information($"BI_Forecast_AGENT_SNS_SALES :Update record  {recordToInsert.Count}");
            context.SaveChanges();


        }
        private void UpdateInsertBI_FORECAST_AGENT_OPSI(BWDbConext context, List<BI_FORECAST_AGENT_OPSI> Data)
        {
            var existingData = context.BI_FORECAST_AGENT_OPSI.ToList();
            var recordToUpdate = existingData.Where(x => Data.Any(y => x.PSI_YYYYMM == y.PSI_YYYYMM && x.PSI_CONS_CODE == y.PSI_CONS_CODE &&
                                            x.PSI_ITEM_CODE == y.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)).ToList();

            List<BI_FORECAST_AGENT_OPSI> recordToInsert = new List<BI_FORECAST_AGENT_OPSI>();
            if (existingData.Count > 0)
            {
                recordToInsert = Data.Where(x => !existingData.Any(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                                  y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)).ToList();
            }
            else
            {
                recordToInsert = Data;
            }
            recordToUpdate.ForEach(x =>
            {
                x.O_QTY = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.O_QTY;
                x.O_AMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.O_AMT;
                x.O_AMT_USD = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.O_AMT_USD;

                x.P_QTY = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.P_QTY;

                x.P_AMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.P_AMT;
                x.P_AMT_USD = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.P_AMT_USD;

                x.S_QTY = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                     y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.S_QTY;
                x.S_AMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.S_AMT;
                x.S_AMT_USD = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.S_AMT_USD;

                x.I_QTY = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                     y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.I_QTY;
                x.I_AMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.I_AMT;
                x.I_AMT_USD = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.I_AMT_USD;
                x.PSI_COST_AMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.PSI_COST_AMT;
                x.LY_O_QTY = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                     y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LY_O_QTY;
                x.LY_O_AMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                  y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LY_O_AMT;
                x.LY_P_QTY = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                  y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LY_P_QTY;
                x.LY_P_AMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                  y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LY_P_AMT;
                x.LY_S_QTY = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                  y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LY_S_QTY;
                x.LY_S_AMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                  y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LY_S_AMT;

                x.LY_I_QTY = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                  y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LY_I_QTY;

                x.LY_I_AMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                  y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LY_I_AMT;

                x.LY_O_AMT_USD = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LY_O_AMT_USD;

                x.LY_P_AMT_USD = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LY_P_AMT_USD;

                x.LY_S_AMT_USD = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LY_S_AMT_USD;

                x.LY_I_AMT_USD = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LY_I_AMT_USD;

                x.NXT_SALE_AMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.NXT_SALE_AMT;

                x.NXT_SALE_AMT_USD = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.NXT_SALE_AMT_USD;
                x.UPDATEDON = DateTime.Now;
            });
            context.BulkUpdate(recordToUpdate.ToList());
            Log.Information($"BI_FORECAST_AGENT_OPSI :Update record  {recordToUpdate.Count}");
            context.BulkInsert(recordToInsert);
            Log.Information($"BI_FORECAST_AGENT_OPSI :inserted record  {recordToInsert.Count}");
            context.SaveChanges();


        }
        private void UpdateInsertBI_LM_Agent_OPSI(BWDbConext context, List<BI_LM_AGENT_OPSI> Data)
        {
            var existingData = context.BI_LM_AGENT_OPSI.ToList();
            var recordToUpdate = existingData.Where(x => Data.Any(y => x.PSI_YYYYMM == y.PSI_YYYYMM && x.PSI_CONS_CODE == y.PSI_CONS_CODE &&
                                            x.PSI_ITEM_CODE == y.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)).ToList();

            var recordToInsert = Data.Where(x => !existingData.Any(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                    y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)).ToList();

            recordToUpdate.ForEach(x =>
            {
                x.LM_P_QTY = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LM_P_QTY;
                x.LM_P_AMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LM_P_AMT;
                x.LM_P_AMT_USD = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LM_P_AMT_USD;

                x.LM_S_QTY = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LM_S_QTY;
                x.LM_S_AMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LM_S_AMT;
                x.LM_S_AMT_USD = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LM_S_AMT_USD;

                x.LM_I_QTY = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                     y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LM_I_QTY;
                x.LM_I_AMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LM_I_AMT;
                x.LM_I_AMT_USD = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LM_I_AMT_USD;

                x.LM_O_QTY = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                     y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LM_O_QTY;
                x.LM_O_AMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LM_O_AMT;
                x.LM_O_AMT_USD = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)?.LM_O_AMT_USD;
                x.UPDATEDON = DateTime.Now;
            });
            context.BulkUpdate(recordToUpdate.ToList());
            Log.Information($"BI_LM_Agent_OPSI :updated record  {recordToInsert.Count}");
            context.BulkInsert(recordToInsert);
            Log.Information($"BI_LM_Agent_OPSI :inserted record  {recordToInsert.Count}");
            context.SaveChanges();


        }
        private void UpdateInsertBI_LM_Agent_SNS(BWDbConext context, List<BI_LM_AGENT_SNS> Data)
        {
            var existingData = context.BI_LM_AGENT_SNS.ToList();
            var recordToUpdate = existingData.Where(x => Data.Any(y => x.PSI_YYYYMM == y.PSI_YYYYMM && x.PSI_CONS_CODE == y.PSI_CONS_CODE &&
                                            x.PSI_ITEM_CODE == y.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)).ToList();

            List<BI_LM_AGENT_SNS> recordToInsert = new List<BI_LM_AGENT_SNS>();
            if(existingData.Count>0)
            { 
             recordToInsert = Data.Where(x => existingData.Any(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                    y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && x.SALES_TYPE == y.SALES_TYPE)).ToList();
            }
            else
            {
                recordToInsert = Data;
            }

            recordToUpdate.ForEach(x =>
            {
                x.LM_QTY = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && y.SALES_TYPE == x.SALES_TYPE)?.LM_QTY;
                x.LM_AMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && y.SALES_TYPE == x.SALES_TYPE)?.LM_AMT;
                x.CREATEDMONTH = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && y.SALES_TYPE == x.SALES_TYPE)?.CREATEDMONTH;
                x.UPDATEDON = DateTime.Now;
            });
            context.BulkUpdate(recordToUpdate.ToList());
            Log.Information($"BI_LM_Agent_SNS :updated record  {recordToInsert.Count}");
            context.BulkInsert(recordToInsert);
            Log.Information($"BI_LM_Agent_SNS :inserted record  {recordToInsert.Count}");
            context.SaveChanges();


        }
        private void UpdateInsertBI_BP_AGENT_SNS(BWDbConext context, List<BI_BP_AGENT_SNS> Data)
        {
            var existingData = context.BI_BP_AGENT_SNS.ToList();
            var recordToUpdate = existingData.Where(x => Data.Any(y => x.PSI_YYYYMM == y.PSI_YYYYMM && x.PSI_CONS_CODE == y.PSI_CONS_CODE &&
                                            x.PSI_ITEM_CODE == y.PSI_ITEM_CODE && x.SALES_TYPE==y.SALES_TYPE)).ToList();
            List<BI_BP_AGENT_SNS> recordToInsert = new List<BI_BP_AGENT_SNS>();
             recordToInsert = Data.Where(x => existingData.Any(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                    y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && y.SALES_TYPE == x.SALES_TYPE)).ToList();

            
            if (existingData.Count > 0)
            {
                recordToInsert = Data.Where(x => existingData.Any(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                  y.PSI_ITEM_CODE == x.PSI_ITEM_CODE && y.SALES_TYPE == x.SALES_TYPE)).ToList();
            }
            else
            {

                recordToInsert = Data;
            }
            recordToUpdate.ForEach(x =>
            {
                x.BP_QTY = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE)?.BP_QTY;
                x.BP_AMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE)?.BP_AMT;
                x.BP_COST_AMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE)?.BP_COST_AMT;

                x.BP_GPAMT = Data.FirstOrDefault(y => y.PSI_YYYYMM == x.PSI_YYYYMM && y.PSI_CONS_CODE == x.PSI_CONS_CODE &&
                      y.PSI_ITEM_CODE == x.PSI_ITEM_CODE)?.BP_GPAMT;

                x.UPDATEDON = DateTime.Now;
            });
            context.BulkUpdate(recordToUpdate.ToList());
            Log.Information($"BI_BP_AGENT_SNS :updated record  {recordToInsert.Count}");
            context.BulkInsert(recordToInsert);
            Log.Information($"BI_BP_AGENT_SNS :updated record  {recordToInsert.Count}");
            context.SaveChanges();


        }




    }
}
