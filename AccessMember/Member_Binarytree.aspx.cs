using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;

namespace CncAgro.AccessMember
{
    public partial class Member_Binarytree : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(Request.QueryString["M"]))
            {

                Response.Redirect("MemberProfile.aspx");
            }
            else
            {
                if (Session["MemberID"].ToString() != Request.QueryString["M"])
                {
                    SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());

                    SqlCommand TreeMemberCheck_cmd = new SqlCommand("SELECT [dbo].[fn_TreeMember_Check](@MemberID, @TreeMemberID)", con);

                    TreeMemberCheck_cmd.Parameters.AddWithValue("@MemberID", Session["MemberID"].ToString());
                    TreeMemberCheck_cmd.Parameters.AddWithValue("@TreeMemberID", Request.QueryString["M"]);
                    con.Open();
                    string M_Check = TreeMemberCheck_cmd.ExecuteScalar().ToString();
                    con.Close();

                    if (M_Check == "0")
                    {
                        Response.Redirect("MemberProfile.aspx");
                    }
                }

            }
        }

        protected void FindButton_Click(object sender, EventArgs e)
        {
            string MID = "";
            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "EXEC [dbo].[Add_Tree_Member_Show] @MemberID = @MID, @UserName = @UN";
                    cmd.Parameters.AddWithValue("@UN", UserIDTextBox.Text);
                    cmd.Parameters.AddWithValue("@MID", Session["MemberID"].ToString());

                    cmd.Connection = conn;

                    conn.Open();
                    using (SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        while (sdr.Read())
                        {
                            MID = sdr["MemberID"].ToString();
                        }
                    }
                    conn.Close();

                }
            }

            if (MID != "")
            {
                Response.Redirect("Member_Binarytree.aspx?M=" + MID);
            }
            else
            {

            }
        }

        protected void Down_Left_Button_Click(object sender, EventArgs e)
        {
            if (ML_FormView.DataKey["MemberID"] != null)
                Response.Redirect("Member_Binarytree.aspx?M=" + ML_FormView.DataKey["MemberID"].ToString());

        }

        protected void Down_Right_Button_Click(object sender, EventArgs e)
        {
            if (MR_FormView.DataKey["MemberID"] != null)
                Response.Redirect("Member_Binarytree.aspx?M=" + MR_FormView.DataKey["MemberID"].ToString());

        }

        protected void Tom_MemberButton_Click(object sender, EventArgs e)
        {
            if (Session["MemberID"] != null)
                Response.Redirect("Member_Binarytree.aspx?M=" + Session["MemberID"].ToString());
        }


        [WebMethod]
        public static string Get_Tree_UserID(string prefix)
        {
            List<string> User = new List<string>();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "EXEC [dbo].[Add_Tree_Member] @MemberID = @MID, @UserName = @UN";
                    cmd.Parameters.AddWithValue("@UN", prefix);
                    cmd.Parameters.AddWithValue("@MID", HttpContext.Current.Session["MemberID"].ToString());
                    cmd.Connection = con;

                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    while (dr.Read())
                    {
                        User.Add(dr["UserName"].ToString());
                    }
                    con.Close();

                    var json = new JavaScriptSerializer().Serialize(User);
                    return json;
                }
            }
        }
    }
}