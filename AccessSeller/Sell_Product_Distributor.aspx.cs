using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CncAgro.AccessSeller
{
    public partial class Sell_Product_Distributor : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                Page.ClientScript.RegisterStartupScript(this.GetType(), "Rl", "RemoveCart();", true);
            }
        }

        //Get Seller
        [WebMethod]
        public static string GetCustomers(string prefix)
        {
            List<Seller> User = new List<Seller>();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "SELECT top(2) Registration.UserName, Registration.Name, Registration.Phone, Seller.SellerID FROM Registration INNER JOIN Seller ON Registration.RegistrationID = Seller.SellerRegistrationID WHERE Seller.SellerID <> @SellerID AND Registration.UserName LIKE @UserName + '%'";
                    cmd.Parameters.AddWithValue("@UserName", prefix);
                    cmd.Parameters.AddWithValue("@SellerID", HttpContext.Current.Session["SellerID"].ToString());
                    cmd.Connection = con;

                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    while (dr.Read())
                    {
                        User.Add(new Seller
                        {
                            Username = dr["UserName"].ToString(),
                            Name = dr["Name"].ToString(),
                            Phone = dr["Phone"].ToString(),
                            SellerID = dr["SellerID"].ToString(),
                        });
                    }
                    con.Close();

                    var json = new JavaScriptSerializer().Serialize(User);
                    return json;
                }
            }
        }
        class Seller
        {
            public string Username { get; set; }
            public string Name { get; set; }
            public string Phone { get; set; }
            public string SellerID { get; set; }
        }

        //Get product
        [WebMethod]
        public static string GetProduct(string prefix, string Client_SellerID)
        {
            List<Product> User = new List<Product>();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "SELECT TOP(2) Product_Point_Code.Product_Code, Product_Point_Code.Product_Name, Product_Point_Code.Product_Price, Product_Point_Code.Product_Point, Product_Point_Code.Product_PointID, Seller_Product.SellerProduct_Stock,(Product_Point_Code.Seller_Commission * Seller.CommissionPercentage / 100) AS Seller_Commission FROM Product_Point_Code INNER JOIN Seller_Product ON Product_Point_Code.Product_PointID = Seller_Product.Product_PointID CROSS JOIN Seller WHERE (Seller_Product.SellerID = @SellerID) AND (Seller.SellerID = @Client_SellerID) AND (Seller_Product.SellerProduct_Stock > 0) AND (Product_Point_Code.Product_Code LIKE @Product_Code + '%')";
                    cmd.Parameters.AddWithValue("@Product_Code", prefix);
                    cmd.Parameters.AddWithValue("@SellerID", HttpContext.Current.Session["SellerID"].ToString());
                    cmd.Parameters.AddWithValue("@Client_SellerID", Client_SellerID);
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
                            Stock = dr["SellerProduct_Stock"].ToString(),
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

        //shopping cart
        class Shopping
        {
            public string ProductID { get; set; }
            public int Quantity { get; set; }
            public string Unit_Price { get; set; }
            public string Unit_Point { get; set; }
            public string Commission { get; set; }
        }
        List<Shopping> ProductList()
        {
            string json = JsonData.Value;
            JavaScriptSerializer js = new JavaScriptSerializer();
            List<Shopping> data = js.Deserialize<List<Shopping>>(json);
            return data;
        }
        protected void SellButton_Click(object sender, EventArgs e)
        {
            if (JsonData.Value != "")
            {
                if (SellerID_HF.Value != "")
                {
                    Product_DistributionSQL.Insert();

                    List<Shopping> P_List = new List<Shopping>(ProductList());

                    foreach (Shopping item in P_List)
                    {
                        Product_Distribution_RecordsSQL.InsertParameters["ProductID"].DefaultValue = item.ProductID;
                        Product_Distribution_RecordsSQL.InsertParameters["DistributorShoppingID"].DefaultValue = ViewState["DistributorShoppingID"].ToString();
                        Product_Distribution_RecordsSQL.InsertParameters["SellingQuantity"].DefaultValue = item.Quantity.ToString();
                        Product_Distribution_RecordsSQL.InsertParameters["SellingUnitPrice"].DefaultValue = item.Unit_Price;
                        Product_Distribution_RecordsSQL.InsertParameters["SellingUnitPoint"].DefaultValue = item.Unit_Point;
                        Product_Distribution_RecordsSQL.InsertParameters["SellingUnit_Commission"].DefaultValue = item.Commission;
                        Product_Distribution_RecordsSQL.Insert();

                        Seller_Product_insert_UpdateSQL.InsertParameters["Product_PointID"].DefaultValue = item.ProductID;
                        Seller_Product_insert_UpdateSQL.InsertParameters["SellerProduct_Stock"].DefaultValue = item.Quantity.ToString();
                        Seller_Product_insert_UpdateSQL.Insert();

                        Stock_UpdateSQL.UpdateParameters["Product_PointID"].DefaultValue = item.ProductID;
                        Stock_UpdateSQL.UpdateParameters["Stock_Quantity"].DefaultValue = item.Quantity.ToString();
                        Stock_UpdateSQL.Update();
                    }

                    double ShoppingAmount = Convert.ToDouble(Total_Price_HF.Value);
                    double CommissionAmount = Convert.ToDouble(Total_Commission_HF.Value);

                    Product_DistributionSQL.UpdateParameters["Sopping_Amount"].DefaultValue = (ShoppingAmount - CommissionAmount).ToString();
                    Product_DistributionSQL.Update();

                    Page.ClientScript.RegisterStartupScript(this.GetType(), "Rl", "RemoveCart();", true);
                    Response.Redirect("Receipt_Distributor.aspx?DistributorShoppingID=" + ViewState["DistributorShoppingID"].ToString());
                }
                else
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Invalid Seller')", true);
                }
            }
            else
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('No Product added in cart')", true);
            }
        }

        protected void Product_DistributionSQL_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            ViewState["DistributorShoppingID"] = e.Command.Parameters["@DistributorShoppingID"].Value.ToString();
        }
    }
}