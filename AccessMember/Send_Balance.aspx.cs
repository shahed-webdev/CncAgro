using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;

namespace CncAgro.AccessMember
{
    public partial class Send_Balance : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ABFormView_DataBound(object sender, EventArgs e)
        {
            double Available_Balance = Convert.ToDouble(ABFormView.DataKey["Available_Balance"]);

            if (Available_Balance <= 0)
            {
                MemberUserNameTextBox.Enabled = false;
                Send_Amount_TextBox.Enabled = false;
                Send_Button.Enabled = false;
            }
            else
            {
                MemberUserNameTextBox.Enabled = true;
                Send_Amount_TextBox.Enabled = true;
                Send_Button.Enabled = true;
            }
        }

        [WebMethod]
        public static string GetCustomers(string prefix)
        {
            List<Member> User = new List<Member>();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "SELECT top(4) UserName, Name, Phone, RegistrationID,Category FROM Registration WHERE RegistrationID <> @RegistrationID AND Category IN('Member','Seller') AND UserName LIKE @UserName + '%'";
                    cmd.Parameters.AddWithValue("@UserName", prefix);
                    cmd.Parameters.AddWithValue("@RegistrationID", HttpContext.Current.Session["RegistrationID"].ToString());
                    cmd.Connection = con;

                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    while (dr.Read())
                    {
                        User.Add(new Member
                        {
                            Username = dr["UserName"].ToString(),
                            Name = dr["Name"].ToString(),
                            Phone = dr["Phone"].ToString(),
                            RegID = dr["RegistrationID"].ToString(),
                            Category = dr["Category"].ToString()
                        });
                    }
                    con.Close();

                    var json = new JavaScriptSerializer().Serialize(User);
                    return json;
                }
            }
        }
        class Member
        {
            public string Username { get; set; }
            public string Name { get; set; }
            public string Phone { get; set; }
            public string RegID { get; set; }
            public string Category { get; set; }
        }
        //Code Send
        protected void Send_Button_Click(object sender, EventArgs e)
        {
            string Phone = ABFormView.DataKey["Phone"].ToString();
            string Code = GetRandomNumbers(6);
            string sms = "Your balance transfer verification code is: " + Code + ". Without transaction purpose don't share this code anyone. DNB SUPERSHOP";

            T_Code_SQL.InsertParameters["Transition_Code"].DefaultValue = Code;
            T_Code_SQL.Insert();

            Send_SMS(Phone, sms, "Transfer Balance");

            ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openModal();", true);
        }

        //Verify
        protected void Verify_Button_Click(object sender, EventArgs e)
        {
            bool Is_Valid = Convert.ToBoolean(ABFormView.DataKey["Is_Identified"]);
            double Available_Balance = Convert.ToDouble(ABFormView.DataKey["Available_Balance"]);

            double Send_Balance = 0;
            int Received_RegistrationID = 0;
            int Transition_CodeID = 0;
            string Phone = "";

            using (SqlConnection con = new SqlConnection())
            {
                con.ConnectionString = ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "SELECT Fund_Transition_Code.Transition_CodeID, Fund_Transition_Code.Amount, Fund_Transition_Code.Received_RegistrationID, Fund_Transition_Code.Insert_Date, Registration.Phone FROM Fund_Transition_Code INNER JOIN Registration ON Fund_Transition_Code.Received_RegistrationID = Registration.RegistrationID WHERE (Fund_Transition_Code.Sent_RegistrationID = @Sent_RegistrationID) AND (Fund_Transition_Code.IS_Used = 0) AND (Fund_Transition_Code.Transition_Code = @Transition_Code)";
                    cmd.Parameters.AddWithValue("@Transition_Code", Code_TextBox.Text.Trim());
                    cmd.Parameters.AddWithValue("@Sent_RegistrationID", Session["RegistrationID"].ToString());

                    cmd.Connection = con;
                    con.Open();
                    using (SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        while (sdr.Read())
                        {
                            Send_Balance = Convert.ToDouble(sdr["Amount"]);
                            Received_RegistrationID = Convert.ToInt32(sdr["Received_RegistrationID"]);
                            Transition_CodeID = Convert.ToInt32(sdr["Transition_CodeID"]);
                            Phone = sdr["Phone"].ToString();
                        }
                    }
                    con.Close();
                }
            }


            if (Is_Valid)
            {
                if (Received_RegistrationID != 0)
                {
                    if (Send_Balance <= Available_Balance && Available_Balance != 0)
                    {
                        Fund_TransitionSQL.InsertParameters["Amount"].DefaultValue = Send_Balance.ToString();
                        Fund_TransitionSQL.InsertParameters["Received_RegistrationID"].DefaultValue = Received_RegistrationID.ToString();
                        Fund_TransitionSQL.InsertParameters["Transition_CodeID"].DefaultValue = Transition_CodeID.ToString();
                        Fund_TransitionSQL.Insert();

                        Fund_TransitionSQL.UpdateParameters["Amount"].DefaultValue = Send_Balance.ToString();
                        Fund_TransitionSQL.UpdateParameters["Received_RegistrationID"].DefaultValue = Received_RegistrationID.ToString();
                        Fund_TransitionSQL.UpdateParameters["Transition_CodeID"].DefaultValue = Transition_CodeID.ToString();
                        Fund_TransitionSQL.Update();

                        //send sms
                        string sms = "You have received balance " + Send_Balance + " Tk, from id: " + User.Identity.Name + ". DNB SUPERSHOP";
                        Send_SMS(Phone, sms, "Received Balance");
                        Response.Redirect(Request.Url.AbsolutePath);
                    }
                    else
                    {
                        InvalidUserLabel.Text = "Send Amount greater than available balance";
                    }
                }
                else
                {
                    InvalidUserLabel.Text = "Invalid Code";
                }
            }
            else
            {
                InvalidUserLabel.Text = "Sending Failed!! You are not approved by authority!";
            }
        }

        //send sms
        private void Send_SMS(string Phone, string Msg, string Purpose)
        {
            SMS_Class SMS = new SMS_Class();
            int TotalSMS = 0;
            int SMSBalance = SMS.SMSBalance;

            TotalSMS = SMS.SMS_Conut(Msg);

            if (SMSBalance >= TotalSMS)
            {
                if (SMS.SMS_GetBalance() >= TotalSMS)
                {
                    Get_Validation IsValid = SMS.SMS_Validation(Phone, Msg);
                    if (IsValid.Validation)
                    {
                        Guid SMS_Send_ID = SMS.SMS_Send(Phone, Msg, Purpose);

                        SMS_OtherInfoSQL.InsertParameters["SMS_Send_ID"].DefaultValue = SMS_Send_ID.ToString();
                        SMS_OtherInfoSQL.Insert();
                    }
                }
            }
        }
        //transfer code
        public string GetRandomNumbers(int length)
        {
            List<string> randomNumbers = new List<string>();

            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "SELECT Transition_Code FROM Fund_Transition_Code WHERE (IS_Used = 0)";

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