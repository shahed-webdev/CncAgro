using System;

namespace CncAgro.AccessMember.Selling
{
    public partial class Order_Details : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(Request.QueryString["DistributionID"]))
            {
                Response.Redirect("Order_Record.aspx");
            }
        }
    }
}