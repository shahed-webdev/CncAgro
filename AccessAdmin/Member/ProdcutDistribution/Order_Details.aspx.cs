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
            {
                Response.Redirect("Order_Confirmation.aspx");
            }

            if (!this.IsPostBack)
            {
                DataTable ChargeTeble = new DataTable();
                ChargeTeble.Columns.AddRange(new DataColumn[9] { new DataColumn("ProductID"), new DataColumn("Product_Name"), new DataColumn("SellingQuantity"), new DataColumn("SellingUnitPrice"), new DataColumn("SellingUnitPoint"), new DataColumn("SellingUnit_Commission"), new DataColumn("ProductPrice"), new DataColumn("TotalPoint"), new DataColumn("Total_Commission") });
                ViewState["ChargeTeble"] = ChargeTeble;

                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());
                SqlCommand MemberInfo_cmd = new SqlCommand("SELECT Product_Distribution_Records.ProductID, Product_Distribution_Records.SellingQuantity, Product_Distribution_Records.SellingUnitPrice, Product_Distribution_Records.SellingUnitPoint, Product_Distribution_Records.ProductPrice, Product_Distribution_Records.TotalPoint, Product_Distribution_Records.SellingUnit_Commission, Product_Point_Code.Product_Name, Product_Point_Code.Product_Code FROM  Product_Distribution_Records INNER JOIN  Product_Point_Code ON Product_Distribution_Records.ProductID = Product_Point_Code.Product_PointID WHERE (Product_DistributionID = @DistributionID)", con);
                MemberInfo_cmd.Parameters.AddWithValue("@DistributionID", Request.QueryString["DistributionID"].ToString());

                con.Open();
                SqlDataReader Member;
                Member = MemberInfo_cmd.ExecuteReader();

                while (Member.Read())
                {
                    ChargeTeble.Rows.Add(Member["ProductID"].ToString(), Member["Product_Name"].ToString(), Member["SellingQuantity"].ToString(), Member["SellingUnitPrice"].ToString(), Member["SellingUnitPoint"].ToString(), Member["SellingUnit_Commission"].ToString(), Member["ProductPrice"].ToString(), Member["TotalPoint"].ToString(), (Convert.ToDouble(Member["SellingUnit_Commission"]) * Convert.ToDouble(Member["SellingQuantity"])));
                    ViewState["ChargeTeble"] = ChargeTeble;
                    this.BindGrid();
                }
                con.Close();
            }
        }

        /*Add To Cart Button*/
        protected void BindGrid()
        {
            ChargeGridView.DataSource = ViewState["ChargeTeble"] as DataTable;
            ChargeGridView.DataBind();
        }
        protected void RowDelete(object sender, EventArgs e)
        {
            GridViewRow row = (sender as Button).NamingContainer as GridViewRow;
            DataTable ChargeTeble = ViewState["ChargeTeble"] as DataTable;

            ChargeTeble.Rows.RemoveAt(row.RowIndex);
            ViewState["ChargeTeble"] = ChargeTeble;
            this.BindGrid();
        }
        protected void AddToCartButton_Click(object sender, EventArgs e)
        {
            if (ProductID_HF.Value != string.Empty)
            {
                double Stock = Convert.ToDouble(Current_StookHF.Value);
                double UnitPrice = Convert.ToDouble(UPHF.Value);
                double Quntity = Convert.ToDouble(QuantityTextBox.Text);
                double UnitPoint = Convert.ToDouble(Point_HF.Value);
                double Commission = Convert.ToDouble(Commission_HF.Value);

                bool ID_Check = true;
                foreach (GridViewRow row in ChargeGridView.Rows)
                {
                    Label ProductIDLabel = row.FindControl("PIDLabel") as Label;

                    if (ProductIDLabel.Text == ProductID_HF.Value)
                    {
                        ID_Check = false;
                    }
                }


                if (ID_Check)
                {
                    if (Stock >= Quntity)
                    {
                        DataTable ChargeTeble = ViewState["ChargeTeble"] as DataTable;
                        ChargeTeble.Rows.Add(ProductID_HF.Value, ProductName_HF.Value, QuantityTextBox.Text, UnitPrice, UnitPoint, Commission, (UnitPrice * Quntity), (UnitPoint * Quntity), (Commission * Quntity));
                        ViewState["ChargeTeble"] = ChargeTeble;
                        this.BindGrid();

                        ProductID_HF.Value = "";
                        ProductCodeTextBox.Text = string.Empty;
                        UPHF.Value = "";
                        QuantityTextBox.Text = string.Empty;
                        Commission_HF.Value = string.Empty;
                    }
                    else
                    {
                        ProductID_HF.Value = "";
                        UPHF.Value = "";
                        Current_StookHF.Value = "";
                        ProductCodeTextBox.Text = string.Empty;
                        QuantityTextBox.Text = string.Empty;
                        Commission_HF.Value = string.Empty;

                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Selling Quantity more than stocks')", true);
                    }
                }
                else
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Product Alrady Added in the Cart')", true);
                }
            }
            else
            {
                ProductCodeTextBox.Text = string.Empty;
                QuantityTextBox.Text = string.Empty;
            }
        }

        [WebMethod]
        public static string GetProduct(string prefix, string SellerID)
        {
            List<Product> User = new List<Product>();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "SELECT top(2) Product_Point_Code.Product_Code, Product_Point_Code.Product_Name, Product_Point_Code.Product_Price, Product_Point_Code.Product_Point, Product_Point_Code.Product_PointID,Product_Point_Code.Net_Quantity, (Product_Point_Code.Seller_Commission * Seller.CommissionPercentage / 100) AS Seller_Commission FROM Product_Point_Code CROSS JOIN Seller WHERE (Product_Point_Code.Stock_Quantity > 0) AND (Product_Point_Code.IsActive = 1) AND (Seller.SellerID = @SellerID) AND ((Seller.IsCIP = 0 AND Product_Point_Code.IsCIP = 0) OR (Seller.IsCIP = 1)) AND Product_Point_Code.Product_Code LIKE @Product_Code + '%'";
                    cmd.Parameters.AddWithValue("@Product_Code", prefix);
                    cmd.Parameters.AddWithValue("@SellerID", SellerID);
                    cmd.Connection = con;

                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    while (dr.Read())
                    {
                        User.Add(new Product
                        {
                            Code = dr["Product_Code"].ToString(),
                            Name = dr["Product_Name"].ToString(),
                            Price = dr["Product_Price"].ToString(),
                            Point = dr["Product_Point"].ToString(),
                            Stock = dr["Net_Quantity"].ToString(),
                            Commission = dr["Seller_Commission"].ToString(),
                            ProductID = dr["Product_PointID"].ToString()
                        });
                    }
                    con.Close();

                    var json = new JavaScriptSerializer().Serialize(User);
                    return json;
                }
            }
        }
        class Product
        {
            public string Code { get; set; }
            public string Name { get; set; }
            public string Price { get; set; }
            public string Point { get; set; }
            public string Stock { get; set; }
            public string Commission { get; set; }
            public string ProductID { get; set; }
        }
        protected void Confirm_Button_Click(object sender, EventArgs e)
        {
            double Available_Balance = Convert.ToDouble(InfoFormView.DataKey["Available_Balance"]);
            double Prev_Net = Convert.ToDouble(InfoFormView.DataKey["Net_Amount"]);
            double Total_Price = Convert.ToDouble(Total_Price_HF.Value);
            double Total_Commi = Convert.ToDouble(Total_Commission_HF.Value);

            if (Available_Balance >= ((Total_Price - Total_Commi) - Prev_Net))
            {
                Product_DistributionSQL.Update();

                Seller_UpdateSQL.UpdateParameters["Buying_Amount"].DefaultValue = ((Total_Price - Total_Commi) - Prev_Net).ToString();
                Seller_UpdateSQL.UpdateParameters["SellerID"].DefaultValue = InfoFormView.DataKey["SellerID"].ToString();
                Seller_UpdateSQL.Update();


                Product_Distribution_RecordsSQL.Delete();

                foreach (GridViewRow row in ChargeGridView.Rows)
                {
                    Label ProductIDLabel = row.FindControl("PIDLabel") as Label;
                    Label QntLabel = row.FindControl("QntLabel") as Label;
                    Label Selling_UPLabel = row.FindControl("Selling_UPLabel") as Label;
                    Label Selling_UPointLabel = row.FindControl("Selling_UPointLabel") as Label;
                    Label Commission_Label = row.FindControl("Commission_Label") as Label;

                    Product_Distribution_RecordsSQL.InsertParameters["ProductID"].DefaultValue = ProductIDLabel.Text;
                    Product_Distribution_RecordsSQL.InsertParameters["SellingQuantity"].DefaultValue = QntLabel.Text;
                    Product_Distribution_RecordsSQL.InsertParameters["SellingUnitPrice"].DefaultValue = Selling_UPLabel.Text;
                    Product_Distribution_RecordsSQL.InsertParameters["SellingUnitPoint"].DefaultValue = Selling_UPointLabel.Text;
                    Product_Distribution_RecordsSQL.InsertParameters["SellingUnit_Commission"].DefaultValue = Commission_Label.Text;
                    Product_Distribution_RecordsSQL.Insert();
                }

                Response.Redirect("../Distribution_Receipt.aspx?Distribution=" + Request.QueryString["DistributionID"].ToString());
            }
            else { ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Not enough balance')", true); }
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            Cancel_SQL.UpdateParameters["Buying_Amount"].DefaultValue = InfoFormView.DataKey["Net_Amount"].ToString();
            Cancel_SQL.UpdateParameters["SellerID"].DefaultValue = InfoFormView.DataKey["SellerID"].ToString();
            Cancel_SQL.Update();

            Cancel_SQL.Delete();

            Response.Redirect("Order_Confirmation.aspx");
        }
    }
}