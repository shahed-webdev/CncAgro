using System;
using System.Data;
using System.Web.UI;

namespace CncAgro.AccessMember
{
    public partial class MyAlliance_Details : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                DataView dv = (DataView)MembersSQL.Select(DataSourceSelectArguments.Empty);
                Total_Label.Text = "Total: " + dv.Count.ToString() + " Customers";
            }
        }

        protected void FindButton_Click(object sender, EventArgs e)
        {
            DataView dv = (DataView)MembersSQL.Select(DataSourceSelectArguments.Empty);
            Total_Label.Text = "Total: " + dv.Count.ToString() + " Customers";

        }
    }
}