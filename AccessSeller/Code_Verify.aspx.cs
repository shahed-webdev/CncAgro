using System;

namespace CncAgro.AccessSeller
{
    public partial class Code_Verify : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(Request.QueryString["id"]))
            {
                Response.Redirect("Seller_Profile.aspx");
            }
        }

        protected void ReceiveButton_Click(object sender, EventArgs e)
        {
            double Available_Balance = Convert.ToDouble(M_detailsFormView.DataKey["Available_Balance"]);
            double Send_Balance = Convert.ToDouble(M_detailsFormView.DataKey["Amount"]);

            string Sent_RegistrationID = M_detailsFormView.DataKey["Sent_RegistrationID"].ToString();
            string Transition_CodeID = M_detailsFormView.DataKey["Transition_CodeID"].ToString();
            string Transition_Code = M_detailsFormView.DataKey["Transition_Code"].ToString();
            string Phone = M_detailsFormView.DataKey["Phone"].ToString();


            if (Transition_Code == CodeTextBox.Text)
            {
                if (Send_Balance <= Available_Balance && Available_Balance != 0)
                {
                    Fund_TransitionSQL.InsertParameters["Amount"].DefaultValue = Send_Balance.ToString();
                    Fund_TransitionSQL.InsertParameters["Sent_RegistrationID"].DefaultValue = Sent_RegistrationID;
                    Fund_TransitionSQL.InsertParameters["Transition_CodeID"].DefaultValue = Transition_CodeID;
                    Fund_TransitionSQL.Insert();

                    Fund_TransitionSQL.UpdateParameters["Amount"].DefaultValue = Send_Balance.ToString();
                    Fund_TransitionSQL.UpdateParameters["Sent_RegistrationID"].DefaultValue = Sent_RegistrationID;
                    Fund_TransitionSQL.UpdateParameters["Transition_CodeID"].DefaultValue = Transition_CodeID;
                    Fund_TransitionSQL.Update();

                    //send sms
                    string sms = "Your transaction has been Successful. Sent amount " + Send_Balance + " Tk. Recipient id: " + User.Identity.Name + ". 786 Nitta Bazar Ltd";
                    Send_SMS(Phone, sms, "Send Balance");

                    Response.Redirect("Seller_Profile.aspx");
                }
                else
                {
                    InvalidUserLabel.Text = "balance not available";
                }
            }
            else
            {
                InvalidUserLabel.Text = "Invalid Code";
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
    }
}