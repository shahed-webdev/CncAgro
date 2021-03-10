using System;

namespace CncAgro.AccessMember.Selling
{
    public partial class Receipt : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(Request.QueryString["ShoppingID"]))
            {
                Response.Redirect("Order_Record.aspx");
            }
        }
    }
}