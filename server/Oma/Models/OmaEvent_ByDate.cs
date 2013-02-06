using System;
using System.Globalization;
using System.Linq;
using Raven.Client.Indexes;

namespace Oma.Models
{
    public class OmaEvent_ByDate : AbstractIndexCreationTask<OmaEvent, OmaEvent_ByDate.Result>
    {
        public class Result
        {
            public string Date { get; set; }
            public DateTime DateTime { get; set; }
            public Attendance[] Who { get; set; }

            public class Attendance
            {
                public string Date { get; set; }
                public string Id { get; set; }
                public string Name { get; set; }
                public OmaWhen When { get; set; }
            }
        }

        public OmaEvent_ByDate()
        {
            Map = events => from e in events
                            select new {
                                Date = e.Date.ToString("yyyyMMdd"),
                                DateTime = e.Date,
                                Who = new object[] { new { Date = e.Date.ToString("yyyyMMdd"), e.Id, e.Name, e.When } }
                            };

            Reduce = events => from e in events
                               group e by e.Date into dates
                               select new {
                                   Date = dates.Key,
                                   dates.First().DateTime,
                                   Who = dates.Select(x => x.Who)
                               };
        }
    }
}