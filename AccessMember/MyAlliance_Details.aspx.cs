using System;
using System.Data;
using System.Web.UI;

namespace CncAgro.AccessMember
{
    public partial class MyAlliance_Details : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Page.IsPostBack) return;

            var dv = (DataView)MembersSQL.Select(DataSourceSelectArguments.Empty);
            if (dv != null) 
                Total_Label.Text =  dv.Count.ToString();
        }

        protected void FindButton_Click(object sender, EventArgs e)
        {
            var dv = (DataView)MembersSQL.Select(DataSourceSelectArguments.Empty);
            if (dv != null) 
                Total_Label.Text = dv.Count.ToString();
        }
    }
}