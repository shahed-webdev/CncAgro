using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Security;
using System.Web.UI.WebControls;

namespace CncAgro.AccessAdmin.Sub_Admin
{
    public partial class SignUp : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void SubAdmin_CreatedUser(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());

            Roles.AddUserToRole(SubAdminCW.UserName, "Sub-Admin");

            SqlDataSource RegistrationSQL = (SqlDataSource)SubAdminCW.CreateUserStep.ContentTemplateContainer.FindControl("RegistrationSQL");
            RegistrationSQL.Insert();

            SqlCommand RegistrationID_Cmd = new SqlCommand("Select IDENT_CURRENT('Registration')", con);

            con.Open();
            ViewState["RegistrationID"] = RegistrationID_Cmd.ExecuteScalar();
            con.Close();

            UserLoginSQL.InsertParameters["UserName"].DefaultValue = SubAdminCW.UserName;
            UserLoginSQL.InsertParameters["Password"].DefaultValue = SubAdminCW.Password;
            UserLoginSQL.InsertParameters["Email"].DefaultValue = SubAdminCW.Email;
            UserLoginSQL.Insert();

            SubAdminCW.ActiveStepIndex = 1;
        }

        protected void LinkAssignButton_Click(object sender, EventArgs e)
        {
            foreach (GridViewRow row in LinkGridView.Rows)
            {
                CheckBox LinkCheckbox = row.FindControl("LinkCheckBox") as CheckBox;
                if (LinkCheckbox.Checked)
                {
                    if (Roles.RoleExists(LinkGridView.DataKeys[row.DataItemIndex]["RoleName"].ToString()))
                    {
                        if (!Roles.IsUserInRole(SubAdminCW.UserName, LinkGridView.DataKeys[row.DataItemIndex]["RoleName"].ToString()))
                        {
                            Roles.AddUserToRole(SubAdminCW.UserName, LinkGridView.DataKeys[row.DataItemIndex]["RoleName"].ToString());
                        }
                    }

                    Link_UserSQL.InsertParameters["RegistrationID"].DefaultValue = ViewState["RegistrationID"].ToString();
                    Link_UserSQL.InsertParameters["LinkID"].DefaultValue = LinkGridView.DataKeys[row.DataItemIndex]["LinkID"].ToString();
                    Link_UserSQL.InsertParameters["UserName"].DefaultValue = SubAdminCW.UserName;
                    Link_UserSQL.Insert();

                    SubAdminCW.ActiveStepIndex = 2;
                }
            }
        }

        protected void LinkGridView_DataBound(object sender, EventArgs e)
        {
            int RowSpan = 2;
            for (int i = LinkGridView.Rows.Count - 2; i >= 0; i--)
            {
                GridViewRow currRow = LinkGridView.Rows[i];
                GridViewRow prevRow = LinkGridView.Rows[i + 1];

                if (currRow.Cells[0].Text == prevRow.Cells[0].Text && currRow.Cells[1].Text == prevRow.Cells[1].Text)
                {
                    currRow.Cells[0].RowSpan = RowSpan;
                    prevRow.Cells[0].Visible = false;

                    currRow.Cells[1].RowSpan = RowSpan;
                    prevRow.Cells[1].Visible = false;
                    RowSpan += 1;
                }
                else
                    RowSpan = 2;

            }
        }
    }
}