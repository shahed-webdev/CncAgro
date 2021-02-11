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
            if (!Page.IsPostBack)
            {
                Page.ClientScript.RegisterStartupScript(this.GetType(), "Rl", "RemoveCart();", true);
            }
        }

        //Customer
        [WebMethod]
        public static string GetCustomers(string prefix)
        {
            List<Member> User = new List<Member>();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "SELECT top(3) Registration.UserName, Registration.Name, Registration.Phone, Member.MemberID FROM Registration INNER JOIN  Member ON Registration.RegistrationID = Member.MemberRegistrationID WHERE Registration.UserName LIKE @UserName + '%'";
                    cmd.Parameters.AddWithValue("@UserName", prefix);
                    cmd.Connection = con;

                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    while (dr.Read())
                    {
                        User.Add(new Member
                        {
                            Username = dr["UserName"].ToString(),
                            Name = dr["Name"].ToString(),
                            Phone = dr["Phone"].ToString(),
                            MemberID = dr["MemberID"].ToString(),
                        });
                    }
                    con.Close();

                    var json = new JavaScriptSerializer().Serialize(User);
                    return json;
                }
            }
        }
        class Member
        {
            public string Username { get; set; }
            public string Name { get; set; }
            public string Phone { get; set; }
            public string MemberID { get; set; }
        }

        //Product
        [WebMethod]
        public static string GetProduct(string prefix)
        {
            List<Product> User = new List<Product>();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "SELECT TOP(3) Product_PointID, Product_Name, Product_Code, Product_Point, Product_Price, Stock_Quantity FROM Product_Point_Code WHERE (IsActive = 1) AND (Stock_Quantity > 0) AND (Product_Code LIKE @Product_Code + '%')";
                    cmd.Parameters.AddWithValue("@Product_Code", prefix);
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
                            Stock = dr["Stock_Quantity"].ToString(),
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
            public string ProductID { get; set; }
        }

        //shopping cart
        class Shopping
        {
            public string ProductID { get; set; }
            public int Quantity { get; set; }
            public string Unit_Price { get; set; }
            public string Unit_Point { get; set; }
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
                #region Check Stock
                bool Is_Available = true;
                List<Shopping> P_List = new List<Shopping>(ProductList());

                foreach (Shopping item in P_List)
                {
                    SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString);

                    SqlCommand cmd = new SqlCommand("SELECT Stock_Quantity FROM Product_Point_Code WHERE(IsActive = 1) AND (Product_PointID = @ProductID)", con);
                    cmd.Parameters.AddWithValue("@ProductID", item.ProductID);

                    con.Open();
                    int Stock = (int)cmd.ExecuteScalar();
                    con.Close();

                    if (Stock < item.Quantity)
                    {
                        Is_Available = false;
                    }
                }
                #endregion end


                if (Is_Available)
                {
                    #region Add Product

                    ShoppingSQL.Insert();

                    foreach (Shopping item in P_List)
                    {
                        Product_Selling_RecordsSQL.InsertParameters["ProductID"].DefaultValue = item.ProductID;
                        Product_Selling_RecordsSQL.InsertParameters["ShoppingID"].DefaultValue = ViewState["ShoppingID"].ToString();
                        Product_Selling_RecordsSQL.InsertParameters["SellingQuantity"].DefaultValue = item.Quantity.ToString();
                        Product_Selling_RecordsSQL.InsertParameters["SellingUnitPrice"].DefaultValue = item.Unit_Price;
                        Product_Selling_RecordsSQL.InsertParameters["SellingUnitPoint"].DefaultValue = item.Unit_Point;
                        Product_Selling_RecordsSQL.Insert();

                        SellerProductSQL.UpdateParameters["Product_PointID"].DefaultValue = item.ProductID;
                        SellerProductSQL.UpdateParameters["Stock_Quantity"].DefaultValue = item.Quantity.ToString();
                        SellerProductSQL.Update();
                    }
                    #endregion End Product

                    // Update S.P Add_Point
                    A_PointSQL.Insert();

                    // Update S.P Add_Retail_Income
                    Retail_IncomeSQL.Insert();

                    GTpriceHF.Value = "";
                    GTpointHF.Value = "";
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "Rl", "RemoveCart()", true);

                    Response.Redirect("Receipt.aspx?ShoppingID=" + ViewState["ShoppingID"].ToString());
                }
                else
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Selling quantity more than stock quantity!!')", true);
                }
            }
            else
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('No Product added in cart')", true);
            }
        }

        protected void ShoppingSQL_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            ViewState["ShoppingID"] = e.Command.Parameters["@ShoppingID"].Value.ToString();
        }
    }
}