using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;

namespace CncAgro.Handler
{
    public class UserPhoto : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            var con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());
            var cmd = new SqlCommand("SELECT Image from Registration where RegistrationID = @RegistrationID", con);
            cmd.Parameters.AddWithValue("@RegistrationID", context.Request.QueryString["id"]);

            con.Open();
            var reader = cmd.ExecuteReader(CommandBehavior.CloseConnection);

            if (reader.Read())
            {
                if (reader.GetValue(0) != DBNull.Value)
                    context.Response.BinaryWrite((byte[])reader.GetValue(0));
                else
                    context.Response.BinaryWrite(File.ReadAllBytes(context.Server.MapPath("~/CSS/Image/Defualt_image.png")));
            }
            else
                context.Response.BinaryWrite(File.ReadAllBytes(context.Server.MapPath("~/CSS/Image/Defualt_image.png")));

            reader.Close();
            context.Response.End();
            con.Close();
        }

        public bool IsReusable => false;
    }
}