using System;

namespace CncAgro.AccessSeller
{
    public partial class Buying_Details : System.Web.UI.Page
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