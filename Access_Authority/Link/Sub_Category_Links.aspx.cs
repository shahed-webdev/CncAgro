using System;
using System.Web.Security;
using System.Web.UI.WebControls;

namespace CncAgro.Access_Authority.Link
{
    public partial class Sub_Category_Links : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                string Category = Request.QueryString["Category"];
                if (string.IsNullOrEmpty(Category))
                    Response.Redirect("Sub_Category.aspx");
            }
        }


        protected void SubmitButton_Click(object sender, EventArgs e)
        {
            Link_PagesSQL.Insert();
            Response.Redirect(Request.Url.AbsoluteUri);
        }

        protected void SubCategoryDropDownList_DataBound(object sender, EventArgs e)
        {
            GridViewRow GV = ((DropDownList)sender).Parent.Parent as GridViewRow;

            DropDownList SubCategoryDropDownList = (DropDownList)GV.FindControl("SubCategoryDropDownList");
            SubCategoryDropDownList.Items.Insert(0, new ListItem("[No Sub Category]", ""));
        }

        protected void InsertedLinkGridView_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            Link_PagesSQL.UpdateParameters["LinkCategoryID"].DefaultValue = (InsertedLinkGridView.Rows[e.RowIndex].FindControl("CategotyDropDownList") as DropDownList).SelectedValue;
            Link_PagesSQL.UpdateParameters["SubCategoryID"].DefaultValue = (InsertedLinkGridView.Rows[e.RowIndex].FindControl("SubCategoryDropDownList") as DropDownList).SelectedValue;
        }

        protected void InsertedLinkGridView_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            Roles.DeleteRole(InsertedLinkGridView.DataKeys[e.RowIndex]["RoleName"].ToString(), true);
        }
    }
}