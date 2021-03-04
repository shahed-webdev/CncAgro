using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.SessionState;

namespace CncAgro.Handler
{
    public class Tree_UserName : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            string prefixText = context.Request.QueryString["q"];
            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "EXEC [dbo].[Add_Tree_Member] @MemberID = @MID, @UserName = @UN";
                    cmd.Parameters.AddWithValue("@UN", prefixText);
                    cmd.Parameters.AddWithValue("@MID", context.Session["MemberID"].ToString());

                    cmd.Connection = conn;
                    StringBuilder sb = new StringBuilder();
                    conn.Open();

                    using (SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        while (sdr.Read())
                        {
                            sb.Append(sdr["UserName"]).Append(Environment.NewLine);
                        }
                    }
                    conn.Close();

                    if (!string.IsNullOrEmpty(sb.ToString()))
                    {
                        context.Response.Write(sb.ToString());
                    }
                    else
                    {
                        context.Response.Write(" ");
                    }
                }
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}