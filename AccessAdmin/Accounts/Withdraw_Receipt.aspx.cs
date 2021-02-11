using System;
using System.Configuration;
using System.Data.SqlClient;

namespace CncAgro.AccessAdmin.Accounts
{
    public partial class Withdraw_Receipt : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Verify_Button_Click(object sender, EventArgs e)
        {
            int Withdraw_CodeID = 0;
            int Withdraw_RegistrationID = 0;
            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "EXEC Add_Admin_Withdroaw_Show @Transition_Code";
                    cmd.Parameters.AddWithValue("@Transition_Code", Code_TextBox.Text.Trim());

                    cmd.Connection = conn;
                    conn.Open();

                    using (SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        while (sdr.Read())
                        {
                            Withdraw_CodeID = Convert.ToInt32(sdr["Withdraw_CodeID"]);
                            Withdraw_RegistrationID = Convert.ToInt32(sdr["Withdraw_RegistrationID"]);
                        }
                    }
                    conn.Close();
                }
            }

            if (Withdraw_RegistrationID != 0)
            {
                Response.Redirect("Withdraw_Receipt.aspx?Withdraw_CodeID=" + Withdraw_CodeID.ToString() + "&Code=" + Code_TextBox.Text.Trim());
            }
            else
            {
                InvalidUserLabel.Text = "Invalid Code";
            }
        }

        protected void Withdraw_Button_Click(object sender, EventArgs e)
        {
            double Withdraw_Amount = 0;
            int Withdraw_RegistrationID = 0;
            int Withdraw_CodeID = 0;
            double Available_Balance = 0;

            if (!string.IsNullOrEmpty(Request.QueryString["Code"].ToString()))
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    conn.ConnectionString = ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = "EXEC Add_Admin_Withdroaw_Show @Transition_Code";
                        cmd.Parameters.AddWithValue("@Transition_Code", Request.QueryString["Code"].ToString());

                        cmd.Connection = conn;
                        conn.Open();

                        using (SqlDataReader sdr = cmd.ExecuteReader())
                        {
                            while (sdr.Read())
                            {
                                Withdraw_Amount = Convert.ToDouble(sdr["Amount"]);
                                Withdraw_RegistrationID = Convert.ToInt32(sdr["Withdraw_RegistrationID"]);
                                Withdraw_CodeID = Convert.ToInt32(sdr["Withdraw_CodeID"]);
                                Available_Balance = Convert.ToDouble(sdr["Available_Balance"]);
                            }
                        }
                        conn.Close();
                    }
                }


                if (Withdraw_RegistrationID != 0)
                {
                    if (Withdraw_Amount <= Available_Balance)
                    {
                        Fund_WithdrawSQL.InsertParameters["Withdraw_CodeID"].DefaultValue = Withdraw_CodeID.ToString();
                        Fund_WithdrawSQL.Insert();

                        Fund_WithdrawSQL.UpdateParameters["Withdraw_CodeID"].DefaultValue = Withdraw_CodeID.ToString();
                        Fund_WithdrawSQL.Update();

                        Code_TextBox.Text = "";
                        InvalidUserLabel.Text = "";

                        Response.Redirect("Requested_Withdraw_List.aspx");
                    }
                    else
                    {
                        InvalidUserLabel.Text = "Withdraw amount grater than Available Balance";
                    }
                }
                else { InvalidUserLabel.Text = "Invalid Code"; }
            }
        }
    }
}