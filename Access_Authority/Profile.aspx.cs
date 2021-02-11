using System;
using System.Web.Security;
using System.Web.UI.WebControls;

namespace CncAgro.Access_Authority
{
    public partial class Profile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                BindUserAccounts();
            }
        }

        private void BindUserAccounts()
        {
            UserAccounts.DataSource = Membership.GetAllUsers();
            UserAccounts.DataBind();
        }

        protected void DeleteLinkButton_Command(object sender, CommandEventArgs e)
        {
            Membership.DeleteUser(e.CommandArgument.ToString(), true);
            BindUserAccounts();
        }

        protected void UserAccounts_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            //if (User.Identity.Name != "")
            //{
            //    if (e.Row.Cells[1].Text == Membership.GetUser().ToString())
            //    {
            //        e.Row.Visible = false;
            //    }
            //}
        }
    }
}