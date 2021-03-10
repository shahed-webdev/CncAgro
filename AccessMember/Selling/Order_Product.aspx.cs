using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;

namespace CncAgro.AccessMember.Selling
{
    public partial class Order_Product : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string PostOderProduct(List<Product> listProduct, double totalPrice)
        {
            var memberId = HttpContext.Current.Session["MemberID"].ToString();

            var con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString);

            var distributionCmd = new SqlCommand("INSERT INTO Product_Distribution (MemberID, Product_Total_Amount, Product_Total_Point, Distribution_SN) VALUES (@MemberID,@Product_Total_Amount,@Product_Total_Point, dbo.Distribution_SerialNumber()) SELECT Scope_identity()", con);
            distributionCmd.Parameters.AddWithValue("@MemberID", memberId);
            distributionCmd.Parameters.AddWithValue("@Product_Total_Amount", totalPrice);
            distributionCmd.Parameters.AddWithValue("@Product_Total_Point", totalPrice);

            con.Open();
            var distributionId = distributionCmd.ExecuteScalar().ToString();
            con.Close();

            foreach (var product in listProduct)
            {
                var distributionRecordsCmd = new SqlCommand("INSERT INTO Product_Distribution_Records(Product_DistributionID, ProductID, SellingQuantity, SellingUnitPrice, SellingUnitPoint) VALUES (@Product_DistributionID, @ProductID, @SellingQuantity, @SellingUnitPrice, @SellingUnitPoint)", con);
                var productCmd = new SqlCommand("UPDATE Product_Point_Code SET Order_Quantity = Order_Quantity + @Order_Quantity WHERE (Product_PointID = @ProductID)", con);

                distributionRecordsCmd.Parameters.AddWithValue("@Product_DistributionID", distributionId);
                distributionRecordsCmd.Parameters.AddWithValue("@ProductID", product.ProductID);
                distributionRecordsCmd.Parameters.AddWithValue("@SellingQuantity", product.Quantity);
                distributionRecordsCmd.Parameters.AddWithValue("@SellingUnitPrice", product.UnitPrice);
                distributionRecordsCmd.Parameters.AddWithValue("@SellingUnitPoint", product.UnitPoint);

                productCmd.Parameters.AddWithValue("@Order_Quantity", product.Quantity);
                productCmd.Parameters.AddWithValue("@ProductID", product.ProductID);

                con.Open();
                distributionRecordsCmd.ExecuteScalar();
                productCmd.ExecuteScalar();
                con.Close();
            }

            return distributionId;

        }

        public class Product
        {
            public string ProductID { get; set; }
            public string Quantity { get; set; }
            public string UnitPrice { get; set; }
            public string UnitPoint { get; set; }
        }
    }
}