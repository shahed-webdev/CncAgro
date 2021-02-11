using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;

namespace CncAgro.AccessAdmin.Accounts
{
    public partial class Withdraw_Balance : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void SendCode_Button_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());

            if (M_detailsFormView.DataItemCount > 0)
            {
                string Phone = M_detailsFormView.DataKey["Phone"].ToString();
                string Num = GetRandomNumbers(6);

                double Available_Balance = Convert.ToDouble(M_detailsFormView.DataKey["Available_Balance"]);
                double withdraw_Balance = Convert.ToDouble(WithdrawAmountTextBox.Text.Trim());

                SqlCommand Withdrcmd = new SqlCommand("SELECT ISNULL(SUM(Amount),0) FROM Fund_Withdraw_Code WHERE(Withdraw_RegistrationID = @RegistrationID) AND(IS_Used = 0)", con);
                Withdrcmd.Parameters.AddWithValue("@RegistrationID", Session["RegistrationID"].ToString());

                con.Open();
                double Withdraw_Request = Convert.ToDouble(Withdrcmd.ExecuteScalar());
                con.Close();

                if ((withdraw_Balance + Withdraw_Request) <= Available_Balance)
                {
                    W_Code_SQL.InsertParameters["Transition_Code"].DefaultValue = Num;
                    W_Code_SQL.InsertParameters["Withdraw_RegistrationID"].DefaultValue = M_detailsFormView.DataKey["RegistrationID"].ToString();
                    W_Code_SQL.Insert();

                    SMS_Class SMS = new SMS_Class();
                    int TotalSMS = 0;
                    int SMSBalance = SMS.SMSBalance;
                    string Msg = "Your withdrawal verification code is: " + Num + ". CNC Agro";

                    TotalSMS = SMS.SMS_Conut(Msg);

                    if (SMSBalance >= TotalSMS)
                    {
                        if (SMS.SMS_GetBalance() >= TotalSMS)
                        {
                            Get_Validation IsValid = SMS.SMS_Validation(Phone, Msg);
                            if (IsValid.Validation)
                            {
                                Guid SMS_Send_ID = SMS.SMS_Send(Phone, Msg, "Withdraw Balance");

                                SMS_OtherInfoSQL.InsertParameters["SMS_Send_ID"].DefaultValue = SMS_Send_ID.ToString();
                                SMS_OtherInfoSQL.InsertParameters["SMS_NumberID"].DefaultValue = M_detailsFormView.DataKey["RegistrationID"].ToString();
                                SMS_OtherInfoSQL.Insert();
                            }
                        }
                    }

                    Response.Redirect("Withdraw_Receipt.aspx");
                }
                else
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Withdraw amount grater than Available Balance and requested amount')", true);
                }
            }
            else
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Enter UserID')", true);
        }

        public string GetRandomNumbers(int length)
        {
            List<string> randomNumbers = new List<string>();

            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "SELECT Transition_Code FROM  Fund_Withdraw_Code WHERE  (IS_Used = 0)";

                    cmd.Connection = conn;
                    conn.Open();
                    using (SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        while (sdr.Read())
                        {
                            randomNumbers.Add(sdr["Transition_Code"].ToString());
                        }
                    }
                    conn.Close();
                }
            }

            const string valid = "1234567890";
            StringBuilder res = new StringBuilder();
            Random rnd = new Random();
            string number = "";

            do
            {
                while (0 < length--)
                {
                    res.Append(valid[rnd.Next(valid.Length)]);
                }
                number = res.ToString();


            } while (randomNumbers.Contains(number));

            return number;
        }

        protected void FIndButton_Click(object sender, EventArgs e)
        {
            if (UserIDTextBox.Text.Trim() == "")
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Enter UserID')", true);
            }
        }

        [WebMethod]
        public static string Get_User(string prefix)
        {
            List<string> User = new List<string>();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "SELECT top(2) UserName FROM Registration WHERE Category IN ('Member','Seller') AND RegistrationID <> @RegistrationID AND UserName LIKE @UserName + '%'";
                    cmd.Parameters.AddWithValue("@UserName", prefix);
                    cmd.Parameters.AddWithValue("@RegistrationID", HttpContext.Current.Session["RegistrationID"].ToString());
                    cmd.Connection = con;

                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    while (dr.Read())
                    {
                        User.Add(dr["UserName"].ToString());
                    }
                    con.Close();

                    var json = new JavaScriptSerializer().Serialize(User);
                    return json;
                }
            }
        }

        protected void M_detailsFormView_DataBound(object sender, EventArgs e)
        {
            double Available_Balance = Convert.ToDouble(M_detailsFormView.DataKey["Available_Balance"]);

            if (Available_Balance <= 0)
            {
                WithdrawAmountTextBox.Enabled = false;
                SendCode_Button.Enabled = false;
                ErorLabel.Text = "Balance Not Available";
            }
            else
            {
                WithdrawAmountTextBox.Enabled = true;
                SendCode_Button.Enabled = true;
                ErorLabel.Text = "";
            }
        }
    }
}