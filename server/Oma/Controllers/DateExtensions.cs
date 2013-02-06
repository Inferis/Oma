using System;

namespace Oma.Controllers
{
    public static class DateExtensions
    {
        public static DateTimeOffset FromUnixTime(this long unixTime)
        {
            var epoch = new DateTimeOffset(1970, 1, 1, 0, 0, 0, DateTimeOffset.Now.Offset);
            return epoch.AddSeconds(unixTime);
        }

        public static long ToUnixTime(this DateTimeOffset date)
        {
            var epoch = new DateTimeOffset(1970, 1, 1, 0, 0, 0, DateTimeOffset.Now.Offset);
            return Convert.ToInt64((date - epoch).TotalSeconds);
        }
    }
}