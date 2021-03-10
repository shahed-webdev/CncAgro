using System;
using System.Data;
using System.Web.UI;

namespace DnbBD.AccessAdmin.Member.ProdcutDistribution
{
    public partial class OrderedMemberList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                DataView dv = (DataView)MemberSQL.Select(DataSourceSelectArguments.Empty);
                Total_Label.Text = "Total: " + dv.Count.ToString() + " Customer(s)";
            }
        }

        protected void FindButton_Click(object sender, EventArgs e)
        {
            DataView dv = (DataView)MemberSQL.Select(DataSourceSelectArguments.Empty);
            Total_Label.Text = "Total: " + dv.Count.ToString() + " Customer(s)";
        }
    }
}