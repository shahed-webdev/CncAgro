using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;
using System.Web.UI;

namespace CncAgro
{
    public partial class Manage_Slider_Product : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager.GetCurrent(this)?.RegisterPostBackControl(this.SubmitButton);
            ScriptManager.GetCurrent(this)?.RegisterPostBackControl(this.ProductButton);
        }

        protected void SubmitButton_Click(object sender, EventArgs e)
        {
            var con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());

            // Check file exist or not  
            if (Slider_FileUpload.PostedFile != null)
            {
                // Check the extension of image  
                var extension = Path.GetExtension(Slider_FileUpload.FileName);
                const int newWidth = 800;
                const int newHeight = 400; // New Height of Image in Pixel  

                if (extension != null && (extension.ToLower() == ".png" || extension.ToLower() == ".jpg"))
                {
                    var inputStream = Slider_FileUpload.PostedFile.InputStream;
                    using (var uploadImage = Image.FromStream(inputStream))
                    {
                        var thumbImg = new Bitmap(newWidth, newHeight);
                        var thumbGraph = Graphics.FromImage(thumbImg);

                        thumbGraph.CompositingQuality = CompositingQuality.HighQuality;
                        thumbGraph.SmoothingMode = SmoothingMode.HighQuality;
                        thumbGraph.InterpolationMode = InterpolationMode.HighQualityBicubic;
                        var imgRectangle = new Rectangle(0, 0, newWidth, newHeight);
                        var stream = new MemoryStream();
                        thumbGraph.DrawImage(uploadImage, imgRectangle);

                        // Save the file  
                        thumbImg.Save(stream, System.Drawing.Imaging.ImageFormat.Jpeg);
                        stream.Position = 0;
                        var image = new byte[stream.Length + 1];
                        stream.Read(image, 0, image.Length);

                        // Create SQL Command
                        var cmd = new SqlCommand
                        {
                            CommandText = "INSERT INTO Home_Slider (Image,Description) VALUES (@Image,@Description)",
                            CommandType = CommandType.Text,
                            Connection = con
                        };

                        var uploadedImage = new SqlParameter("@Image", SqlDbType.Image, image.Length);
                        cmd.Parameters.AddWithValue("@Description", CaptionTextBox.Text);
                        uploadedImage.Value = image;
                        cmd.Parameters.Add(uploadedImage);

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();

                    }
                }
            }

            SliderGridView.DataBind();
        }

        protected void ProductButton_Click(object sender, EventArgs e)
        {
            ProductSQL.Insert();
            var con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());

            // Check file exist or not  
            if (Product_FileUpload.PostedFile != null)
            {
                // Check the extension of image  
                var extension = Path.GetExtension(Product_FileUpload.FileName);
                if (extension != null && (extension.ToLower() == ".png" || extension.ToLower() == ".jpg" || extension.ToLower() == ".jpeg"))
                {
                    var inputStream = Product_FileUpload.PostedFile.InputStream;
                    using (var uploadImage = Image.FromStream(inputStream))
                    {
                        const int newWidth = 200; // New Width of Image in Pixel  
                        const int newHeight = 200; // New Height of Image in Pixel  

                        var thumbImg = new Bitmap(newWidth, newHeight);
                        var thumbGraph = Graphics.FromImage(thumbImg);

                        thumbGraph.CompositingQuality = CompositingQuality.HighQuality;
                        thumbGraph.SmoothingMode = SmoothingMode.HighQuality;
                        thumbGraph.InterpolationMode = InterpolationMode.HighQualityBicubic;
                        var imgRectangle = new Rectangle(0, 0, newWidth, newHeight);
                        var stream = new MemoryStream();
                        thumbGraph.DrawImage(uploadImage, imgRectangle);

                        // Save the file  
                        thumbImg.Save(stream, System.Drawing.Imaging.ImageFormat.Jpeg);
                        stream.Position = 0;
                        var image = new byte[stream.Length + 1];
                        stream.Read(image, 0, image.Length);

                        // Create SQL Command
                        var cmd = new SqlCommand
                        {
                            CommandText = "UPDATE Home_Product SET Product_Image = @Image WHERE (ProductID = (select IDENT_CURRENT('Home_Product')))",
                            CommandType = CommandType.Text,
                            Connection = con
                        };

                        var uploadedImage = new SqlParameter("@Image", SqlDbType.Image, image.Length) { Value = image };

                        cmd.Parameters.Add(uploadedImage);

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                }
            }

            ProductGridView.DataBind();
        }
    }
}