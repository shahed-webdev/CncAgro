using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace CncAgro.Handler
{
    public class HomePageProductImage : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            var con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());
            var cmd = new SqlCommand("SELECT Product_Image from Home_Product where ProductID = @ProductID", con);
            cmd.Parameters.AddWithValue("@ProductID", context.Request.QueryString["id"]);

            con.Open();
            var reader = cmd.ExecuteReader(CommandBehavior.CloseConnection);

            if (reader.Read())
            {
                if (reader.GetValue(0) != DBNull.Value)
                    context.Response.BinaryWrite((byte[])reader.GetValue(0));
            }

            reader.Close();
            con.Close();
            context.Response.End();
        }

        public bool IsReusable => false;
    }
}