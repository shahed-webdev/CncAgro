using System;
using System.Web.UI.WebControls;

namespace CncAgro.AccessAdmin.Member.ProductDistribution
{
    public partial class Delivery_Details : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(Request.QueryString["DistributionID"]))
            {
                Response.Redirect("Product_Delivery.aspx");
            }
        }

        protected void Delivery_Button_Click(object sender, EventArgs e)
        {

            foreach (GridViewRow row in ProductGridView.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {

                    Stock_UpdateSQL.UpdateParameters["Product_PointID"].DefaultValue = ProductGridView.DataKeys[row.RowIndex]["ProductID"].ToString();
                    Stock_UpdateSQL.UpdateParameters["Stock_Quantity"].DefaultValue = ProductGridView.DataKeys[row.RowIndex]["SellingQuantity"].ToString();
                    Stock_UpdateSQL.Update();

                    Seller_Product_insert_UpdateSQL.InsertParameters["SellerID"].DefaultValue = InfoFormView.DataKey["SellerID"].ToString();
                    Seller_Product_insert_UpdateSQL.InsertParameters["SellerProduct_Stock"].DefaultValue = ProductGridView.DataKeys[row.RowIndex]["SellingQuantity"].ToString();
                    Seller_Product_insert_UpdateSQL.InsertParameters["Product_PointID"].DefaultValue = ProductGridView.DataKeys[row.RowIndex]["ProductID"].ToString();
                    Seller_Product_insert_UpdateSQL.Insert();


                }
            }
            ProductSQL.Update();

            Response.Redirect("Product_Delivery.aspx");
        }
    }
}