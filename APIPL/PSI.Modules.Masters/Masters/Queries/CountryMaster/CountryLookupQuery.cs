﻿using MediatR;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Queries.CountryMaster
{
    public class CountryLookupQuery : IRequest<IEnumerable<Country>>
    {
    }
}
