using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CncAgro.AccessAdmin.Product_Point
{
    public partial class Sell_Product : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        //Customer
        [WebMethod]
        public static string GetCustomers(string prefix)
        {
            var user = new List<Member>();
            using (var con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString))
            {
                using (var cmd = new SqlCommand())
                {
                    cmd.CommandText = "SELECT top(3) Registration.UserName, Registration.Name, Registration.Phone, Member.MemberID FROM Registration INNER JOIN  Member ON Registration.RegistrationID = Member.MemberRegistrationID WHERE Registration.UserName LIKE @UserName + '%'";
                    cmd.Parameters.AddWithValue("@UserName", prefix);
                    cmd.Connection = con;

                    con.Open();
                    var dr = cmd.ExecuteReader();

                    while (dr.Read())
                    {
                        user.Add(new Member
                        {
                            UserName = dr["UserName"].ToString(),
                            Name = dr["Name"].ToString(),
                            Phone = dr["Phone"].ToString(),
                            MemberID = dr["MemberID"].ToString(),
                        });
                    }
                    con.Close();

                    var json = new JavaScriptSerializer().Serialize(user);
                    return json;
                }
            }
        }
        private class Member
        {
            public string UserName { get; set; }
            public string Name { get; set; }
            public string Phone { get; set; }
            public string MemberID { get; set; }
        }

        //Product
        [WebMethod]
        public static string GetProduct(string prefix)
        {
            var user = new List<Product>();
            using (var con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString))
            {
                using (var cmd = new SqlCommand())
                {
                    cmd.CommandText = "SELECT TOP(3) Product_PointID, Product_Name, Product_Code, Product_Point, Product_Price, Stock_Quantity FROM Product_Point_Code WHERE (IsActive = 1) AND (Stock_Quantity > 0) AND (Product_Code LIKE @Product_Code + '%')";
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
                            Price = Convert.ToDouble(dr["Product_Price"]),
                            Point = Convert.ToDouble(dr["Product_Point"]),
                            Stock = Convert.ToDouble(dr["Stock_Quantity"]),
                            ProductID = Convert.ToInt32(dr["Product_PointID"])
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
            public double Price { get; set; }
            public double Point { get; set; }
            public double Stock { get; set; }
            public int ProductID { get; set; }
        }

        //shopping cart
        public class Shopping
        {
            public string ProductID { get; set; }
            public int Quantity { get; set; }
            public string Price { get; set; }
            public string Point { get; set; }
        }

        public IEnumerable<Shopping> ProductList()
        {
            var json = JsonData.Value;
            var js = new JavaScriptSerializer();
            var data = js.Deserialize<List<Shopping>>(json);
            return data;
        }

        protected void SellButton_Click(object sender, EventArgs e)
        {
            //check member id is null
            if (string.IsNullOrEmpty(HiddenMemberId.Value))
            {
                ErrorLabel.Text = "Invalid customer";
                return;
            }

            //check product is null
            if (string.IsNullOrEmpty(JsonData.Value))
            {
                ErrorLabel.Text = "No Product added in cart";
                return;
            }

            #region Check Stock

            var isAvailable = true;
            var pList = new List<Shopping>(ProductList());

            foreach (var item in pList)
            {
                var con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString);

                var cmd = new SqlCommand("SELECT Stock_Quantity FROM Product_Point_Code WHERE(IsActive = 1) AND (Product_PointID = @ProductID)", con);
                cmd.Parameters.AddWithValue("@ProductID", item.ProductID);

                con.Open();
                var stock = (int) cmd.ExecuteScalar();
                con.Close();

                if (stock < item.Quantity)
                {
                    isAvailable = false;
                }
            }

            #endregion end

            if (isAvailable)
            {
                #region Add Product

                ShoppingSQL.Insert();

                foreach (var item in pList)
                {
                    Product_Selling_RecordsSQL.InsertParameters["ProductID"].DefaultValue = item.ProductID;
                    Product_Selling_RecordsSQL.InsertParameters["ShoppingID"].DefaultValue = ViewState["ShoppingID"].ToString();
                    Product_Selling_RecordsSQL.InsertParameters["SellingQuantity"].DefaultValue = item.Quantity.ToString();
                    Product_Selling_RecordsSQL.InsertParameters["SellingUnitPrice"].DefaultValue = item.Price;
                    Product_Selling_RecordsSQL.InsertParameters["SellingUnitPoint"].DefaultValue = item.Point;
                    Product_Selling_RecordsSQL.Insert();

                    SellerProductSQL.UpdateParameters["Product_PointID"].DefaultValue = item.ProductID;
                    SellerProductSQL.UpdateParameters["Stock_Quantity"].DefaultValue = item.Quantity.ToString();
                    SellerProductSQL.Update();
                }

                #endregion End Product

                // Update S.P Add_Retail_Income
                Retail_IncomeSQL.Insert();

                HiddenGrandTotalAmount.Value = "";

                Response.Redirect($"Receipt.aspx?ShoppingID={ViewState["ShoppingID"]}");
            }
            else
            {
                ErrorLabel.Text = "Selling quantity more than stock quantity";
            }
        }

        protected void ShoppingSQL_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            ViewState["ShoppingID"] = e.Command.Parameters["@ShoppingID"].Value.ToString();
        }
    }
}