<%@ Page Title="Profile" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="MemberProfile.aspx.cs" Inherits="CncAgro.AccessMember.MemberProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Member_Profile.css?v=5" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="well Member-info">
        <asp:FormView ID="MemberFormView" runat="server" DataKeyNames="RegistrationID" DataSourceID="MemberSQL" OnItemUpdated="MemberFormView_ItemUpdated" Width="100%">
            <EditItemTemplate>
                <h3>Update Information</h3>
                <div class="col-md-6 col-sm-12">
                    <div class="form-group">
                        <label>Name</label>
                        <asp:TextBox ID="NameTextBox" CssClass="form-control" runat="server" Text='<%# Bind("Name") %>' />
                    </div>
                    <div class="form-group">
                        <label>Father&#39;s Name</label>
                        <asp:TextBox ID="TextBox2" runat="server" CssClass="form-control" Text='<%# Bind("FatherName") %>' />
                    </div>
                    <div class="form-group">
                        <label>Mother's Name</label>
                        <asp:TextBox ID="TextBox3" runat="server" CssClass="form-control" Text='<%# Bind("MotherName") %>' />
                    </div>
                    <div class="form-group">
                        <label>Phone</label>
                        <asp:TextBox ID="PhoneLabel" CssClass="form-control" runat="server" Text='<%# Bind("Phone") %>' />
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <asp:TextBox ID="TextBox5" runat="server" CssClass="form-control" Text='<%# Bind("Email") %>' />
                    </div>
                    <div class="form-group">
                        <label>Present Address</label>
                        <asp:TextBox ID="TextBox6" runat="server" CssClass="form-control" Text='<%# Bind("Present_Address") %>' TextMode="MultiLine" />
                    </div>
                    <div class="form-group">
                        <label>Permanent Address</label>
                        <asp:TextBox ID="TextBox7" runat="server" CssClass="form-control" Text='<%# Bind("Permanent_Address") %>' TextMode="MultiLine" />
                    </div>
                    <div class="form-group">
                        <label>Date of Birth</label>
                        <asp:TextBox ID="DateofBirth" CssClass="form-control datepicker" runat="server" Text='<%# Bind("DateofBirth") %>' />
                    </div>
                    <div class="form-group">
                        <label>Blood Group</label>
                        <asp:DropDownList ID="BloodGroupDropDownList" runat="server" CssClass="form-control" SelectedValue='<%# Bind("BloodGroup") %>'>
                            <asp:ListItem Value=" ">[ SELECT ]</asp:ListItem>
                            <asp:ListItem>A+</asp:ListItem>
                            <asp:ListItem>A-</asp:ListItem>
                            <asp:ListItem>B+</asp:ListItem>
                            <asp:ListItem>B-</asp:ListItem>
                            <asp:ListItem>AB+</asp:ListItem>
                            <asp:ListItem>AB-</asp:ListItem>
                            <asp:ListItem>O+</asp:ListItem>
                            <asp:ListItem>O-</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label>Gender</label>
                        <asp:RadioButtonList ID="GenderRadioButtonList" CssClass="form-control" runat="server" RepeatDirection="Horizontal" SelectedValue='<%# Bind("Gender") %>'>
                            <asp:ListItem>Male</asp:ListItem>
                            <asp:ListItem>Female</asp:ListItem>
                        </asp:RadioButtonList>

                    </div>
                    <div class="form-group">
                        <label>Nominee Name</label>
                        <asp:TextBox ID="TextBox1" CssClass="form-control" runat="server" Text='<%# Bind("Nominee_Name") %>' />
                    </div>
                    <div class="form-group">
                        <label>Nominee Relationship</label>
                        <asp:TextBox ID="TextBox4" CssClass="form-control" runat="server" Text='<%# Bind("Nominee_Relationship") %>' />
                    </div>
                    <div class="form-group">
                        <label>Nominee Date Of Birth</label>
                        <asp:TextBox ID="TextBox8" CssClass="form-control datepicker" runat="server" Text='<%# Bind("Nominee_DOB","{0:d MMM yyyy}") %>' />
                    </div>
                    <div class="form-group">
                        <label>Bank</label>
                        <asp:TextBox ID="TextBox9" CssClass="form-control" runat="server" Text='<%# Bind("Bank") %>' />
                    </div>
                    <div class="form-group">
                        <label>Branch</label>
                        <asp:TextBox ID="TextBox10" CssClass="form-control" runat="server" Text='<%# Bind("Branch") %>' />
                    </div>
                    <div class="form-group">
                        <label>Account Name</label>
                        <asp:TextBox ID="TextBox11" CssClass="form-control" runat="server" Text='<%# Bind("AccountName") %>' />
                    </div>
                    <div class="form-group">
                        <label>Account No.</label>
                        <asp:TextBox ID="TextBox12" CssClass="form-control" runat="server" Text='<%# Bind("AccountNo") %>' />
                    </div>
                    <div class="form-group">
                        <label>Applicant Photo</label>
                        <asp:FileUpload ID="MemberFileUpload" runat="server" />
                    </div>
                    <div class="form-group">
                        <label>National ID</label>
                        <asp:TextBox ID="NationalIDLabel" CssClass="form-control" runat="server" Text='<%# Bind("NationalID") %>' />
                    </div>
                    <div class="form-group">
                        <label>N. ID Image</label>
                        <asp:FileUpload ID="N_IDFileUpload" runat="server" />
                    </div>

                    <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="True" CommandName="Update" Text="Update" CssClass="btn btn-default" />
                    &nbsp;<asp:LinkButton ID="LinkButton3" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" CssClass="btn btn-default" />
                </div>
            </EditItemTemplate>

            <ItemTemplate>
                <div class="Info">
                    <h3>
                        <i class="glyphicon glyphicon-user rest-userico"></i>
                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("Name") %>' />
                        <asp:FormView ID="StatusFormView" runat="server" DataSourceID="PakStatusSQL" Width="100%">
                            <EmptyDataTemplate>
                                <small>
                                    <i class="fa fa-shopping-basket" aria-hidden="true"></i>
                                    No Package
                                </small>
                            </EmptyDataTemplate>
                            <ItemTemplate>
                                <small>
                                    <i class="fa fa-shopping-basket" aria-hidden="true"></i>
                                    <%#Eval("Member_Package_Status") %>
                                </small>
                            </ItemTemplate>
                        </asp:FormView>
                        <asp:SqlDataSource ID="PakStatusSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Member_Package.Member_Package_Status FROM Member_Package INNER JOIN Member ON Member_Package.Package_Serial = Member.Member_Package_Serial WHERE (Member.MemberID = @MemberID)">
                            <SelectParameters>
                                <asp:SessionParameter Name="MemberID" SessionField="MemberID" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </h3>
                    <ul>
                        <li>
                            <span class="glyphicon glyphicon-earphone"></span>
                            <b>Mobile:</b>
                            <asp:Label ID="PhoneLabel1" runat="server" Text='<%# Bind("Phone") %>' />
                        </li>
                        <li>
                            <i class="glyphicon glyphicon-user rest-userico"></i>
                            <b>Referral ID:</b>
                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("Refarel_UserName") %>' />
                        </li>
                        <li>
                            <i class="glyphicon glyphicon-calendar"></i>
                            <b>Signup Date:</b>
                            <asp:Label ID="SignUpDateLabel" runat="server" Text='<%# Bind("SignUpDate","{0:d MMMM yyyy}") %>' />
                        </li>
                    </ul>
                </div>

                <div class="col-md-12">
                    <asp:LinkButton ID="LinkButton1" CssClass="btn btn-default" runat="server" CausesValidation="False" CommandName="Edit" Text="Update" />
                </div>
            </ItemTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="MemberSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.Name, Registration.Phone, Registration.Email, Member.MemberID, Member.SignUpDate, Registration.RegistrationID, Refarel_Registration.UserName AS Refarel_UserName, Registration.FatherName, Registration.MotherName, Registration.Present_Address, Registration.Permanent_Address, Registration.DateofBirth, Registration.Gender, Registration.BloodGroup, Registration.NationalID, Member.Nominee_Name, Member.Nominee_Relationship, Member.Bank, Member.Branch, Member.AccountName, Member.AccountNo, Member.Nominee_DOB FROM Registration AS Refarel_Registration INNER JOIN Member AS Refarel_Member ON Refarel_Registration.RegistrationID = Refarel_Member.MemberRegistrationID RIGHT OUTER JOIN Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID ON Refarel_Member.MemberID = Member.Referral_MemberID WHERE (Member.InstitutionID = @InstitutionID) AND (Registration.RegistrationID = @RegistrationID)" UpdateCommand="UPDATE  Registration SET  Name = @Name, FatherName = @FatherName, MotherName = @MotherName, DateofBirth = @DateofBirth, BloodGroup = @BloodGroup, Gender = @Gender, NationalID = @NationalID,Present_Address = @Present_Address, Permanent_Address = @Permanent_Address, Phone = @Phone, Email = @Email FROM  Registration INNER JOIN Member ON Registration.RegistrationID = Member.MemberRegistrationID
