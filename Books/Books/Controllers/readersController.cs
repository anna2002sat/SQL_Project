using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using Books;

namespace Books.Controllers
{
    public class readersController : Controller
    {
        private booksEntities1 db = new booksEntities1();

        // GET: readers
        public ActionResult Index()
        {
            return View(db.readers.ToList());
        }

        // GET: readers/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            reader reader = db.readers.Find(id);
            if (reader == null)
            {
                return HttpNotFound();
            }
            return View(reader);
        }

        // GET: readers/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: readers/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "ticket_number,name_reader,surName_reader,address_reader,mark_disposal,PhoneNum")] reader reader)
        {
            if (ModelState.IsValid)
            {
                db.readers.Add(reader);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(reader);
        }

        // GET: readers/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            reader reader = db.readers.Find(id);
            if (reader == null)
            {
                return HttpNotFound();
            }
            return View(reader);
        }

        // POST: readers/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "ticket_number,name_reader,surName_reader,address_reader,mark_disposal,PhoneNum")] reader reader)
        {
            if (ModelState.IsValid)
            {
                db.Entry(reader).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(reader);
        }

        // GET: readers/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            reader reader = db.readers.Find(id);
            if (reader == null)
            {
                return HttpNotFound();
            }
            return View(reader);
        }

        // POST: readers/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            reader reader = db.readers.Find(id);
            db.readers.Remove(reader);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
