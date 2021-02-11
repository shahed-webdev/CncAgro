using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CncAgro.AccessSeller
{
    public partial class Change_Password : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void ChangePassword1_ChangedPassword(object sender, EventArgs e)
        {
            User_Login_InfoSQL.UpdateParameters["Password"].DefaultValue = ChangePassword.NewPassword;
            User_Login_InfoSQL.UpdateParameters["UserName"].DefaultValue = User.Identity.Name;
            User_Login_InfoSQL.Update();
        }
    }
}