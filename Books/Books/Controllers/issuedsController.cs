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
    public class issuedsController : Controller
    {
        private booksEntities1 db = new booksEntities1();

        // GET: issueds
        public ActionResult Index()
        {
            var issueds = db.issueds.Include(i => i.book).Include(i => i.reader);
            return View(issueds.ToList());
        }

        // GET: issueds/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            issued issued = db.issueds.Find(id);
            if (issued == null)
            {
                return HttpNotFound();
            }
            return View(issued);
        }

        // GET: issueds/Create
        public ActionResult Create()
        {
            ViewBag.id_book = new SelectList(db.books, "id_book", "nazva");
            ViewBag.id_reader = new SelectList(db.readers, "ticket_number", "name_reader");
            return View();
        }

        // POST: issueds/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "id_issue,issue_date,return_date,real_return_date,id_book,id_reader")] issued issued)
        {
            if (ModelState.IsValid)
            {
                db.issueds.Add(issued);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.id_book = new SelectList(db.books, "id_book", "nazva", issued.id_book);
            ViewBag.id_reader = new SelectList(db.readers, "ticket_number", "name_reader", issued.id_reader);
            return View(issued);
        }

        // GET: issueds/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            issued issued = db.issueds.Find(id);
            if (issued == null)
            {
                return HttpNotFound();
            }
            ViewBag.id_book = new SelectList(db.books, "id_book", "nazva", issued.id_book);
            ViewBag.id_reader = new SelectList(db.readers, "ticket_number", "name_reader", issued.id_reader);
            return View(issued);
        }

        // POST: issueds/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "id_issue,issue_date,return_date,real_return_date,id_book,id_reader")] issued issued)
        {
            if (ModelState.IsValid)
            {
                db.Entry(issued).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.id_book = new SelectList(db.books, "id_book", "nazva", issued.id_book);
            ViewBag.id_reader = new SelectList(db.readers, "ticket_number", "name_reader", issued.id_reader);
            return View(issued);
        }

        // GET: issueds/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            issued issued = db.issueds.Find(id);
            if (issued == null)
            {
                return HttpNotFound();
            }
            return View(issued);
        }

        // POST: issueds/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            issued issued = db.issueds.Find(id);
            db.issueds.Remove(issued);
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
