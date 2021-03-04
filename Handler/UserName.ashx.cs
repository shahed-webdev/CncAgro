using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text;
using System.Web;

namespace CncAgro.Handler
{
    /// <summary>
    /// Summary description for UserName
    /// </summary>
    public class UserName : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string prefixText = context.Request.QueryString["q"];
            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "SELECT Registration.UserName FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE Registration.UserName like @UserName + '%'";
                    cmd.Parameters.AddWithValue("@UserName", prefixText);

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