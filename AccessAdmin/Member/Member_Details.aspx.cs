using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CncAgro.AccessAdmin.Member
{
    public partial class Member_Details : System.Web.UI.Page
    {
        public static string memberID { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            memberID = Request.QueryString["member"];

            if (string.IsNullOrEmpty(Request.QueryString["member"]))
            {
                Response.Redirect("Member_List.aspx");
            }

            if (!Page.IsPostBack)
            {
                DataView dv = (DataView)LeftSQL.Select(DataSourceSelectArguments.Empty);
                L_Total_Label.Text = "Left Customers: " + dv.Count.ToString();

                DataView dv2 = (DataView)RightSQL.Select(DataSourceSelectArguments.Empty);
                R_Total_Label.Text = "Right Customers: " + dv2.Count.ToString();
            }
        }


        protected void L_FindButton_Click(object sender, EventArgs e)
        {
            DataView dv = (DataView)LeftSQL.Select(DataSourceSelectArguments.Empty);
            L_Total_Label.Text = "Left Customers: " + dv.Count.ToString();
        }
        protected void R_Find_Button_Click(object sender, EventArgs e)
        {
            DataView dv2 = (DataView)RightSQL.Select(DataSourceSelectArguments.Empty);
            R_Total_Label.Text = "Right Customers: " + dv2.Count.ToString();
        }



        protected void MemberDetailsFormView_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());
            FileUpload MemberFileUpload = (FileUpload)MemberDetailsFormView.FindControl("ImageFileUpload");

            //Member Image
            if (MemberFileUpload.PostedFile != null && MemberFileUpload.PostedFile.FileName != "")
            {
                string strExtension = System.IO.Path.GetExtension(MemberFileUpload.FileName);
                if ((strExtension.ToUpper() == ".JPG") || (strExtension.ToUpper() == ".JPEG") || (strExtension.ToUpper() == ".PNG"))
                {
                    // Resize Image Before Uploading to DataBase
                    System.Drawing.Image imageToBeResized = System.Drawing.Image.FromStream(MemberFileUpload.PostedFile.InputStream);
                    int imageHeight = imageToBeResized.Height;
                    int imageWidth = imageToBeResized.Width;

                    int maxHeight = 150;
                    int maxWidth = 200;

                    imageHeight = (imageHeight * maxWidth) / imageWidth;
                    imageWidth = maxWidth;

                    if (imageHeight > maxHeight)
                    {
                        imageWidth = (imageWidth * maxHeight) / imageHeight;
                        imageHeight = maxHeight;
                    }

                    Bitmap bitmap = new Bitmap(imageToBeResized, imageWidth, imageHeight);
                    System.IO.MemoryStream stream = new MemoryStream();
                    bitmap.Save(stream, System.Drawing.Imaging.ImageFormat.Jpeg);
                    stream.Position = 0;
                    byte[] image = new byte[stream.Length + 1];
                    stream.Read(image, 0, image.Length);


                    // Create SQL Command
                    SqlCommand cmd = new SqlCommand();
                    cmd.CommandText = "UPDATE Member SET Document_Image = @Document_Image WHERE (MemberID = @MemberID)";
                    cmd.Parameters.AddWithValue("@MemberID", MemberDetailsFormView.DataKey["MemberID"].ToString());

                    cmd.CommandType = CommandType.Text;
                    cmd.Connection = con;

                    SqlParameter UploadedImage = new SqlParameter("@Document_Image", SqlDbType.Image, image.Length);

                    UploadedImage.Value = image;
                    cmd.Parameters.Add(UploadedImage);

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        //Get Userid Values autocomplete
        [WebMethod]
        public static string Get_UserInfo_ID(string prefix)
        {
            List<Member> User = new List<Member>();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "SELECT top(2) Registration.UserName,Registration.Name,Registration.Phone,Member.MemberID FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE Member.MemberID <> @MemberID AND Registration.UserName like @UserName + '%'";
                    cmd.Parameters.AddWithValue("@UserName", prefix);
                    cmd.Parameters.AddWithValue("@MemberID", memberID);
                    cmd.Connection = con;

                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    while (dr.Read())
                    {
                        User.Add(new Member
                        {
                            Username = dr["UserName"].ToString(),
                            Name = dr["Name"].ToString(),
                            Phone = dr["Phone"].ToString(),
                            MemberID = dr["MemberID"].ToString(),
                        });
                    }
                    con.Close();

                    var json = new JavaScriptSerializer().Serialize(User);
                    return json;
                }
            }
        }
        class Member
        {
            public string Username { get; set; }
            public string Name { get; set; }
            public string Phone { get; set; }
            public string MemberID { get; set; }
        }


        [WebMethod]
        public static string Check_PositionMemberUserName(string MemberID, string PositionMemberUserName, string PositionType)
        {
            string R = "";
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());
            SqlCommand PositionMemberID = new SqlCommand("Add_Member_Position_Change_Check", con);
            PositionMemberID.CommandType = CommandType.StoredProcedure;
            PositionMemberID.Parameters.AddWithValue("@MemberID", MemberID);
            PositionMemberID.Parameters.AddWithValue("@UserName", PositionMemberUserName.Trim());


            if (PositionMemberUserName.Trim() != "")
            {
                con.Open();
                object oPositionMemberID = PositionMemberID.ExecuteScalar();
                con.Close();

                if (oPositionMemberID != null)
                {
                    string sPosition_MemberID = oPositionMemberID.ToString();

                    if (PositionType == "Left")
                    {
                        SqlCommand LeftStatus = new SqlCommand("SELECT Left_Status FROM [Member] WHERE (MemberID = @MemberID)", con);
                        LeftStatus.Parameters.AddWithValue("@MemberID", sPosition_MemberID);

                        con.Open();
                        bool IsLeftStatusValid = (bool)LeftStatus.ExecuteScalar();
                        con.Close();

                        if (IsLeftStatusValid)
                        {
                            R = "Left Carry Member Full";
                        }
                        else
                        {
                            R = "";
                        }
                    }

                    if (PositionType == "Right")
                    {
                        SqlCommand RightStatus = new SqlCommand("SELECT Right_Status FROM [Member] WHERE (MemberID = @MemberID)", con);
                        RightStatus.Parameters.AddWithValue("@MemberID", sPosition_MemberID);

                        con.Open();
                        bool IsRightStatusValid = (bool)RightStatus.ExecuteScalar();
                        con.Close();

                        if (IsRightStatusValid)
                        {
                            R = "Right Carry Member Full";
                        }
                        else
                        {
                            R = "";
                        }
                    }
                }
                else
                {
                    R = "Placement ID is not valid";
                }
            }
            else
            {
                R = "Enter Placement Member User ID";
            }

            return R;
        }

        protected void ChangeIDButton_Click(object sender, EventArgs e)
        {
            bool ISLeftStatus = false;
            bool ISRightStatus = false;
            bool Default_Status = (bool)MemberDetailsFormView.DataKey["Default_MemberStatus"];

            if (!Default_Status)
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());

                SqlCommand PositionUserName = new SqlCommand("Add_Member_Position_Change_Check", con);
                PositionUserName.CommandType = CommandType.StoredProcedure;
                PositionUserName.Parameters.AddWithValue("@MemberID", MemberDetailsFormView.DataKey["MemberID"].ToString());
                PositionUserName.Parameters.AddWithValue("@UserName", PositionMemberUserNameTextBox.Text.Trim());

                con.Open();
                object Is_Possible = PositionUserName.ExecuteScalar();
                con.Close();

                if (Is_Possible != null)
                {
                    SqlCommand NEW_PositionMemberID = new SqlCommand("SELECT Member.MemberID FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE (Registration.UserName = @UserName)", con);
                    NEW_PositionMemberID.Parameters.AddWithValue("@UserName", PositionMemberUserNameTextBox.Text.Trim());

                    con.Open();
                    object IsPositionUserValid = NEW_PositionMemberID.ExecuteScalar();
                    string s_New_PositionMemberID = NEW_PositionMemberID.ExecuteScalar().ToString();
                    con.Close();

                    if (IsPositionUserValid != null)
                    {
                        if (PositionTypeDropDownList.SelectedValue == "Left")
                        {
                            SqlCommand LeftStatus = new SqlCommand("SELECT Left_Status FROM [Member] WHERE (MemberID = @MemberID)", con);
                            LeftStatus.Parameters.AddWithValue("@MemberID", s_New_PositionMemberID);

                            con.Open();
                            ISLeftStatus = (bool)LeftStatus.ExecuteScalar();
                            con.Close();
                        }

                        if (PositionTypeDropDownList.SelectedValue == "Right")
                        {
                            SqlCommand RightStatus = new SqlCommand("SELECT Right_Status FROM [Member] WHERE (MemberID = @MemberID)", con);
                            RightStatus.Parameters.AddWithValue("@MemberID", s_New_PositionMemberID);

                            con.Open();
                            ISRightStatus = (bool)RightStatus.ExecuteScalar();
                            con.Close();
                        }


                        ////---------------------Check left and right-----------------
                        if (!ISLeftStatus)
                        {
                            if (!ISRightStatus)
                            {
                                Position_Change_RecordSQL.InsertParameters["New_PositionMemberID"].DefaultValue = s_New_PositionMemberID;
                                Position_Change_RecordSQL.Insert();

                                Update_M_PositionSQL.UpdateParameters["MemberID"].DefaultValue = s_New_PositionMemberID;
                                Update_M_PositionSQL.Update();


                                Update_Old_M_Position_SQL.Update();


                                UpdatePlacementSQL.UpdateParameters["PositionMemberID"].DefaultValue = s_New_PositionMemberID;
                                UpdatePlacementSQL.Update();

                                // SP ------------- Add_Update_CarryMember
                                UpdatePlacementSQL.Insert();

                                // SP ------------- Add_Update_CarryMember
                                UpdateOldPlacementSQL.Insert();

                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Successfully Changed')", true);
                            }
                            else
                            {
                                PositionTypeLabel.Text = "Right Carry Member Full";
                            }
                        }
                        else
                        {
                            PositionTypeLabel.Text = "Left Carry Member Full";
                        }
                    }
                    else
                    {
                        PositionLabel.Text = "Invalid Position Member User Name";
                    }
                }
                else
                {
                    PositionLabel.Text = "Can't Change Position";
                }
            }
        }
    }
}