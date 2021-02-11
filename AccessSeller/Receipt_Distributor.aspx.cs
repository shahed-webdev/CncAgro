using System;

namespace CncAgro.AccessSeller
{
    public partial class Receipt_Distributor : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(Request.QueryString["DistributorShoppingID"]))
            {
                Response.Redirect("Sell_Product_Distributor.aspx");
            }
        }
    }
}