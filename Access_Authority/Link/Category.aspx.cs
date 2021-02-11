using System;

namespace CncAgro.Access_Authority.Page_Link
{
    public partial class Category : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void SubmitButton_Click(object sender, EventArgs e)
        {
            CategorySQL.Insert();
        }
    }
}