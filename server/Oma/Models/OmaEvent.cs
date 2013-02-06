using System;

namespace Oma.Models
{
    public class OmaEvent
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public DateTimeOffset Date { get; set; }
        public OmaWhen When { get; set; }
    }
}