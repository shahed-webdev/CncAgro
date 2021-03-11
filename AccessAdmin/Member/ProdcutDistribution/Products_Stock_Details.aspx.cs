using System;

namespace CncAgro.AccessAdmin.Member.ProductDistribution
{
    public partial class Products_Stock_Details : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
                Response.Redirect("~/Profile_Redirect.aspx");

            if (string.IsNullOrEmpty(Request.QueryString["d"]))
                Response.Redirect("OrderedMemberList.aspx");
        }
    }
}