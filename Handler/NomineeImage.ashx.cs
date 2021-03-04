using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;

namespace CncAgro.Handler
{
    /// <summary>
    /// Summary description for NomineeImage
    /// </summary>
    public class NomineeImage : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            var con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());

            con.Open();
            var cmd = new SqlCommand("SELECT Nominee_Image from Member where MemberID = @MemberID", con);
            cmd.Parameters.AddWithValue("@MemberID", context.Request.QueryString["id"]);
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