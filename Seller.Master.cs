using System;
using System.Web;
using System.Web.Security;
using System.Web.UI.WebControls;

namespace CncAgro
{
    public partial class Seller : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!HttpContext.Current.User.Identity.IsAuthenticated | Session["RegistrationID"] == null)
            {
                Roles.DeleteCookie();
                Session.Clear();
                FormsAuthentication.SignOut();
                Response.Redirect("~/Login.aspx");
            }
        }
        protected void LoginStatus1_LoggingOut(object sender, LoginCancelEventArgs e)
        {
            Roles.DeleteCookie();
            Session.Clear();
            FormsAuthentication.SignOut();
        }
    }
}