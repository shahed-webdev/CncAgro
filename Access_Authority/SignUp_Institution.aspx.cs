using System;
using System.Web.Security;

namespace CncAgro.Access_Authority
{
    public partial class SignUp_Institution : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Create_User_CreatedUser(object sender, EventArgs e)
        {
            Roles.AddUserToRole(Create_User.UserName, "Admin");

            RegistrationSQL.InsertParameters["UserName"].DefaultValue = Create_User.UserName;
            RegistrationSQL.Insert();
            Create_User.ActiveStepIndex = 1;
        }
    }
}