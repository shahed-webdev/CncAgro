using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Security;

namespace CncAgro
{
    public partial class Profile_Redirect : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());

            if (!User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                Response.Redirect("~/Login.aspx?Invalid=Connection timeout");
            }

            if (Roles.IsUserInRole(User.Identity.Name, "Authority"))
                Response.Redirect("~/Access_Authority/Profile.aspx");

            if (Roles.IsUserInRole(User.Identity.Name, "Admin"))
                Response.Redirect("~/AccessAdmin/Admin_Profile.aspx");

            if (Roles.IsUserInRole(User.Identity.Name, "Sub-Admin"))
                Response.Redirect("~/AccessAdmin/Admin_Profile.aspx");

            if (Roles.IsUserInRole(User.Identity.Name, "Member"))
                Response.Redirect("~/AccessMember/MemberProfile.aspx");

            //if (Roles.IsUserInRole(User.Identity.Name, "Seller"))
            //    Response.Redirect("~/AccessSeller/Seller_Profile.aspx");

        }
    }
}