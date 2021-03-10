using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CncAgro.AccessAdmin.Member.ProductDistribution
{
    public partial class Product_Delivery : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Delivery_Button_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());

            foreach (GridViewRow row in OrderGridView.Rows)
            {
                CheckBox ConfirmCheckBox = row.FindControl("ConfirmCheckBox") as CheckBox;
                if (ConfirmCheckBox.Checked)
                {
                    string Product_DistributionID = OrderGridView.DataKeys[row.RowIndex]["Product_DistributionID"].ToString();
                    string memberId = OrderGridView.DataKeys[row.RowIndex]["MemberID"].ToString();

                    DeliverySQL.UpdateParameters["Product_DistributionID"].DefaultValue = Product_DistributionID;
                    DeliverySQL.Update();


                    SqlCommand Product_Dis_cmd = new SqlCommand("SELECT ProductID, SellingQuantity FROM Product_Distribution_Records WHERE (Product_DistributionID = @Product_DistributionID)", con);
                    Product_Dis_cmd.Parameters.AddWithValue("Product_DistributionID", Product_DistributionID);

                    con.Open();

                    SqlDataReader Product_Distri;
                    Product_Distri = Product_Dis_cmd.ExecuteReader();

                    while (Product_Distri.Read())
                    {
                        Seller_Product_insert_UpdateSQL.InsertParameters["MemberID"].DefaultValue = memberId;
                        Seller_Product_insert_UpdateSQL.InsertParameters["Product_PointID"].DefaultValue = Product_Distri["ProductID"].ToString();
                        Seller_Product_insert_UpdateSQL.InsertParameters["ProductStock"].DefaultValue = Product_Distri["SellingQuantity"].ToString();
                        Seller_Product_insert_UpdateSQL.Insert();

                        Stock_UpdateSQL.UpdateParameters["Product_PointID"].DefaultValue = Product_Distri["ProductID"].ToString();
                        Stock_UpdateSQL.UpdateParameters["Stock_Quantity"].DefaultValue = Product_Distri["SellingQuantity"].ToString();
                        Stock_UpdateSQL.Update();

                    }
                    con.Close();
                }
            }

            OrderGridView.DataBind();
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Order Delivered Successfully')", true);
        }
    }
}