using System;

namespace CncAgro.AccessMember
{
    public partial class Added_Customer_Info : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(Request.QueryString["member"]))
            {
                Response.Redirect("Add_New_Member.aspx");
            }
        }
    }
}