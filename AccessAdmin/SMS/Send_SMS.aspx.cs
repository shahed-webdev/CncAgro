using System;
using System.Web.UI;

namespace CncAgro.AccessAdmin.SMS
{
    public partial class Send_SMS : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void SendButton_Click(object sender, EventArgs e)
        {
            SMS_Class SMS = new SMS_Class();

            int TotalSMS = 0;
            int SMSBalance = SMS.SMSBalance;
            string PhoneNo = Phone_TextBox.Text.Trim();
            string Msg = Text_TextBox.Text;

            TotalSMS = SMS.SMS_Conut(Msg);

            if (SMSBalance >= TotalSMS)
            {
                if (SMS.SMS_GetBalance() >= TotalSMS)
                {
                    Get_Validation IsValid = SMS.SMS_Validation(PhoneNo, Msg);
                    if (IsValid.Validation)
                    {
                        Guid SMS_Send_ID = SMS.SMS_Send(PhoneNo, Msg, "Send");

                        SMS_OtherInfoSQL.InsertParameters["SMS_Send_ID"].DefaultValue = SMS_Send_ID.ToString();
                        SMS_OtherInfoSQL.Insert();

                        Phone_TextBox.Text = "";
                        Text_TextBox.Text = "";

                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('SMS Successfully Sent')", true);
                    }
                }
            }
        }
    }
}