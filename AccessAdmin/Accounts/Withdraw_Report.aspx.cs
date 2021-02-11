using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CncAgro.AccessAdmin.Accounts
{
    public partial class Withdraw_Report : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                From_TextBox.Text = DateTime.Now.ToString("d MMM yyyy");
                TO_TextBox.Text = DateTime.Now.ToString("d MMM yyyy");
            }
        }
    }
}