//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Books
{
    using System;
    using System.Collections.Generic;
    
    public partial class issued
    {
        public int id_issue { get; set; }
        public Nullable<System.DateTime> issue_date { get; set; }
        public Nullable<System.DateTime> return_date { get; set; }
        public Nullable<System.DateTime> real_return_date { get; set; }
        public int id_book { get; set; }
        public int id_reader { get; set; }
    
        public virtual book book { get; set; }
        public virtual reader reader { get; set; }
    }
}
