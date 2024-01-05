using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Books.Controllers
{
    public class HomeController : Controller
    {
        private booksEntities1 db = new booksEntities1();
        public ActionResult Index()
        {
            ViewBag.MaxAmountOfCopies_Result = db.MaxAmountOfCopies();
            ViewBag.HAS_MORE_100_Result = db.HAS_MORE_100();
            ViewBag.TotalPrices = db.TotalPrices;

            return View();
        }
    }
}