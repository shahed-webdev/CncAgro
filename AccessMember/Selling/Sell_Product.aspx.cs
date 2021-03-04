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
                    cmd.CommandText = "SELECT top(3) Product_Point_Code.Product_Code, Product_Point_Code.Product_Name, Product_Point_Code.Product_Price, Product_Point_Code.Product_Point, Product_Point_Code.Product_PointID, MemberProduct.ProductStock FROM Product_Point_Code INNER JOIN MemberProduct ON Product_Point_Code.Product_PointID = MemberProduct.Product_PointID WHERE MemberProduct.MemberID = @MemberID AND MemberProduct.ProductStock > 0 AND Product_Point_Code.Product_Code LIKE @Product_Code + '%'";
                    cmd.Parameters.AddWithValue("@Product_Code", prefix);
                    cmd.Parameters.AddWithValue("@MemberID", HttpContext.Current.Session["MemberID"].ToString());
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
                            Stock = dr["ProductStock"].ToString(),
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

                    SqlCommand cmd = new SqlCommand("SELECT SellerProduct_Stock FROM Seller_Product WHERE(Product_PointID = @ProductID) AND(SellerID = @SellerID)", con);
                    cmd.Parameters.AddWithValue("@ProductID", item.ProductID);
                    cmd.Parameters.AddWithValue("@SellerID", Session["SellerID"].ToString());

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
                    SellerUpdateSQL.Update();

                    foreach (Shopping item in P_List)
                    {
                        Product_Selling_RecordsSQL.InsertParameters["ProductID"].DefaultValue = item.ProductID;
                        Product_Selling_RecordsSQL.InsertParameters["ShoppingID"].DefaultValue = ViewState["ShoppingID"].ToString();
                        Product_Selling_RecordsSQL.InsertParameters["SellingQuantity"].DefaultValue = item.Quantity.ToString();
                        Product_Selling_RecordsSQL.InsertParameters["SellingUnitPrice"].DefaultValue = item.Unit_Price;
                        Product_Selling_RecordsSQL.InsertParameters["SellingUnitPoint"].DefaultValue = item.Unit_Point;
                        Product_Selling_RecordsSQL.Insert();

                        SellerProductSQL.UpdateParameters["Product_PointID"].DefaultValue = item.ProductID;
                        SellerProductSQL.UpdateParameters["SellerProduct_Stock"].DefaultValue = item.Quantity.ToString();
                        SellerProductSQL.Update();
                    }
                    #endregion End Product

                    // Update S.P Add_Point
                    A_PointSQL.Insert();

                    // Update S.P Add_Referral_Bonus
                    A_PointSQL.Update();

                    //Package Update
                    Package_UpdateSQL.Update();

                    if (Generation_Type_RadioB.SelectedValue == "G")
                    {
                        // Update S.P Add_Generation_UniLevel
                        GenerationSQL.Update();
                    }
                    else
                    {
                        // Update S.P Add_Generation_Retail
                        GenerationSQL.Insert();
                    }

                    // AutoPlan
                    AutoPlan_SQL.Insert();


                    // Update S.P Add_Designation_Loop
                    AutoPlan_SQL.Update();


                    //Seller commission S.P
                    Seller_ComissionSQL.InsertParameters["ShoppingID"].DefaultValue = ViewState["ShoppingID"].ToString();
                    Seller_ComissionSQL.Insert();

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