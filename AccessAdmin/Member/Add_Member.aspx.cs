using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Security;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CncAgro.AccessAdmin.Member
{
    public partial class Add_Member : System.Web.UI.Page
    {
        private readonly SqlConnection _con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());
        protected void Page_Load(object sender, EventArgs e)
        {
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
            if (JsonData.Value == "")
            {
                PositionLabel.Text = "No Product added in cart";
            }
            else
            {
                var point = Convert.ToDouble(GTpointHF.Value);
                if (point >= 1000)
                {
                    var cmd = new SqlCommand("SELECT Count(Phone) FROM Registration WHERE (Phone = @Phone)", _con);
                    cmd.Parameters.AddWithValue("@Phone", PhoneTextBox.Text.Trim());

                    _con.Open();
                    var dr = (int)cmd.ExecuteScalar();
                    _con.Close();

                    if (dr >= 1)
                    {
                        ErrorLabel.Text = "Mobile Number already exists";
                    }
                    else
                    {
                        var isAvailable = true;

                        var pList = new List<Shopping>(ProductList());

                        foreach (var item in pList)
                        {
                            var con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ConnectionString);

                            var stockCmd = new SqlCommand("SELECT Stock_Quantity FROM Product_Point_Code WHERE(IsActive = 1) AND (Product_PointID = @ProductID)", con);
                            stockCmd.Parameters.AddWithValue("@ProductID", item.ProductID);

                            con.Open();
                            var stock = (int)stockCmd.ExecuteScalar();
                            con.Close();

                            if (stock < item.Quantity)
                            {
                                isAvailable = false;
                            }
                        }


                        if (isAvailable)
                        {
                            ErrorLabel.Text = "";

                            var referralMemberId = new SqlCommand("SELECT Member.MemberID FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE (Registration.UserName = @UserName)", _con);
                            referralMemberId.Parameters.AddWithValue("@UserName", ReferralIDTextBox.Text);

                            _con.Open();
                            var sReferralMemberId = referralMemberId.ExecuteScalar().ToString();
                            _con.Close();


                            try
                            {
                                var cmdUserSn = new SqlCommand("SELECT Member_SN FROM Institution", _con);
                                _con.Open();
                                var userSn = Convert.ToInt32(cmdUserSn.ExecuteScalar());
                                _con.Close();

                                var password = CreatePassword(8);
                                var userName = DateTime.Now.ToString("yyMM") + userSn.ToString().PadLeft(5, '0');

                                MembershipUser newUser = Membership.CreateUser(userName, password, Email.Text, "When you SignUp?", DateTime.Now.ToString(), true, out var createStatus);

                                if (MembershipCreateStatus.Success == createStatus)
                                {
                                    Roles.AddUserToRole(userName, "Member");

                                    RegistrationSQL.InsertParameters["UserName"].DefaultValue = userName;
                                    RegistrationSQL.Insert();


                                    MemberSQL.InsertParameters["Referral_MemberID"].DefaultValue = sReferralMemberId;
                                    MemberSQL.Insert();

                                    UserLoginSQL.InsertParameters["Password"].DefaultValue = password;
                                    UserLoginSQL.InsertParameters["UserName"].DefaultValue = userName;
                                    UserLoginSQL.Insert();

                                    RegistrationSQL.Update();

                                    var cmdUserMemberId = new SqlCommand("SELECT Member.MemberID FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE (Registration.UserName = @UserName)", _con);
                                    cmdUserMemberId.Parameters.AddWithValue("@UserName", userName);
                                    _con.Open();
                                    var userMemberId = cmdUserMemberId.ExecuteScalar().ToString();
                                    _con.Close();


                                    //Product Selling block 
                                    #region Add Product .........

                                    ShoppingSQL.InsertParameters["MemberID"].DefaultValue = userMemberId;
                                    ShoppingSQL.Insert();

                                    foreach (var item in pList)
                                    {
                                        Product_Selling_RecordsSQL.InsertParameters["ProductID"].DefaultValue = item.ProductID;
                                        Product_Selling_RecordsSQL.InsertParameters["ShoppingID"].DefaultValue = ViewState["ShoppingID"].ToString();
                                        Product_Selling_RecordsSQL.InsertParameters["SellingQuantity"].DefaultValue = item.Quantity.ToString();
                                        Product_Selling_RecordsSQL.InsertParameters["SellingUnitPrice"].DefaultValue = item.Unit_Price;
                                        Product_Selling_RecordsSQL.InsertParameters["SellingUnitPoint"].DefaultValue = item.Unit_Point;
                                        Product_Selling_RecordsSQL.Insert();


                                        SellerProductSQL.UpdateParameters["Product_PointID"].DefaultValue = item.ProductID;
                                        SellerProductSQL.UpdateParameters["Stock_Quantity"].DefaultValue = item.Quantity.ToString();
                                        SellerProductSQL.Update();
                                    }

                                    #endregion End Product


                                    // Update S.P Add_Referral_Bonus
                                    A_PointSQL.UpdateParameters["MemberID"].DefaultValue = userMemberId;
                                    A_PointSQL.UpdateParameters["Point"].DefaultValue = GTpointHF.Value;
                                    A_PointSQL.Update();


                                    // Generation commission 2% to 6 upper generation S.P Add_Generation_Income
                                    Retail_IncomeSQL.UpdateParameters["MemberID"].DefaultValue = userMemberId;
                                    Retail_IncomeSQL.UpdateParameters["Point"].DefaultValue = GTpointHF.Value;
                                    Retail_IncomeSQL.Update();

                                    // Update S.P Add_Retail_Income
                                    if (point > 1000)
                                    {
                                        Retail_IncomeSQL.InsertParameters["MemberID"].DefaultValue = userMemberId;
                                        Retail_IncomeSQL.InsertParameters["Point"].DefaultValue = (point - 1000).ToString();
                                        Retail_IncomeSQL.Insert();
                                    }

                                    // Send SMS
                                    #region Send SMS                               
                                    var sms = new SMS_Class();

                                    var totalSms = 0;
                                    var smsBalance = sms.SMSBalance;
                                    var phoneNo = PhoneTextBox.Text.Trim();
                                    var msg = "Welcome to CNC Agro. Your Information has been Inserted Successfully. Your id: " + userName + " and Password: " + password;

                                    totalSms = sms.SMS_Conut(msg);

                                    if (smsBalance >= totalSms)
                                    {
                                        if (sms.SMS_GetBalance() >= totalSms)
                                        {
                                            var isValid = sms.SMS_Validation(phoneNo, msg);
                                            if (isValid.Validation)
                                            {
                                                var smsSendId = sms.SMS_Send(phoneNo, msg, "Add Customers");

                                                SMS_OtherInfoSQL.InsertParameters["SMS_Send_ID"].DefaultValue = smsSendId.ToString();
                                                SMS_OtherInfoSQL.InsertParameters["MemberID"].DefaultValue = userMemberId;
                                                SMS_OtherInfoSQL.Insert();
                                            }
                                        }
                                    }
                                    #endregion SMS

                                    GTpriceHF.Value = "";
                                    GTpointHF.Value = "";
                                    
                                    Response.Redirect("../Product_Point/Receipt.aspx?ShoppingID=" + ViewState["ShoppingID"].ToString());
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
                            PositionLabel.Text = "Product is out of stock";
                        }
                    }
                }
                else
                {
                    PositionLabel.Text = "Minimum 1000 point need to join new member";
                }
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
        [WebMethod]
        public static bool Check_Mobile(string Mobile)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());

            SqlCommand cmd = new SqlCommand("SELECT Count(Phone) FROM Registration WHERE (Phone = @Phone)", con);
            cmd.Parameters.AddWithValue("@Phone", Mobile.Trim());

            con.Open();
            int dr = (int)cmd.ExecuteScalar();
            con.Close();

            return (dr >= 3);
        }

        [WebMethod]
        public static string Check_Left_Right(string Position_MemberID, string PositionType)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString());
            string R = "";

            if (PositionType == "Left")
            {
                SqlCommand LeftStatus = new SqlCommand("SELECT Left_Status FROM [Member] WHERE (MemberID = @MemberID)", con);
                LeftStatus.Parameters.AddWithValue("@MemberID", Position_MemberID);

                con.Open();
                bool IsLeftStatusValid = (bool)LeftStatus.ExecuteScalar();
                con.Close();

                if (IsLeftStatusValid)
                {
                    R = "Left Member Full";
                }
                else
                {
                    R = "";
                }
            }

            if (PositionType == "Right")
            {
                SqlCommand RightStatus = new SqlCommand("SELECT Right_Status FROM [Member] WHERE (MemberID = @MemberID)", con);
                RightStatus.Parameters.AddWithValue("@MemberID", Position_MemberID);

                con.Open();
                bool IsRightStatusValid = (bool)RightStatus.ExecuteScalar();
                con.Close();

                if (IsRightStatusValid)
                {
                    R = "Right Member Full";
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
                    cmd.CommandText = "SELECT TOP(3) Product_PointID, Product_Name, Product_Code, Product_Point, Product_Price, Stock_Quantity FROM Product_Point_Code WHERE (IsActive = 1) AND (Stock_Quantity > 0) AND (Product_Code LIKE @Product_Code + '%')";
                    cmd.Parameters.AddWithValue("@Product_Code", prefix);
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
                            Stock = dr["Stock_Quantity"].ToString(),
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