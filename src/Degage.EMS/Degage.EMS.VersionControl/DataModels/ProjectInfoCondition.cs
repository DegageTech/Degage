﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Degage.EMS.VersionControl
{
    public class ProjectInfoCondition:PageCondition
    {
        public DateTime? LastAccessTimeStart { get; set; }
        public DateTime? LastAccessTimeEnd { get; set; }
        public Boolean IsRemoved { get; set; } = false;
    }
}
