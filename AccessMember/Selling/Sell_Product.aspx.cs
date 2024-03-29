﻿using System;
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
                    cmd.CommandText = "SELECT top(3) Registration.UserName, Registration.Name, Registration.Phone, Member.MemberID FROM Registration INNER JOIN  Member ON Registration.RegistrationID = Member.MemberRegistrationID WHERE Member.MemberID <> @MemberID AND Registration.UserName LIKE @UserName + '%'";
                    cmd.Parameters.AddWithValue("@MemberID", HttpContext.Current.Session["MemberID"].ToString());
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
                    cmd.CommandText = "SELECT top(3) Product_Point_Code.Product_Code, Product_Point_Code.Product_Name, Product_Point_Code.Product_Price, Product_Point_Code.Product_Point, Product_Point_Code.Product_PointID, MemberProduct.ProductStock FROM Product_Point_Code INNER JOIN MemberProduct ON Product_Point_Code.Product_PointID = MemberProduct.Product_PointID WHERE MemberProduct.MemberID = @MemberID AND MemberProduct.ProductStock > 0 AND Product_Point_Code.Product_Code LIKE @Product_Code + '%'";
                    cmd.Parameters.AddWithValue("@Product_Code", prefix);
                    cmd.Parameters.AddWithValue("@MemberID", HttpContext.Current.Session["MemberID"].ToString());
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
                            Stock = Convert.ToDouble(dr["ProductStock"]),
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
                var con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"]
                    .ConnectionString);

                var cmd = new SqlCommand(
                    "SELECT ProductStock FROM MemberProduct WHERE(Product_PointID = @ProductID) AND(MemberID = @MemberID)",
                    con);
                cmd.Parameters.AddWithValue("@ProductID", item.ProductID);
                cmd.Parameters.AddWithValue("@MemberID", Session["MemberID"].ToString());

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

                    MemberProductSQL.UpdateParameters["Product_PointID"].DefaultValue = item.ProductID;
                    MemberProductSQL.UpdateParameters["ProductStock"].DefaultValue = item.Quantity.ToString();
                    MemberProductSQL.Update();
                }

                #endregion End Product

                // Update S.P Add_Retail_Income
                RetailSQL.Update();

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