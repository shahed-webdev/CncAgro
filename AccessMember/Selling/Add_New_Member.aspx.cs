using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Security;
using System.Web.Services;
using System.Web.UI.WebControls;

namespace CncAgro.AccessMember.Selling
{
    public partial class Add_New_Member : System.Web.UI.Page
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                Page.ClientScript.RegisterStartupScript(this.GetType(), "Rl", "RemoveCart();", true);
            }
        }

        class Shopping
        {
            public string ProductID { get; set; }
            public int Quantity { get; set; }
            public string Unit_Price { get; set; }
            public string Unit_Point { get; set; }
        }
        List<Shopping> ProductList()
        {
            string json = JsonData.Value;
            JavaScriptSerializer js = new JavaScriptSerializer();
            List<Shopping> data = js.Deserialize<List<Shopping>>(json);
            return data;
        }
        protected void Add_Customer_Button_Click(object sender, EventArgs e)
        {
            if (JsonData.Value != "")
            {
                double T_Point = Convert.ToDouble(GTpointHF.Value);

                //SqlCommand cmd = new SqlCommand("SELECT Count(Phone) FROM Registration WHERE (Phone = @Phone)", con);
                //cmd.Parameters.AddWithValue("@Phone", PhoneTextBox.Text.Trim());

                //con.Open();
                //int dr = (int)cmd.ExecuteScalar();
                //con.Close();

                //if (dr >= 7)
                //{
                //    ErrorLabel.Text = "Mobile Number already exists 7 times";
                //}
                //else
                //{
                bool Is_Available = true;

                List<Shopping> P_List = new List<Shopping>(ProductList());

                foreach (Shopping item in P_List)
                {
                    SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString);

                    SqlCommand Stockcmd = new SqlCommand("SELECT SellerProduct_Stock FROM Seller_Product WHERE(Product_PointID = @ProductID) AND(SellerID = @SellerID)", con);
                    Stockcmd.Parameters.AddWithValue("@ProductID", item.ProductID);
                    Stockcmd.Parameters.AddWithValue("@SellerID", Session["SellerID"].ToString());

                    con.Open();
                    int Stock = (int)Stockcmd.ExecuteScalar();
                    con.Close();

                    if (Stock < item.Quantity)
                    {
                        Is_Available = false;
                    }
                }


                if (Is_Available)
                {
                    ErrorLabel.Text = "";

                    bool ISLeftStatus = false;
                    bool ISRightStatus = false;

                    SqlCommand PositionUserName = new SqlCommand("SELECT Registration.UserName FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE ((Member.Left_Status = 0) OR (Member.Right_Status = 0)) AND (Registration.UserName= @UserName)", con);
                    PositionUserName.Parameters.AddWithValue("@UserName", PositionMemberUserNameTextBox.Text.Trim());

                    con.Open();
                    object IsPositionUserValid = PositionUserName.ExecuteScalar();
                    con.Close();

                    if (IsPositionUserValid != null)
                    {
                        SqlCommand Referral_MemberID = new SqlCommand("SELECT Member.MemberID FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE (Registration.UserName = @UserName)", con);
                        Referral_MemberID.Parameters.AddWithValue("@UserName", ReferralIDTextBox.Text);

                        SqlCommand PositionMemberID = new SqlCommand("SELECT Member.MemberID FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE (Registration.UserName = @UserName)", con);
                        PositionMemberID.Parameters.AddWithValue("@UserName", PositionMemberUserNameTextBox.Text.Trim());

                        con.Open();
                        string sReferral_MemberID = Referral_MemberID.ExecuteScalar().ToString();
                        string sPositionMemberID = PositionMemberID.ExecuteScalar().ToString();
                        con.Close();


                        if (PositionTypeDropDownList.SelectedValue == "Left")
                        {
                            SqlCommand LeftStatus = new SqlCommand("SELECT Left_Status FROM [Member] WHERE (MemberID = @MemberID)", con);
                            LeftStatus.Parameters.AddWithValue("@MemberID", sPositionMemberID);

                            con.Open();
                            ISLeftStatus = (bool)LeftStatus.ExecuteScalar();
                            con.Close();
                        }

                        if (PositionTypeDropDownList.SelectedValue == "Right")
                        {
                            SqlCommand RightStatus = new SqlCommand("SELECT Right_Status FROM [Member] WHERE (MemberID = @MemberID)", con);
                            RightStatus.Parameters.AddWithValue("@MemberID", sPositionMemberID);

                            con.Open();
                            ISRightStatus = (bool)RightStatus.ExecuteScalar();
                            con.Close();
                        }


                        ////---------------------Check left and right-----------------
                        if (!ISLeftStatus)
                        {
                            if (!ISRightStatus)
                            {
                                try
                                {
                                    SqlCommand Cmd_User_SN = new SqlCommand("SELECT Member_SN FROM Institution", con);
                                    con.Open();
                                    int User_SN = Convert.ToInt32(Cmd_User_SN.ExecuteScalar());
                                    con.Close();

                                    string Password = CreatePassword(8);
                                    string UserName = DateTime.Now.ToString("yyMM") + User_SN.ToString().PadLeft(5, '0');

                                    MembershipCreateStatus createStatus;
                                    MembershipUser newUser = Membership.CreateUser(UserName, Password, Email.Text, "When you signup?", DateTime.Now.ToString(), true, out createStatus);

                                    if (MembershipCreateStatus.Success == createStatus)
                                    {
                                        Roles.AddUserToRole(UserName, "Member");

                                        RegistrationSQL.InsertParameters["UserName"].DefaultValue = UserName;
                                        RegistrationSQL.Insert();


                                        MemberSQL.InsertParameters["Referral_MemberID"].DefaultValue = sReferral_MemberID;
                                        MemberSQL.InsertParameters["PositionMemberID"].DefaultValue = sPositionMemberID;
                                        MemberSQL.Insert();

                                        UserLoginSQL.InsertParameters["Password"].DefaultValue = Password;
                                        UserLoginSQL.InsertParameters["UserName"].DefaultValue = UserName;
                                        UserLoginSQL.Insert();

                                        //--------User_SN Update-----------------------------------------------------
                                        RegistrationSQL.Update();
                                        if (PositionTypeDropDownList.SelectedValue == "Left")
                                        {
                                            SqlCommand UpdateMember = new SqlCommand("UPDATE Member SET Left_Status = 1 Where (MemberID = @MemberID)", con);
                                            UpdateMember.Parameters.AddWithValue("@MemberID", sPositionMemberID);

                                            con.Open();
                                            UpdateMember.ExecuteNonQuery();
                                            con.Close();
                                        }

                                        if (PositionTypeDropDownList.SelectedValue == "Right")
                                        {
                                            SqlCommand UpdateMember = new SqlCommand("UPDATE Member SET Right_Status = 1 Where (MemberID = @MemberID)", con);
                                            UpdateMember.Parameters.AddWithValue("@MemberID", sPositionMemberID);

                                            con.Open();
                                            UpdateMember.ExecuteNonQuery();
                                            con.Close();
                                        }


                                        // MemberSQL.Update Total Carry Member Update by SP Add_Update_CarryMember

                                        SqlCommand Cmd_User_MemberID = new SqlCommand("SELECT  Member.MemberID FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE (Registration.UserName = @UserName)", con);
                                        Cmd_User_MemberID.Parameters.AddWithValue("@UserName", UserName);
                                        con.Open();
                                        string User_MemberID = Cmd_User_MemberID.ExecuteScalar().ToString();
                                        con.Close();

                                        //S.P Add_Update_CarryMember
                                        MemberSQL.UpdateParameters["MemberID"].DefaultValue = User_MemberID;
                                        MemberSQL.Update();


                                        //Product Selling block 
                                        #region Add Product .........

                                        ShoppingSQL.InsertParameters["MemberID"].DefaultValue = User_MemberID;
                                        ShoppingSQL.Insert();

                                        foreach (Shopping item in P_List)
                                        {
                                            Product_Selling_RecordsSQL.InsertParameters["ProductID"].DefaultValue = item.ProductID;
                                            Product_Selling_RecordsSQL.InsertParameters["ShoppingID"].DefaultValue = ViewState["ShoppingID"].ToString();
                                            Product_Selling_RecordsSQL.InsertParameters["SellingQuantity"].DefaultValue = item.Quantity.ToString();
                                            Product_Selling_RecordsSQL.InsertParameters["SellingUnitPrice"].DefaultValue = item.Unit_Price;
                                            Product_Selling_RecordsSQL.InsertParameters["SellingUnitPoint"].DefaultValue = item.Unit_Point;
                                            Product_Selling_RecordsSQL.Insert();


                                            SellerProductSQL.UpdateParameters["Product_PointID"].DefaultValue = item.ProductID;
                                            SellerProductSQL.UpdateParameters["SellerProduct_Stock"].DefaultValue = item.Quantity.ToString();
                                            SellerProductSQL.Update();
                                        }

                                        #endregion End Product


                                        SellerUpdateSQL.Update();

                                        // Update S.P Add_Point
                                        A_PointSQL.InsertParameters["MemberID"].DefaultValue = User_MemberID;
                                        A_PointSQL.InsertParameters["Point"].DefaultValue = GTpointHF.Value;
                                        A_PointSQL.Insert();

                                        // Update S.P Add_Referral_Bonus

                                        A_PointSQL.UpdateParameters["MemberID"].DefaultValue = User_MemberID;
                                        A_PointSQL.UpdateParameters["Point"].DefaultValue = GTpointHF.Value;
                                        A_PointSQL.Update();

                                        //Package Update
                                        Package_UpdateSQL.UpdateParameters["MemberID"].DefaultValue = User_MemberID;
                                        Package_UpdateSQL.Update();


                                        if (Generation_Type_RadioB.SelectedValue == "G")
                                        {
                                            // Update S.P Add_Generation_UniLevel
                                            GenerationSQL.UpdateParameters["MemberID"].DefaultValue = User_MemberID;
                                            GenerationSQL.UpdateParameters["Point"].DefaultValue = GTpointHF.Value;
                                            GenerationSQL.Update();
                                        }
                                        else
                                        {
                                            // Update S.P Add_Generation_Retail
                                            GenerationSQL.InsertParameters["MemberID"].DefaultValue = User_MemberID;
                                            GenerationSQL.InsertParameters["Point"].DefaultValue = GTpointHF.Value;
                                            GenerationSQL.Insert();
                                        }

                                        // AutoPlan
                                        if (T_Point >= 500)
                                        {
                                            AutoPlan_SQL.InsertParameters["MemberID"].DefaultValue = User_MemberID;
                                            AutoPlan_SQL.Insert();

                                        }
                                        // Update S.P Add_Designation_Loop
                                        AutoPlan_SQL.Update();

                                        //Seller commission S.P
                                        Seller_ComissionSQL.InsertParameters["ShoppingID"].DefaultValue = ViewState["ShoppingID"].ToString();
                                        Seller_ComissionSQL.Insert();

                                        // Send SMS
                                        #region Send SMS                               
                                        SMS_Class SMS = new SMS_Class();

                                        int TotalSMS = 0;
                                        int SMSBalance = SMS.SMSBalance;
                                        string PhoneNo = PhoneTextBox.Text.Trim();
                                        string Msg = "Welcome to 786 Nitta Bazar Ltd. Your Information has been Inserted Successfully. Your id: " + UserName + " and Password: " + Password;

                                        TotalSMS = SMS.SMS_Conut(Msg);

                                        if (SMSBalance >= TotalSMS)
                                        {
                                            if (SMS.SMS_GetBalance() >= TotalSMS)
                                            {
                                                Get_Validation IsValid = SMS.SMS_Validation(PhoneNo, Msg);
                                                if (IsValid.Validation)
                                                {
                                                    Guid SMS_Send_ID = SMS.SMS_Send(PhoneNo, Msg, "Add Customers");

                                                    SMS_OtherInfoSQL.InsertParameters["SMS_Send_ID"].DefaultValue = SMS_Send_ID.ToString();
                                                    SMS_OtherInfoSQL.InsertParameters["MemberID"].DefaultValue = User_MemberID;
                                                    SMS_OtherInfoSQL.Insert();
                                                }
                                            }
                                        }
                                        #endregion SMS

                                        GTpriceHF.Value = "";
                                        GTpointHF.Value = "";
                                        Page.ClientScript.RegisterStartupScript(this.GetType(), "Rl", "RemoveCart()", true);

                                        Response.Redirect("Receipt.aspx?ShoppingID=" + ViewState["ShoppingID"].ToString());
                                    }
                                    else
                                    {
                                        ErrorLabel.Text = GetErrorMessage(createStatus) + "<br />";
                                    }
                                }
                                catch (MembershipCreateUserException ex)
                                {
                                    ErrorLabel.Text = GetErrorMessage(ex.StatusCode) + "<br />";
                                }
                                catch (HttpException ex)
                                {
                                    ErrorLabel.Text = ex.Message + "<br />";
                                }
                            }
                            else
                            {
                                PositionTypeLabel.Text = "Team B Member Full";
                            }
                        }
                        else
                        {
                            PositionTypeLabel.Text = "Team A Member Full";
                        }
                    }
                    else
                    {
                        PositionLabel.Text = "Invalid Spot Member User Id";
                    }
                }
                else
                {
                    PositionLabel.Text = "Product is out of stock";
                }
            }
            else
            {
                PositionLabel.Text = "No Product added in cart";
            }
        }

        public string GetErrorMessage(MembershipCreateStatus status)
        {
            switch (status)
            {
                case MembershipCreateStatus.Success:
                    return "The user account was successfully created!";

                case MembershipCreateStatus.DuplicateUserName:
                    return "Username already exists. Please enter a different user name.";

                case MembershipCreateStatus.DuplicateEmail:
                    return "A username for that e-mail address already exists. Please enter a different e-mail address.";

                case MembershipCreateStatus.InvalidPassword:
                    return "The password provided is invalid. Please enter a valid password value.";

                case MembershipCreateStatus.InvalidEmail:
                    return "The e-mail address provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.InvalidAnswer:
                    return "The password retrieval answer provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.InvalidQuestion:
                    return "The password retrieval question provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.InvalidUserName:
                    return "The user name provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.ProviderError:
                    return "The authentication provider returned an error. Please verify your entry and try again. If the problem persists, please contact your system administrator.";

                case MembershipCreateStatus.UserRejected:
                    return "The user creation request has been canceled. Please verify your entry and try again. If the problem persists, please contact your system administrator.";

                default:
                    return "An unknown error occurred. Please verify your entry and try again. If the problem persists, please contact your system administrator.";
            }
        }

        public string CreatePassword(int length)
        {
            const string valid = "1234567890";
            StringBuilder res = new StringBuilder();
            Random rnd = new Random();
            while (0 < length--)
            {
                res.Append(valid[rnd.Next(valid.Length)]);
            }
            return res.ToString();
        }
        protected void ShoppingSQL_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            ViewState["ShoppingID"] = e.Command.Parameters["@ShoppingID"].Value.ToString();
        }

        //Check status
        //[WebMethod]
        //public static bool Check_Mobile(string Mobile)
        //{
        //    SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());

        //    SqlCommand cmd = new SqlCommand("SELECT Count(Phone) FROM Registration WHERE (Phone = @Phone)", con);
        //    cmd.Parameters.AddWithValue("@Phone", Mobile.Trim());

        //    con.Open();
        //    int dr = (int)cmd.ExecuteScalar();
        //    con.Close();

        //    return (dr >= 7);
        //}

        [WebMethod]
        public static string Check_Left_Right(string Position_MemberID, string PositionType)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());
            string R = "";

            if (PositionType == "Team A")
            {
                SqlCommand LeftStatus = new SqlCommand("SELECT Left_Status FROM [Member] WHERE (MemberID = @MemberID)", con);
                LeftStatus.Parameters.AddWithValue("@MemberID", Position_MemberID);

                con.Open();
                bool IsLeftStatusValid = (bool)LeftStatus.ExecuteScalar();
                con.Close();

                if (IsLeftStatusValid)
                {
                    R = "Team A Member Full";
                }
                else
                {
                    R = "";
                }
            }

            if (PositionType == "Team B")
            {
                SqlCommand RightStatus = new SqlCommand("SELECT Right_Status FROM [Member] WHERE (MemberID = @MemberID)", con);
                RightStatus.Parameters.AddWithValue("@MemberID", Position_MemberID);

                con.Open();
                bool IsRightStatusValid = (bool)RightStatus.ExecuteScalar();
                con.Close();

                if (IsRightStatusValid)
                {
                    R = "Team B Member Full";
                }
                else
                {
                    R = "";
                }
            }

            return R;
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
                    cmd.CommandText = "SELECT top(3) Registration.UserName,Registration.Name,Registration.Phone,Member.MemberID FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE Registration.UserName like @UserName + '%'";
                    cmd.Parameters.AddWithValue("@UserName", prefix);
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

        //Get Product Info
        [WebMethod]
        public static string GetProduct(string prefix)
        {
            List<Product> User = new List<Product>();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "SELECT top(3) Product_Point_Code.Product_Code, Product_Point_Code.Product_Name, Product_Point_Code.Product_Price, Product_Point_Code.Product_Point, Product_Point_Code.Product_PointID, Seller_Product.SellerProduct_Stock FROM Product_Point_Code INNER JOIN Seller_Product ON Product_Point_Code.Product_PointID = Seller_Product.Product_PointID WHERE Seller_Product.SellerID = @SellerID AND Seller_Product.SellerProduct_Stock > 0 AND Product_Point_Code.Product_Code LIKE @Product_Code + '%'";
                    cmd.Parameters.AddWithValue("@Product_Code", prefix);
                    cmd.Parameters.AddWithValue("@SellerID", HttpContext.Current.Session["SellerID"].ToString());
                    cmd.Connection = con;

                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    while (dr.Read())
                    {
                        User.Add(new Product
                        {
                            Code = dr["Product_Code"].ToString(),
                            Name = dr["Product_Name"].ToString(),
                            Price = dr["Product_Price"].ToString(),
                            Point = dr["Product_Point"].ToString(),
                            Stock = dr["SellerProduct_Stock"].ToString(),
                            ProductID = dr["Product_PointID"].ToString()
                        });
                    }
                    con.Close();

                    var json = new JavaScriptSerializer().Serialize(User);
                    return json;
                }
            }
        }
        class Product
        {
            public string Code { get; set; }
            public string Name { get; set; }
            public string Price { get; set; }
            public string Point { get; set; }
            public string Stock { get; set; }
            public string ProductID { get; set; }
        }
    }
}