using System;

namespace CncAgro.AccessSeller
{
    public partial class Distributor_Selling_Report : System.Web.UI.Page
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