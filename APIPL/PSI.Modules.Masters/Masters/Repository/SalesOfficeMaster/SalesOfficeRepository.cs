﻿using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.SalesOfficeMaster
{
   public partial interface ISalesOfficeRepository:IBaseRepository<SalesOffice>
    {
    }
    public partial class SalesOfficeRepository:BaseRepository<SalesOffice>, ISalesOfficeRepository
    {
        public SalesOfficeRepository():base(new PSIDbContext()) { }
    }
}
