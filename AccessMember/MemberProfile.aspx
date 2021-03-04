<%@ Page Title="Profile" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="MemberProfile.aspx.cs" Inherits="CncAgro.AccessMember.MemberProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Member_Profile.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="mb-3">
        <asp:FormView ID="MemberFormView" runat="server" DataKeyNames="RegistrationID" DataSourceID="MemberSQL" OnItemUpdated="MemberFormView_ItemUpdated" Width="100%">
            <EditItemTemplate>
                <div class="row">
                    <div class="col-md-6 card card-body">
                        <h3>Update Information</h3>

                        <div class="form-group">
                            <label>Name</label>
                            <asp:TextBox ID="NameTextBox" CssClass="form-control" runat="server" Text='<%# Bind("Name") %>' />
                        </div>
                        <div class="form-group">
                            <label>Father&#39;s Name</label>
                            <asp:TextBox ID="TextBox2" runat="server" CssClass="form-control" Text='<%# Bind("FatherName") %>' />
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
                            <label>Date of Birth</label>
                            <asp:TextBox ID="DateofBirth" CssClass="form-control datepicker" runat="server" Text='<%# Bind("DateofBirth") %>' />
                        </div>
                        <div class="form-group">
                            <label>Gender</label>
                            <asp:RadioButtonList ID="GenderRadioButtonList" CssClass="form-control" runat="server" RepeatDirection="Horizontal" SelectedValue='<%# Bind("Gender") %>'>
                                <asp:ListItem>Male</asp:ListItem>
                                <asp:ListItem>Female</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="form-group">
                            <label>Applicant Photo</label>
                            <div class="custom-file">
                                <asp:FileUpload class="custom-file-input" ID="MemberFileUpload" runat="server" accept="image/*" />
                                <label class="custom-file-label">Choose file</label>
                            </div>
                        </div>
                        <div>
                            <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="True" CommandName="Update" Text="Update" CssClass="btn btn-primary" />
                            &nbsp;<asp:LinkButton ID="LinkButton3" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" CssClass="btn btn-outline-primary btn-md" />
                        </div>
                    </div>
                </div>
            </EditItemTemplate>

            <ItemTemplate>
                <div class="my-3">
                    <h2 class="mb-0 font-weight-bold"><%# Eval("Name") %></h2>
                    <div class="text-muted">
                        <span>
                            <i class="fas fa-phone"></i>
                            <%# Eval("Phone") %>
                        </span>
                        <span>
                            <i class="fas fa-clock"></i>
                            <%# Eval("SignUpDate","{0:d MMMM yyyy}") %>
                        </span>
                    </div>
                    <asp:LinkButton ID="LinkButton1" class="btn btn-primary" runat="server" CausesValidation="False" CommandName="Edit">
                       <i class="fas fa-edit"></i> Edit 
                    </asp:LinkButton>
                </div>
            </ItemTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="MemberSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>"
            SelectCommand="SELECT Registration.Name, Registration.Phone, Registration.Email, Member.MemberID, Registration.RegistrationID, Registration.FatherName, Registration.MotherName, Registration.Present_Address, Registration.Permanent_Address, Registration.DateofBirth, Registration.Gender, Registration.BloodGroup, Registration.NationalID, Member.SignUpDate FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE (Member.InstitutionID = @InstitutionID) AND (Registration.RegistrationID = @RegistrationID)"
            UpdateCommand="UPDATE Registration SET Name = @Name, FatherName = @FatherName, DateofBirth = @DateofBirth, Gender = @Gender, Present_Address = @Present_Address, Email = @Email FROM Registration INNER JOIN Member ON Registration.RegistrationID = Member.MemberRegistrationID WHERE (Member.MemberID = @MemberID)">
            <SelectParameters>
                <asp:SessionParameter Name="InstitutionID" SessionField="InstitutionID" />
                <asp:SessionParameter Name="RegistrationID" SessionField="RegistrationID" />
            </SelectParameters>
            <UpdateParameters>
                <asp:SessionParameter Name="MemberID" SessionField="MemberID" />
                <asp:Parameter Name="FatherName" />
                <asp:Parameter Name="Email" />
                <asp:Parameter Name="DateofBirth" />
                <asp:Parameter Name="Gender" />
                <asp:Parameter Name="Present_Address" />
                <asp:Parameter Name="Name" />
            </UpdateParameters>
        </asp:SqlDataSource>
    </div>

    <asp:FormView ID="BonusFormView" runat="server" DataSourceID="BonusSQL" Width="100%">
        <ItemTemplate>
            <h3><strong>Balance: ৳<%#Eval("Available_Balance","{0:N}") %></strong></h3>
            <div class="row">
                <div class="col-sm-4">
                    <div class="Comission">
                        <h5>Referral Commission</h5>
                        <a href="Bonus_Details/Referral_Bonus_Details.aspx"><%#Eval("Referral_Income","{0:N}") %><i class="fas fa-long-arrow-alt-right ml-1"></i></a>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="Comission">
                        <h5>Generation Commission</h5>
                        <a href="Bonus_Details/Generation_Bonus_Details.aspx"><%#Eval("Generation_Income","{0:N}") %><i class="fas fa-long-arrow-alt-right ml-1"></i></a>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="Comission">
                        <h5>Retail Commission</h5>
                        <a href="Bonus_Details/Cash_Back.aspx"><%#Eval("Instant_Cash_Back_Income","{0:N}") %><i class="fas fa-long-arrow-alt-right ml-1"></i></a>
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

    <asp:SqlDataSource ID="BonusSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Referral_Income, Generation_Income, Instant_Cash_Back_Income, Available_Balance, SignUpDate, Total_Amount, Withdraw_Balance, Send_Balance, Received__Balance FROM Member WHERE (MemberID = @MemberID)">
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
                    <div class="card">
                        <div class="card-header">
                            <h4><%# Eval("Notice_Title") %></h4>
                            <em style="color: #6F196E">View Date: <%# Eval("Start_Date","{0: d MMM yyyy}") %> - <%# Eval("End_Date","{0: d MMM yyyy}") %></em>
                        </div>

                        <div class="card-body">
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
