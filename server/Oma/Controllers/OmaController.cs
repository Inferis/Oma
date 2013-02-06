using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.Mvc;
using Oma.Models;
using Raven.Client;

namespace Oma.Controllers
{
    public class OmaController : Controller
    {
        protected IDocumentSession RavenSession { get; set; }

        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            RavenSession = MvcApplication.Store.OpenSession();
            base.OnActionExecuting(filterContext);

        }

        protected override void OnActionExecuted(ActionExecutedContext filterContext)
        {
            base.OnActionExecuted(filterContext);

            using (RavenSession) {
                if (filterContext.Exception != null)
                    return;

                if (RavenSession != null)
                    RavenSession.SaveChanges();
            }
        }

        public ActionResult FutureEvents()
        {
            dynamic events;
            Thread.Sleep(1000);
            using (var session = MvcApplication.Store.OpenSession()) {
                events = session.Query<OmaEvent_ByDate.Result, OmaEvent_ByDate>()
                    .Where(x => x.DateTime >= DateTime.Now)
                    .OrderBy(x => x.Date)
                    .ToList()
                    .Select(x => new {
                                    x.Date,
                                    Who = x.Who.OrderBy(w => w.When).Select(w => new {
                                        w.Date,
                                        w.Name, 
                                        w.When,
                                        w.Id
                                    })
                                })
                    .ToList();
            }

            return Json(events, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public ActionResult Add(string date, string name, OmaWhen when)
        {
            var entry = new OmaEvent() {
                Date = DateTime.ParseExact(date, "yyyyMMdd", CultureInfo.InvariantCulture),
                Name = name,
                When = when
            };

            // delete all old
            foreach (var e in RavenSession.Query<OmaEvent>().Where(x => x.Date == entry.Date)) {
                RavenSession.Delete(e);
            }

            RavenSession.Store(entry);
            RavenSession.SaveChanges();

            return Json(entry);
        }

        [HttpPost]
        public ActionResult Edit(string id, string date, OmaWhen when)
        {
            var entry = RavenSession.Load<OmaEvent>(id);
            if (entry == null)
                throw new KeyNotFoundException();

            entry.Date = DateTime.ParseExact(date, "yyyyMMdd", CultureInfo.InvariantCulture);
            entry.When = when;
            RavenSession.Store(entry);
            RavenSession.SaveChanges();

            return Json(entry);
        }


        [HttpPost]
        public ActionResult Delete(string id)
        {
            var entry = RavenSession.Load<OmaEvent>(id);
            if (entry != null)
                RavenSession.Delete(entry);

            return Json(id);
        }
    }
}
