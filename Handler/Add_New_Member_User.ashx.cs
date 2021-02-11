using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text;
using System.Web;

namespace CncAgro.Handler
{
    /// <summary>
    /// Summary description for Add_New_Member_User
    /// </summary>
    public class Add_New_Member_User : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            var prefixText = context.Request.QueryString["q"];
            using (var conn = new SqlConnection())
            {
                conn.ConnectionString = ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString;
                using (var cmd = new SqlCommand())
                {
                    cmd.CommandText = "SELECT Registration.UserName FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE ((Member.Left_Status = 0) OR (Member.Right_Status = 0)) AND Registration.UserName like @UserName + '%'";
                    cmd.Parameters.AddWithValue("@UserName", prefixText);

                    cmd.Connection = conn;
                    var sb = new StringBuilder();
                    conn.Open();

                    using (var sdr = cmd.ExecuteReader())
                    {
                        while (sdr.Read())
                        {
                            sb.Append(sdr["UserName"]).Append(Environment.NewLine);
                        }
                    }
                    conn.Close();

                    context.Response.Write(!string.IsNullOrEmpty(sb.ToString()) ? sb.ToString() : " ");
                }
            }
        }

        public bool IsReusable => false;
    }
}