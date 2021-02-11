using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI.WebControls;

namespace CncAgro.AccessAdmin
{
    public partial class Add_Product_Point : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                DataTable ChargeTeble = new DataTable();
                ChargeTeble.Columns.AddRange(new DataColumn[3] { new DataColumn("PID"), new DataColumn("ProductCOde"), new DataColumn("Quantity") });
                ViewState["ChargeTeble"] = ChargeTeble;
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
                DataTable ChargeTeble = ViewState["ChargeTeble"] as DataTable;
                ChargeTeble.Rows.Add(ProductID_HF.Value, ProductCode_HF.Value, Update_Quantity_TextBox.Text);
                ViewState["ChargeTeble"] = ChargeTeble;
                this.BindGrid();

                ProductID_HF.Value = "";
                ProductCodeTextBox.Text = string.Empty;
                Update_Quantity_TextBox.Text = string.Empty;
            }
            else
            {
                ProductCodeTextBox.Text = string.Empty;
                Update_Quantity_TextBox.Text = string.Empty;
            }
        }


        [WebMethod]
        public static string GetProduct(string prefix)
        {
            List<Product> User = new List<Product>();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "SELECT top(4) Product_Code, Product_Price, Product_Point, Product_PointID FROM  Product_Point_Code WHERE Product_Code LIKE @Product_Code + '%'";
                    cmd.Parameters.AddWithValue("@Product_Code", prefix);
                    cmd.Connection = con;

                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    while (dr.Read())
                    {
                        User.Add(new Product
                        {
                            Code = dr["Product_Code"].ToString(),
                            Price = dr["Product_Price"].ToString(),
                            Point = dr["Product_Point"].ToString(),
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
            public string Price { get; set; }
            public string Point { get; set; }
            public string ProductID { get; set; }
        }
        protected void Add_Product_Button_Click(object sender, EventArgs e)
        {
            Product_PointSQL.Insert();
            Response.Redirect(Request.Url.AbsolutePath);
        }

        protected void Add_Stock_Button_Click(object sender, EventArgs e)
        {
            foreach (GridViewRow row in ChargeGridView.Rows)
            {
                Label ProductIDLabel = row.FindControl("PIDLabel") as Label;
                Label QntLabel = row.FindControl("QntLabel") as Label;

                Product_Stock_RecordSQL.InsertParameters["Product_PointID"].DefaultValue = ProductIDLabel.Text;
                Product_Stock_RecordSQL.InsertParameters["Added_Quantity"].DefaultValue = QntLabel.Text;
                Product_Stock_RecordSQL.Insert();

                Product_Stock_RecordSQL.UpdateParameters["Product_PointID"].DefaultValue = ProductIDLabel.Text;
                Product_Stock_RecordSQL.UpdateParameters["Stock_Quantity"].DefaultValue = QntLabel.Text;
                Product_Stock_RecordSQL.Update();
            }

            Response.Redirect(Request.Url.AbsoluteUri);
        }

        protected void SelectCheckBox_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox cb = (CheckBox)sender;
            GridViewRow row = (GridViewRow)cb.NamingContainer;

            ShortListSQL.UpdateParameters["IsActive"].DefaultValue = cb.Checked.ToString();
            ShortListSQL.UpdateParameters["Product_PointID"].DefaultValue = ProductGridView.DataKeys[row.RowIndex]["Product_PointID"].ToString();
            ShortListSQL.Update();
        }
    }
}