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
    
    public partial class reader
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public reader()
        {
            this.issueds = new HashSet<issued>();
        }
    
        public int ticket_number { get; set; }
        public string name_reader { get; set; }
        public string surName_reader { get; set; }
        public string address_reader { get; set; }
        public Nullable<int> mark_disposal { get; set; }
        public string PhoneNum { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<issued> issueds { get; set; }
    }
}
