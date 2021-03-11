using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;

namespace CncAgro.AccessMember
{
    public partial class Withdraw_Balance : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Withdraw_Button_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());

            string Phone = ABFormView.DataKey["Phone"].ToString();
            string Num = GetRandomNumbers(6);
            double Available_Balance = Convert.ToDouble(ABFormView.DataKey["Available_Balance"]);
            double withdraw_Balance = Convert.ToDouble(Amount_TextBox.Text.Trim());

            SqlCommand Withdrcmd = new SqlCommand("SELECT ISNULL(SUM(Amount),0) FROM Fund_Withdraw_Code WHERE(Withdraw_RegistrationID = @RegistrationID) AND(IS_Used = 0)", con);
            Withdrcmd.Parameters.AddWithValue("@RegistrationID", Session["RegistrationID"].ToString());

            con.Open();
            double Withdraw_Request = Convert.ToDouble(Withdrcmd.ExecuteScalar());
            con.Close();
            if (withdraw_Balance >= 500)
            {
                if ((withdraw_Balance + Withdraw_Request) <= Available_Balance)
                {
                    W_Code_SQL.InsertParameters["Transition_Code"].DefaultValue = Num;
                    W_Code_SQL.Insert();

                    SMS_Class SMS = new SMS_Class();
                    int TotalSMS = 0;
                    int SMSBalance = SMS.SMSBalance;
                    string Msg = "Your withdrawal verification code is: " + Num + ". Provide this code to administration for receive balance. CNC Agro";

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
                                SMS_OtherInfoSQL.Insert();
                            }
                        }
                    }

                    Response.Redirect("Withdraw_Details.aspx");
                }
                else
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Withdraw amount grater than Available Balance and requested amount')", true);
                }

            }
            else
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Withdraw amount must be minimum 500 TK')", true);
            }
        }
        protected void ABFormView_DataBound(object sender, EventArgs e)
        {
            double Available_Balance = Convert.ToDouble(ABFormView.DataKey["Available_Balance"]);

            if (Available_Balance <= 0)
            {
                Amount_TextBox.Enabled = false;
                Withdraw_Button.Enabled = false;
            }
            else
            {
                Amount_TextBox.Enabled = true;
                Withdraw_Button.Enabled = true;
            }
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
    }
}