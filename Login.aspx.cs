using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Security;

namespace CncAgro
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                try
                {
                    InvalidErrorLabel.Text = Request.QueryString["Invalid"];
                }
                catch { }
            }


            if (User.Identity.IsAuthenticated) //Is user loged in, user not able to run login page redirect to profile page
            {
                Response.Redirect("~/Profile_Redirect.aspx");
            }
        }

        protected void CustomerLogin_LoginError(object sender, EventArgs e)
        {

            MembershipUser usrInfo = Membership.GetUser(CustomerLogin.UserName);
            if (usrInfo != null)
            {
                if (usrInfo.IsLockedOut)
                {
                    CustomerLogin.FailureText = "Your account has been locked out because of too many invalid login attempts. Please contact the administrator to have your account unlocked.";
                }
                else if (!usrInfo.IsApproved)
                {
                    CustomerLogin.FailureText = "Your account has not been approved. You cannot login until an administrator has approved your account.";
                }
            }
            else
            {
                CustomerLogin.FailureText = "Your login attempt was not successful. Please try again.";
            }
        }

        protected void CustomerLogin_LoggedIn(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());

            if (Roles.IsUserInRole(CustomerLogin.UserName, "Authority")) //for Authority
            {
                SqlCommand RegistrationIDcmd = new SqlCommand("SELECT RegistrationID from Registration where UserName = @UserName", con);
                RegistrationIDcmd.Parameters.AddWithValue("@UserName", CustomerLogin.UserName);

                con.Open();
                Session["RegistrationID"] = RegistrationIDcmd.ExecuteScalar().ToString();
                con.Close();
            }

            if (Roles.IsUserInRole(CustomerLogin.UserName, "Admin")) //for Admin
            {
                SqlCommand InstitutionID_cmd = new SqlCommand("SELECT InstitutionID from Registration where UserName = @UserName", con);
                InstitutionID_cmd.Parameters.AddWithValue("@UserName", CustomerLogin.UserName);

                SqlCommand RegistrationIDcmd = new SqlCommand("SELECT RegistrationID from Registration where UserName = @UserName", con);
                RegistrationIDcmd.Parameters.AddWithValue("@UserName", CustomerLogin.UserName);

                con.Open();
                Session["InstitutionID"] = InstitutionID_cmd.ExecuteScalar().ToString();
                Session["RegistrationID"] = RegistrationIDcmd.ExecuteScalar().ToString();
                con.Close();
            }

            if (Roles.IsUserInRole(CustomerLogin.UserName, "Sub-Admin")) //for Sub-Admin
            {
                SqlCommand InstitutionID_cmd = new SqlCommand("SELECT InstitutionID from Registration where UserName = @UserName", con);
                InstitutionID_cmd.Parameters.AddWithValue("@UserName", CustomerLogin.UserName);

                SqlCommand RegistrationIDcmd = new SqlCommand("SELECT RegistrationID from Registration where UserName = @UserName", con);
                RegistrationIDcmd.Parameters.AddWithValue("@UserName", CustomerLogin.UserName);

                con.Open();
                Session["InstitutionID"] = InstitutionID_cmd.ExecuteScalar().ToString();
                Session["RegistrationID"] = RegistrationIDcmd.ExecuteScalar().ToString();
                con.Close();
            }

            if (Roles.IsUserInRole(CustomerLogin.UserName, "Seller")) //for Seller
            {
                SqlCommand InstitutionID_cmd = new SqlCommand("SELECT InstitutionID from Registration where UserName = @UserName", con);
                InstitutionID_cmd.Parameters.AddWithValue("@UserName", CustomerLogin.UserName);

                SqlCommand RegistrationIDcmd = new SqlCommand("SELECT RegistrationID from Registration where UserName = @UserName", con);
                RegistrationIDcmd.Parameters.AddWithValue("@UserName", CustomerLogin.UserName);

                SqlCommand SellerIDcmd = new SqlCommand("SELECT Seller.SellerID FROM  Registration INNER JOIN Seller ON Registration.RegistrationID = Seller.SellerRegistrationID WHERE (Registration.UserName = @UserName)", con);
                SellerIDcmd.Parameters.AddWithValue("@UserName", CustomerLogin.UserName);

                con.Open();
                Session["InstitutionID"] = InstitutionID_cmd.ExecuteScalar().ToString();
                Session["RegistrationID"] = RegistrationIDcmd.ExecuteScalar().ToString();
                Session["SellerID"] = SellerIDcmd.ExecuteScalar().ToString();
                con.Close();
            }

            if (Roles.IsUserInRole(CustomerLogin.UserName, "Member")) //for Member
            {
                SqlCommand InstitutionID_cmd = new SqlCommand("SELECT InstitutionID from Registration where UserName = @UserName", con);
                InstitutionID_cmd.Parameters.AddWithValue("@UserName", CustomerLogin.UserName);

                SqlCommand RegistrationIDcmd = new SqlCommand("SELECT RegistrationID from Registration where UserName = @UserName", con);
                RegistrationIDcmd.Parameters.AddWithValue("@UserName", CustomerLogin.UserName);


                SqlCommand MemberInfo_cmd = new SqlCommand("SELECT Member.Is_Identified,Member.MemberID FROM Member INNER JOIN  Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE (Registration.UserName = @UserName)", con);
                MemberInfo_cmd.Parameters.AddWithValue("@UserName", CustomerLogin.UserName);

                con.Open();
                Session["InstitutionID"] = InstitutionID_cmd.ExecuteScalar().ToString();
                Session["RegistrationID"] = RegistrationIDcmd.ExecuteScalar().ToString();


                SqlDataReader Member;
                Member = MemberInfo_cmd.ExecuteReader();

                while (Member.Read())
                {
                    Session["MemberID"] = Member["MemberID"].ToString();
                    Session["Is_Identified"] = Member["Is_Identified"].ToString();
                }
                con.Close();
            }
        }
    }
}