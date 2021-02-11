<%@ Page Title="Profile" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Admin_Profile.aspx.cs" Inherits="CncAgro.AccessAdmin.Admin_Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Admin_Dashbord.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="well main-info">
        <asp:FormView ID="AdminFormView" runat="server" DataKeyNames="RegistrationID" DataSourceID="AdminSQL" OnItemUpdated="AdminFormView_ItemUpdated" Width="100%">
            <EditItemTemplate>
                <div class="col-md-6 col-sm-12">
                    <div class="form-group">
                        <label>Name</label>
                        <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control" Text='<%# Bind("Name") %>' />
                    </div>

                    <div class="form-group">
                        <label>Father&#39;s Name:</label>
                        <asp:TextBox ID="TextBox2" runat="server" CssClass="form-control" Text='<%# Bind("FatherName") %>' />
                    </div>
                    <div class="form-group">
                        <label>Mother's Name:</label>
                        <asp:TextBox ID="MotherNameTextBox" runat="server" CssClass="form-control" Text='<%# Bind("MotherName") %>' />
                    </div>

                    <div class="form-group">
                        <label>Mobile:</label>
                        <asp:TextBox ID="TextBox3" runat="server" CssClass="form-control" Text='<%# Bind("Phone") %>' />
                    </div>
                    <div class="form-group">
                        <label>Email:</label>
                        <asp:TextBox ID="TextBox4" runat="server" CssClass="form-control" Text='<%# Bind("Email") %>' />
                    </div>
                    <div class="form-group">
                        <label>Present Address:</label>
                        <asp:TextBox ID="Present_AddressTextBox" runat="server" CssClass="form-control" Text='<%# Bind("Present_Address") %>' TextMode="MultiLine" />
                    </div>
                    <div class="form-group">
                        <label>Permanent Address:</label>
                        <asp:TextBox ID="TextBox5" runat="server" CssClass="form-control" Text='<%# Bind("Permanent_Address") %>' TextMode="MultiLine" />
                    </div>
                    <div class="form-group">
                        <label>Image:</label>
                        <asp:FileUpload ID="AdminFileUpload" runat="server" />
                    </div>

                    <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="True" CommandName="Update" Text="Update" CssClass="btn btn-default" />
                    &nbsp;<asp:LinkButton ID="LinkButton3" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" CssClass="btn btn-default" />
                </div>
            </EditItemTemplate>

            <ItemTemplate>
                <div class="Info col-md-12">
                    <h3>
                        <i class="glyphicon glyphicon-user rest-userico"></i>
                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("Name") %>' />
                    </h3>

                    <ul>
                        <li>
                            <i class="glyphicon glyphicon-user rest-userico"></i>
                            <b>Father's Name:</b>
                            <asp:Label ID="FatherNameLabel" runat="server" Text='<%# Bind("FatherName") %>' />
                        </li>
                        <li>
                            <span class="glyphicon glyphicon-earphone"></span>
                            <b>Mobile:</b>
                            <asp:Label ID="PhoneLabel1" runat="server" Text='<%# Bind("Phone") %>' />
                        </li>
                        <li>
                            <span class="glyphicon glyphicon-envelope"></span>
                            <b>Email: </b>
                            <asp:Label ID="Label4" runat="server" Text='<%# Bind("Email") %>' />
                        </li>
                        <li>
                            <span class="glyphicon glyphicon-map-marker"></span>
                            <b>Address: </b>
                            <asp:Label ID="AddressLabel" runat="server" Text='<%# Bind("Present_Address") %>' />
                        </li>
                    </ul>
                </div>

                <div class="col-md-12">
                    <asp:LinkButton ID="LinkButton1" CssClass="btn btn-default" runat="server" CausesValidation="False" CommandName="Edit" Text="Update" />
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#myModal">Change Password</button>
                </div>
            </ItemTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="AdminSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT RegistrationID, Name, FatherName, MotherName, DateofBirth, BloodGroup, Gender, NationalID, Present_Address, Permanent_Address, Phone, Email FROM Registration WHERE (RegistrationID = @RegistrationID)" UpdateCommand="UPDATE Registration SET Name = @Name, FatherName = @FatherName, Phone = @Phone, Email = @Email, MotherName = @MotherName, Present_Address = @Present_Address, Permanent_Address = @Permanent_Address WHERE (RegistrationID = @RegistrationID)">
            <SelectParameters>
                <asp:SessionParameter Name="RegistrationID" SessionField="RegistrationID" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="Name" Type="String" />
                <asp:Parameter Name="FatherName" Type="String" />
                <asp:Parameter Name="Phone" Type="String" />
                <asp:Parameter Name="Email" />
                <asp:Parameter Name="MotherName" />
                <asp:Parameter Name="Present_Address" />
                <asp:Parameter Name="Permanent_Address" />
                <asp:Parameter Name="RegistrationID" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
    </div>

    <asp:FormView ID="SMSFormView" runat="server" DataSourceID="SMSSQL" Width="100%">
        <ItemTemplate>
            <div class="alert alert-success">Remaining SMS: <%# Eval("SMS_Balance") %></div>
        </ItemTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="SMSSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT SMS_Balance FROM Institution" ProviderName="<%$ ConnectionStrings:DBConnectionString.ProviderName %>"></asp:SqlDataSource>

    <!-- Modal -->
    <div id="myModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Change Password</h4>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                        <ContentTemplate>
                            <asp:ChangePassword Width="100%" ID="ChangePassword" runat="server" ChangePasswordFailureText="Password incorrect or New Password invalid." OnChangedPassword="ChangePassword1_ChangedPassword">
                                <ChangePasswordTemplate>
                                    <div class="form-group">
                                        <label>Old Password</label>
                                        <asp:RequiredFieldValidator ID="CurrentPasswordRequired" runat="server" ControlToValidate="CurrentPassword" CssClass="EroorStar" ErrorMessage="Password is required." ToolTip="Password is required." ValidationGroup="ChangePassword1">*</asp:RequiredFieldValidator>
                                        <asp:TextBox ID="CurrentPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                                    </div>
                                    <div class="form-group">
                                        <label>New Password</label>
                                        <asp:RequiredFieldValidator ID="NewPasswordRequired" runat="server" ControlToValidate="NewPassword" CssClass="EroorStar" ErrorMessage="New Password is required." ToolTip="New Password is required." ValidationGroup="ChangePassword1">*</asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" ControlToValidate="NewPassword" CssClass="EroorStar" Display="Dynamic" ErrorMessage="Minimum 6 and Maximum 30 characters required." ValidationExpression="^[\s\S]{6,30}$" ValidationGroup="ChangePassword1"></asp:RegularExpressionValidator>
                                        <asp:TextBox ID="NewPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                                    </div>
                                    <div class="form-group">
                                        <label>New Password Again</label>
                                        <asp:CompareValidator ID="NewPasswordCompare" runat="server" ControlToCompare="NewPassword" ControlToValidate="ConfirmNewPassword" CssClass="EroorStar" Display="Dynamic" ErrorMessage="New password does not match" ValidationGroup="ChangePassword1"></asp:CompareValidator>
                                        <asp:RequiredFieldValidator ID="ConfirmNewPasswordRequired" runat="server" ControlToValidate="ConfirmNewPassword" CssClass="EroorStar" ErrorMessage="Confirm New Password is required." ToolTip="Confirm New Password is required." ValidationGroup="ChangePassword1">*</asp:RequiredFieldValidator>
                                        <asp:TextBox ID="ConfirmNewPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                                    </div>
                                    <div class="form-group">
                                        <asp:Button ID="ChangePasswordPushButton" runat="server" CommandName="ChangePassword" CssClass="btn btn-primary" Text="Change" ValidationGroup="ChangePassword1" />
                                        <asp:Button ID="CancelPushButton" runat="server" CausesValidation="False" CommandName="Cancel" CssClass="btn btn-primary" Text="Cancel" />
                                        <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                                    </div>
                                </ChangePasswordTemplate>
                                <SuccessTemplate>
                                    <div class="alert alert-success">
                                        <label>Congratulation!!</label>
                                        <label>You have Successfully Changed Your Password!</label>
                                        <asp:Button ID="ContinuePushButton" runat="server" CausesValidation="False" CommandName="Continue" CssClass="btn btn-primary" PostBackUrl="~/Profile_Redirect.aspx" Text="Continue" />
                                    </div>
                                </SuccessTemplate>
                            </asp:ChangePassword>
                            <asp:SqlDataSource ID="User_Login_InfoSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM [User_Login_Info]" UpdateCommand="UPDATE User_Login_Info SET Password = @Password WHERE (UserName = @UserName)">
                                <UpdateParameters>
                                    <asp:Parameter Name="Password" Type="String" />
                                    <asp:Parameter Name="UserName" />
                                </UpdateParameters>
                            </asp:SqlDataSource>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
