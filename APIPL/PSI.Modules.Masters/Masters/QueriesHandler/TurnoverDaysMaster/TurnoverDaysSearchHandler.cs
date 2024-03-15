using Core.BaseUtility.TableSearchUtil;
using DevExtreme.AspNet.Data;
using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.TurnoverDaysMaster;
using PSI.Modules.Backends.Masters.Repository.AccountMaster;
using PSI.Modules.Backends.Masters.Repository.TurnoverDaysMaster;
using PSI.Modules.Backends.Masters.Results;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.QueriesHandler.TurnoverDaysMaster
{
    public class TurnoverDaysSearchHandler : IRequestHandler<TurnoverDaysSearchQuery, LoadResult>
    {
        private readonly ITurnoverDaysRepository _turnoverDaysRepository;
        private readonly IAccountRepository _accountRepository;
        public TurnoverDaysSearchHandler(ITurnoverDaysRepository turnoverDaysRepository,
            IAccountRepository accountRepository)
        {
            _turnoverDaysRepository = turnoverDaysRepository;
            _accountRepository = accountRepository;
        }
        public async Task<LoadResult> Handle(TurnoverDaysSearchQuery request, CancellationToken cancellationToken)
        {
            var accounts = _accountRepository.GetAll();
            var data = _turnoverDaysRepository.GetAll();
            var turnoverDaysResult = data.Select(x => new TurnoverDaysResult
            {
                SubgroupCode = x.SubGroupProductCategoryCode,
                Month = x.Month,
                TurnoverDay = x.TurnoverDay,
                BPYear = x.BP_Year,
                GitDays = x.Git_Year,
                OACCode = x.AccountId == null ? null : accounts.FirstOrDefault(z=>z.AccountId== x.AccountId).AccountCode,
            });
            var result = DataSourceLoader.Load(turnoverDaysResult, request.LoadOptions);
            return await Task.FromResult(result);
        }
    }
}
