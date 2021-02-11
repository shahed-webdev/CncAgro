using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CncAgro.AccessAdmin.Member
{
    public partial class Member_List : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                DataView dv = (DataView)MemberSQL.Select(DataSourceSelectArguments.Empty);
                Total_Label.Text = "Total: " + dv.Count.ToString() + " Customer(s)";
            }
        }
        protected void Is_Identified_CheckBox_CheckedChanged(object sender, EventArgs e)
        {
            GridViewRow Row = ((GridViewRow)((Control)sender).Parent.Parent);

            MemberSQL.UpdateParameters["Is_Identified"].DefaultValue = "0";
            MemberSQL.UpdateParameters["MemberID"].DefaultValue = MemberListGridView.DataKeys[Row.RowIndex]["MemberID"].ToString();
            MemberSQL.Update();

            // MemberSQL.Insert Total Carry Member Update by SP Add_Update_CarryMember
            MemberSQL.InsertParameters["MemberID"].DefaultValue = MemberListGridView.DataKeys[Row.RowIndex]["MemberID"].ToString();
            MemberSQL.Insert();
        }

        protected void FindButton_Click(object sender, EventArgs e)
        {
            DataView dv = (DataView)MemberSQL.Select(DataSourceSelectArguments.Empty);
            Total_Label.Text = "Total: " + dv.Count.ToString() + " Customer(s)";
        }
    }
}