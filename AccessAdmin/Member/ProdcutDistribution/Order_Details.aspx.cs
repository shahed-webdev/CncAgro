using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CncAgro.AccessAdmin.Member.ProductDistribution
{
    public partial class Order_Details : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(Request.QueryString["DistributionID"]))
                Response.Redirect("Order_Confirmation.aspx");
            
            if (IsPostBack) return;

            var chargeTable = new DataTable();
            chargeTable.Columns.AddRange(new[] { new DataColumn("ProductID"), new DataColumn("Product_Name"),new DataColumn("Product_Code"), new DataColumn("SellingQuantity"), new DataColumn("SellingUnitPrice"), new DataColumn("ProductPrice") });
            ViewState["ChargeTeble"] = chargeTable;

            var con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());
            var memberInfoCmd = new SqlCommand("SELECT Product_Distribution_Records.ProductID, Product_Distribution_Records.SellingQuantity, Product_Distribution_Records.SellingUnitPrice, Product_Distribution_Records.SellingUnitPoint, Product_Distribution_Records.ProductPrice, Product_Distribution_Records.TotalPoint, Product_Point_Code.Product_Name, Product_Point_Code.Product_Code FROM Product_Distribution_Records INNER JOIN Product_Point_Code ON Product_Distribution_Records.ProductID = Product_Point_Code.Product_PointID WHERE (Product_Distribution_Records.Product_DistributionID = @DistributionID)", con);
            memberInfoCmd.Parameters.AddWithValue("@DistributionID", Request.QueryString["DistributionID"]);

            con.Open();
            var member = memberInfoCmd.ExecuteReader();

            while (member.Read())
            {
                chargeTable.Rows.Add(
                    member["ProductID"].ToString(),
                    member["Product_Name"].ToString(), 
                    member["Product_Code"].ToString(), 
                    member["SellingQuantity"].ToString(),
                    member["SellingUnitPrice"].ToString(),
                    member["ProductPrice"].ToString()
                );

                ViewState["ChargeTeble"] = chargeTable;
                BindGrid();
            }
            con.Close();
        }

        /*Add To Cart Button*/
        protected void BindGrid()
        {
            ChargeGridView.DataSource = ViewState["ChargeTeble"] as DataTable;
            ChargeGridView.DataBind();
        }

        protected void RowDelete(object sender, EventArgs e)
        {
            var row = (sender as Button)?.NamingContainer as GridViewRow;

            if (ViewState["ChargeTeble"] is DataTable chargeTable)
            {
                chargeTable.Rows.RemoveAt(row.RowIndex);
                ViewState["ChargeTeble"] = chargeTable;
            }

            this.BindGrid();
        }

        protected void AddToCartButton_Click(object sender, EventArgs e)
        {
            if (ProductID_HF.Value != string.Empty)
            {
                var stock = Convert.ToDouble(Current_StookHF.Value);
                var unitPrice = Convert.ToDouble(UPHF.Value);
                var quantity = Convert.ToDouble(QuantityTextBox.Text);
                
                var idCheck = true;
                foreach (GridViewRow row in ChargeGridView.Rows)
                {
                    var productIdLabel = (Label) row.FindControl("PIDLabel");

                    if (productIdLabel != null && productIdLabel.Text == ProductID_HF.Value)
                    {
                        idCheck = false;
                    }
                }


                if (idCheck)
                {
                    if (stock >= quantity)
                    {
                        var chargeTable = (DataTable) ViewState["ChargeTeble"];
                        
                        if (chargeTable != null)
                        {
                            chargeTable.Rows.Add(ProductID_HF.Value, ProductName_HF.Value, ProductCodeTextBox.Text, QuantityTextBox.Text, unitPrice, (unitPrice * quantity));
                            ViewState["ChargeTeble"] = chargeTable;
                        }

                        this.BindGrid();

                        ProductID_HF.Value = "";
                        ProductCodeTextBox.Text = string.Empty;
                        UPHF.Value = "";
                        QuantityTextBox.Text = string.Empty;
                    }
                    else
                    {
                        ProductID_HF.Value = "";
                        UPHF.Value = "";
                        Current_StookHF.Value = "";
                        ProductCodeTextBox.Text = string.Empty;
                        QuantityTextBox.Text = string.Empty;

                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Selling Quantity more than stocks')", true);
                    }
                }
                else
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Product Already Added in the Cart')", true);
                }
            }
            else
            {
                ProductCodeTextBox.Text = string.Empty;
                QuantityTextBox.Text = string.Empty;
            }
        }

        [WebMethod]
        public static string GetProduct(string prefix)
        {
            var user = new List<Product>();
            using (var con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString))
            {
                using (var cmd = new SqlCommand())
                {
                    cmd.CommandText = "SELECT TOP (2) Product_Code, Product_Name, Product_Price, Product_Point, Product_PointID, Net_Quantity FROM Product_Point_Code WHERE (Stock_Quantity > 0) AND (IsActive = 1) AND (Product_Code LIKE @Product_Code + '%')";
                    cmd.Parameters.AddWithValue("@Product_Code", prefix);
                    cmd.Connection = con;

                    con.Open();
                    var dr = cmd.ExecuteReader();

                    while (dr.Read())
                    {
                        user.Add(new Product
                        {
                            Code = dr["Product_Code"].ToString(),
                            Name = dr["Product_Name"].ToString(),
                            Price = dr["Product_Price"].ToString(),
                            Point = dr["Product_Point"].ToString(),
                            Stock = dr["Net_Quantity"].ToString(),
                            ProductID = dr["Product_PointID"].ToString()
                        });
                    }
                    con.Close();

                    var json = new JavaScriptSerializer().Serialize(user);
                    return json;
                }
            }
        }

        private class Product
        {
            public string Code { get; set; }
            public string Name { get; set; }
            public string Price { get; set; }
            public string Point { get; set; }
            public string Stock { get; set; }
            public string ProductID { get; set; }
        }


        protected void Confirm_Button_Click(object sender, EventArgs e)
        {
            Product_DistributionSQL.Update();

            Product_Distribution_RecordsSQL.Delete();

            foreach (GridViewRow row in ChargeGridView.Rows)
            {
                var productIdLabel = row.FindControl("PIDLabel") as Label;
                var qntLabel = row.FindControl("QntLabel") as Label;
                var sellingUpLabel = row.FindControl("Selling_UPLabel") as Label;

                Product_Distribution_RecordsSQL.InsertParameters["ProductID"].DefaultValue = productIdLabel.Text;
                Product_Distribution_RecordsSQL.InsertParameters["SellingQuantity"].DefaultValue = qntLabel.Text;
                Product_Distribution_RecordsSQL.InsertParameters["SellingUnitPrice"].DefaultValue = sellingUpLabel.Text;
                Product_Distribution_RecordsSQL.InsertParameters["SellingUnitPoint"].DefaultValue = sellingUpLabel.Text;
                Product_Distribution_RecordsSQL.Insert();
            }

            Response.Redirect("Distribution_Receipt.aspx?Distribution=" + Request.QueryString["DistributionID"].ToString());

        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            Cancel_SQL.Delete();
            Response.Redirect("Order_Confirmation.aspx");
        }
    }
}