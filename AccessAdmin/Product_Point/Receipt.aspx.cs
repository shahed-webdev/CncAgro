using System;

namespace CncAgro.AccessAdmin.Product_Point
{
    public partial class Receipt : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(Request.QueryString["ShoppingID"]))
            {
                Response.Redirect("Sell_Product.aspx");
            }
        }
    }
}