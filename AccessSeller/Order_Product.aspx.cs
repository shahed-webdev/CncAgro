using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;

namespace CncAgro.AccessSeller
{
    public partial class Order_Product : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static void Set_Product(List<Product> List_Product, double totalPrice, double totalCommission, double totalPoint)
        {
            string SellerID = HttpContext.Current.Session["SellerID"].ToString();

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString);

            SqlCommand Distribution_cmd = new SqlCommand("INSERT INTO Product_Distribution (SellerID, Product_Total_Amount, Product_Total_Point, Distribution_SN, Commission_Amount,Is_Seller_Order)VALUES (@SellerID,@Product_Total_Amount,@Product_Total_Point, dbo.Distribution_SerialNumber(),@Commission_Amount,1) SELECT Scope_identity()", con);
            Distribution_cmd.Parameters.AddWithValue("@SellerID", SellerID);
            Distribution_cmd.Parameters.AddWithValue("@Product_Total_Amount", totalPrice);
            Distribution_cmd.Parameters.AddWithValue("@Commission_Amount", totalCommission);
            Distribution_cmd.Parameters.AddWithValue("@Product_Total_Point", totalPoint);


            SqlCommand SellerBuying_cmd = new SqlCommand("UPDATE Seller SET Buying_Amount = Buying_Amount + (@Product_Total_Amount - @Commission_Amount) WHERE (SellerID = @SellerID)", con);
            SellerBuying_cmd.Parameters.AddWithValue("@SellerID", SellerID);
            SellerBuying_cmd.Parameters.AddWithValue("@Product_Total_Amount", totalPrice);
            SellerBuying_cmd.Parameters.AddWithValue("@Commission_Amount", totalCommission);

            con.Open();
            string DistributionID = Distribution_cmd.ExecuteScalar().ToString();
            SellerBuying_cmd.ExecuteScalar();
            con.Close();

            for (int i = 0; i < List_Product.Count; i++)
            {
                SqlCommand Distribution_Records_cmd = new SqlCommand("INSERT INTO Product_Distribution_Records(Product_DistributionID, ProductID, SellingQuantity, SellingUnitPrice, SellingUnitPoint, SellingUnit_Commission) VALUES (@Product_DistributionID, @ProductID, @SellingQuantity, @SellingUnitPrice, @SellingUnitPoint, @SellingUnit_Commission)", con);
                SqlCommand Product_cmd = new SqlCommand("UPDATE Product_Point_Code SET Order_Quantity = Order_Quantity + @Order_Quantity WHERE (Product_PointID = @ProductID)", con);

                Product P_Detail = List_Product[i];

                Distribution_Records_cmd.Parameters.AddWithValue("@Product_DistributionID", DistributionID);
                Distribution_Records_cmd.Parameters.AddWithValue("@ProductID", P_Detail.ProductID);
                Distribution_Records_cmd.Parameters.AddWithValue("@SellingQuantity", P_Detail.Quantity);
                Distribution_Records_cmd.Parameters.AddWithValue("@SellingUnitPrice", P_Detail.UnitPrice);
                Distribution_Records_cmd.Parameters.AddWithValue("@SellingUnitPoint", P_Detail.UnitPoint);
                Distribution_Records_cmd.Parameters.AddWithValue("@SellingUnit_Commission", P_Detail.UnitCommission);


                Product_cmd.Parameters.AddWithValue("@Order_Quantity", P_Detail.Quantity);
                Product_cmd.Parameters.AddWithValue("@ProductID", P_Detail.ProductID);
                con.Open();
                Distribution_Records_cmd.ExecuteScalar();
                Product_cmd.ExecuteScalar();
                con.Close();
            }
        }
        public class Product
        {
            public string ProductID { get; set; }
            public string Quantity { get; set; }
            public string UnitPrice { get; set; }
            public string UnitPoint { get; set; }
            public string UnitCommission { get; set; }
        }
    }
}