WHERE   (Member.MemberID = @MemberID)


UPDATE Member SET Nominee_Name = @Nominee_Name, Nominee_Relationship = @Nominee_Relationship,Nominee_DOB = @Nominee_DOB, Bank = @Bank, Branch = @Branch, AccountName = @AccountName, AccountNo = @AccountNo WHERE(MemberID = @MemberID)">
            <SelectParameters>
                <asp:SessionParameter Name="InstitutionID" SessionField="InstitutionID" />
                <asp:SessionParameter Name="RegistrationID" SessionField="RegistrationID" />
            </SelectParameters>
            <UpdateParameters>
                <asp:SessionParameter Name="MemberID" SessionField="MemberID" />
                <asp:Parameter Name="FatherName" />
                <asp:Parameter Name="MotherName" />
                <asp:Parameter Name="Email" />
                <asp:Parameter Name="DateofBirth" />
                <asp:Parameter Name="BloodGroup" />
                <asp:Parameter Name="Gender" />
                <asp:Parameter Name="Present_Address" />
                <asp:Parameter Name="Permanent_Address" />
                <asp:Parameter Name="Name" />
                <asp:Parameter Name="NationalID" />
                <asp:Parameter Name="Phone" />
                <asp:Parameter Name="Nominee_Name" />
                <asp:Parameter Name="Nominee_Relationship" />
                <asp:Parameter Name="Nominee_DOB" />
                <asp:Parameter Name="Bank" />
                <asp:Parameter Name="Branch" />
                <asp:Parameter Name="AccountName" />
                <asp:Parameter Name="AccountNo" />
            </UpdateParameters>
        </asp:SqlDataSource>
    </div>

    <asp:FormView ID="BonusFormView" runat="server" DataSourceID="BonusSQL" Width="100%">
        <ItemTemplate>
            <h3><strong style="color:#0d47a1">Balance: ৳<%#Eval("Available_Balance","{0:N}") %></strong></h3>
            <div class="row">
                <div class="col-sm-4">
                    <div class="Comission">
                        <h5>Referral Commission</h5>
                       <a href="Bonus_Details/Referral_Bonus_Details.aspx"> <%#Eval("Referral_Income","{0:N}") %></a>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="Comission">
                        <h5>Duplex Commission</h5>
                       <a href="Bonus_Details/Infinity_Bonus_Details.aspx"> <%#Eval("Matching_Income","{0:N}") %></a>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="Comission">
                        <h5>Retail Commission</h5>
                        <a href="Bonus_Details/Cash_Back.aspx"><%#Eval("Instant_Cash_Back_Income","{0:N}") %></a>
                    </div>
                </div>
            </div>

            <h3>Member & point</h3>
            <div class="row">
                <div class="col-sm-3">
                    <div class="white-box">
                        <h2 class="box-title">
                            <i class="fa fa-arrow-circle-left" aria-hidden="true"></i>
                            LEFT Point
                        </h2>
                        <ul class="list-inline two-part">
                            <li>
                                <i class="fa fa-star" aria-hidden="true"></i>
                            </li>
                            <li class="text-right">
                                <span><%#Eval("Left_Carry_Point") %></span>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="white-box">
                        <h2 class="box-title">
                            <i class="fa fa-arrow-circle-right" aria-hidden="true"></i>
                            Right Point
                        </h2>
                        <ul class="list-inline two-part">
                            <li>
                                <i class="fa fa-star" aria-hidden="true"></i>
                            </li>
                            <li class="text-right">
                                <span><%#Eval("Right_Carry_Point") %></span>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="white-box">
                        <h2 class="box-title">
                            <i class="fa fa-arrow-circle-left" aria-hidden="true"></i>
                            LEFT Member
                        </h2>
                        <ul class="list-inline two-part">
                            <li>
                                <i class="fa fa-user-circle" aria-hidden="true"></i>
                            </li>
                            <li class="text-right">
                                <span><%#Eval("TotalLeft_Member") %></span>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="white-box">
                        <h2 class="box-title">
                            <i class="fa fa-arrow-circle-right" aria-hidden="true"></i>
                            Right Member
                        </h2>
                        <ul class="list-inline two-part">
                            <li>
                                <i class="fa fa-user-circle" aria-hidden="true"></i>
                            </li>
                            <li class="text-right">
                                <span><%#Eval("TotalRight_Member") %></span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>

            <h3>Send & received balance</h3>

            <div class="row">
                <div class="col-sm-4">
                    <div class="white-box">
                        <h2 class="box-title">
                            <a href="Bonus_Details/Withdraw_Details.aspx">
                                <i class="fa fa-arrow-circle-up" aria-hidden="true"></i>
                                Withdraw Balance
                            </a>
                        </h2>
                        <ul class="list-inline two-part">
                            <li>
                                <i class="fa fa-money b-color" aria-hidden="true"></i>
                            </li>
                            <li class="text-right b-color">
                                <span><%#Eval("Withdraw_Balance","{0:N}") %></span>
                            </li>
                        </ul>
                    </div>
                </div>

                <div class="col-sm-4">

                    <div class="white-box">
                        <h2 class="box-title">
                            <a href="Bonus_Details/Send_Details.aspx">
                                <i class="fa fa-paper-plane" aria-hidden="true"></i>
                                Send Balance
                            </a>
                        </h2>
                        <ul class="list-inline two-part">
                            <li>
                                <i class="fa fa-money b-color" aria-hidden="true"></i>
                            </li>
                            <li class="text-right b-color">
                                <span><%#Eval("Send_Balance","{0:N}") %></span>
                            </li>
                        </ul>
                    </div>
                </div>

                <div class="col-sm-4">

                    <div class="white-box">
                        <h2 class="box-title">
                            <a href="Bonus_Details/Received_Details.aspx">
                                <i class="fa fa-arrow-circle-down" aria-hidden="true"></i>
                                Received Balance
                            </a>
                        </h2>
                        <ul class="list-inline two-part">
                            <li>
                                <i class="fa fa-money b-color" aria-hidden="true"></i>
                            </li>
                            <li class="text-right b-color">
                                <span><%#Eval("Received__Balance","{0:N}") %></span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </ItemTemplate>
    </asp:FormView>

    <asp:SqlDataSource ID="BonusSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT AvailablePoint, Referral_Income, Matching_Income, Instant_Cash_Back_Income, Left_Carry_Point, Right_Carry_Point, TotalLeft_Member, TotalRight_Member, Available_Balance, SignUpDate, Total_Amount, Withdraw_Balance, Send_Balance, Received__Balance FROM Member WHERE (MemberID = @MemberID)">
        <SelectParameters>
            <asp:SessionParameter Name="MemberID" SessionField="MemberID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <%if (Notice_Repeater.Items.Count > 0)
        { %>
    <h4>NOTICE</h4>
    <div class="row">
        <asp:Repeater ID="Notice_Repeater" runat="server" DataSourceID="NoticeSQL">
            <ItemTemplate>
                <div class="col-md-6">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h4><%# Eval("Notice_Title") %></h4>
                            <em style="color: #6F196E">View Date: <%# Eval("Start_Date","{0: d MMM yyyy}") %> - <%# Eval("End_Date","{0: d MMM yyyy}") %></em>
                        </div>

                        <div class="panel-body">
                            <div class="n-image">
                                <img alt="" src="/Handler/Notice_Image.ashx?Img=<%#Eval("Noticeboard_General_ID") %>" class="img-responsive" />
                            </div>
                            <div class="n-text">
                                <asp:Label ID="NoticeLabel" runat="server" Text='<%# Eval("Notice") %>' />
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="NoticeSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Noticeboard_General_ID, Notice_Title, Notice, Notice_Image, Start_Date, End_Date, Insert_Date FROM Noticeboard_General WHERE (GETDATE() BETWEEN Start_Date AND End_Date)"></asp:SqlDataSource>
    </div>
    <%} %>
</asp:Content>
