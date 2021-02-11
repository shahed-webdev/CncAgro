using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CncAgro.AccessAdmin.Member
{
    public partial class Member_Access_Control : System.Web.UI.Page
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

        protected void ApprovedCheckBox_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox ApprovedCheckBox = (CheckBox)sender;
            GridViewRow Row = (GridViewRow)ApprovedCheckBox.Parent.Parent;

            MembershipUser usr = Membership.GetUser(Member_GridView.DataKeys[Row.DataItemIndex % Member_GridView.PageSize]["UserName"].ToString());
            usr.IsApproved = ApprovedCheckBox.Checked;
            Membership.UpdateUser(usr);
        }

        protected void LockedOutCheckBox_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox LockedOutCheckBox = (CheckBox)sender;
            GridViewRow Row = (GridViewRow)LockedOutCheckBox.Parent.Parent;

            MembershipUser usr = Membership.GetUser(Member_GridView.DataKeys[Row.DataItemIndex % Member_GridView.PageSize]["UserName"].ToString());
            usr.UnlockUser();
            LockedOutCheckBox.Checked = usr.IsLockedOut;
        }    
    }
}