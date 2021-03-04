using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace CncAgro.Handler
{
    public class HomePageSliderImage : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            var con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());
            var cmd = new SqlCommand("SELECT Image from Home_Slider where SliderID = @SliderID", con);
            cmd.Parameters.AddWithValue("@SliderID", context.Request.QueryString["id"]);

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