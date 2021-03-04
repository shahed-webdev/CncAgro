using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Web.UI.WebControls;

namespace CncAgro.AccessMember
{
    public partial class MemberProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void MemberFormView_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
        {
            var con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());

            var memberFileUpload = (FileUpload)MemberFormView.FindControl("MemberFileUpload");

            //Member Image
            if (memberFileUpload.PostedFile == null || memberFileUpload.PostedFile.FileName == "") return;

            var strExtension = Path.GetExtension(memberFileUpload.FileName);
            if (!((strExtension.ToUpper() == ".JPG") || (strExtension.ToUpper() == ".JPEG") || (strExtension.ToUpper() == ".PNG"))) return;

            // Resize Image Before Uploading to DataBase
            var imageToBeResized = System.Drawing.Image.FromStream(memberFileUpload.PostedFile.InputStream);
            var imageHeight = imageToBeResized.Height;
            var imageWidth = imageToBeResized.Width;

            const int maxHeight = 200;
            const int maxWidth = 180;

            imageHeight = (imageHeight * maxWidth) / imageWidth;
            imageWidth = maxWidth;

            if (imageHeight > maxHeight)
            {
                imageWidth = (imageWidth * maxHeight) / imageHeight;
                imageHeight = maxHeight;
            }

            var bitmap = new Bitmap(imageToBeResized, imageWidth, imageHeight);
            var stream = new MemoryStream();
            bitmap.Save(stream, System.Drawing.Imaging.ImageFormat.Jpeg);
            stream.Position = 0;
            var image = new byte[stream.Length + 1];
            stream.Read(image, 0, image.Length);


            // Create SQL Command
            var cmd = new SqlCommand
            {
                CommandText = "UPDATE Registration SET Image = @Image Where RegistrationID = @RegistrationID"
            };
            cmd.Parameters.AddWithValue("@RegistrationID", MemberFormView.DataKey["RegistrationID"].ToString());

            cmd.CommandType = CommandType.Text;
            cmd.Connection = con;

            var uploadedImage = new SqlParameter("@Image", SqlDbType.Image, image.Length) {Value = image};
            cmd.Parameters.Add(uploadedImage);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
        }
    }
}