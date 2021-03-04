using System;

namespace CncAgro.AccessAdmin.Seller
{
    public partial class Seller_Products_Stock_Details : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
                Response.Redirect("~/Profile_Redirect.aspx");

            if (string.IsNullOrEmpty(Request.QueryString["d"]))
                Response.Redirect("Seller_List.aspx");
        }
    }
}