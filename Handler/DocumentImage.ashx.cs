using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;

namespace DnbBD.Handler
{
    /// <summary>
    /// Summary description for DocumentImage
    /// </summary>
    public class DocumentImage : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            var con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());

            con.Open();
            var cmd = new SqlCommand("select Document_Image from Member where MemberID = @MemberID", con);
            cmd.Parameters.AddWithValue("@MemberID", context.Request.QueryString["id"]);
            var reader = cmd.ExecuteReader(CommandBehavior.CloseConnection);

            if (reader.Read())
            {
                if (reader.GetValue(0) != DBNull.Value)
                    context.Response.BinaryWrite((byte[])reader.GetValue(0));
                else
                    context.Response.BinaryWrite(File.ReadAllBytes(context.Server.MapPath("")));
            }
            else
                context.Response.BinaryWrite(File.ReadAllBytes(context.Server.MapPath("")));

            reader.Close();
            context.Response.End();
            con.Close();
        }

        public bool IsReusable => false;
    }
}