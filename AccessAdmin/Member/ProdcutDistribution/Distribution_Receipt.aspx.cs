using System;

namespace CncAgro.AccessAdmin.Member.ProductDistribution
{
    public partial class Distribution_Receipt : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (string.IsNullOrEmpty(Request.QueryString["Distribution"]))
            {
                Response.Redirect("Product_Distribution.aspx");
            }
        }
    }
}