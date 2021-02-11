using System;

namespace CncAgro.AccessAdmin.Product_Point
{
    public partial class Point_Report : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                From_TextBox.Text = DateTime.Now.AddDays(-1).ToString("d MMM yyyy");
                TO_TextBox.Text = DateTime.Now.AddDays(-1).ToString("d MMM yyyy");
            }
        }
    }
}