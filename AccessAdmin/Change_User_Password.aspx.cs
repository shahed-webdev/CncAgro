using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CncAgro.AccessAdmin
{
    public partial class Change_User_Password : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
                Response.Redirect("~/Profile_Redirect.aspx");

            if (string.IsNullOrEmpty(Request.QueryString["reg"]))
                Response.Redirect("~/Profile_Redirect.aspx");
        }
        public void ChangePassword_OnClick(object sender, EventArgs args)
        {
            string userName = UserInfoFormView.DataKey["UserName"].ToString();
            MembershipUser User = Membership.GetUser(userName); 

            try
            {
                if (User.ChangePassword(UserInfoFormView.DataKey["Password"].ToString(), PasswordTextbox.Text.Trim()))
                {
                    Msg.Text = "Password changed Successfully";

                    User_Login_InfoSQL.UpdateParameters["Password"].DefaultValue = PasswordTextbox.Text.Trim();
                    User_Login_InfoSQL.UpdateParameters["UserName"].DefaultValue = userName;
                    User_Login_InfoSQL.Update();
                }
                else
                {
                    Msg.Text = "Password change failed. Please re-enter your values and try again.";
                }
            }
            catch (Exception e)
            {
                Msg.Text = "An exception occurred: " + Server.HtmlEncode(e.Message) + ". Please re-enter your values and try again.";
            }
        }
    }
}