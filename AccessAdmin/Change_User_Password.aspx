<%@ Page Title="Change Password" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Change_User_Password.aspx.cs" Inherits="CncAgro.AccessAdmin.Change_User_Password" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>
        <asp:FormView ID="UserInfoFormView" DataKeyNames="UserName,Password" runat="server" DataSourceID="UserInfoSQL">
            <ItemTemplate>
                Change Password for: <b class="alert-success"><%#Eval("UserName") %></b>
            </ItemTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="UserInfoSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.UserName, User_Login_Info.Password FROM Registration INNER JOIN User_Login_Info ON Registration.UserName = User_Login_Info.UserName WHERE (Registration.RegistrationID = @RegistrationID)">
            <SelectParameters>
                <asp:QueryStringParameter Name="RegistrationID" QueryStringField="reg" />
            </SelectParameters>
        </asp:SqlDataSource>
    </h3>

    <%if (UserInfoFormView.DataItemCount > 0)
        {%>
    <div class="col-md-6 card">
        <div class="form-group">
            <label>
                New Password
             <asp:RequiredFieldValidator ID="PasswordRequiredValidator" runat="server" ControlToValidate="PasswordTextbox" Display="Static" ErrorMessage="*" ValidationGroup="1" CssClass="EroorStar" />
            </label>
            <asp:TextBox ID="PasswordTextbox" runat="server" TextMode="Password" CssClass="form-control" />
        </div>
        <div class="form-group">
            <label>
                Confirm Password
                <asp:RequiredFieldValidator ID="PasswordConfirmRequiredValidator" runat="server" ControlToValidate="PasswordConfirmTextbox" Display="Static" ErrorMessage="*" ValidationGroup="1" CssClass="EroorStar" />
                <asp:CompareValidator ID="PasswordConfirmCompareValidator" runat="server" ControlToValidate="PasswordConfirmTextbox" Display="Static" ControlToCompare="PasswordTextBox" ErrorMessage="Confirm password must match new password." ValidationGroup="1" CssClass="EroorStar" />
            </label>
            <asp:TextBox ID="PasswordConfirmTextbox" runat="server" TextMode="Password" CssClass="form-control" />
        </div>

        <asp:Button ID="ChangePasswordButton" Text="Change Password" OnClick="ChangePassword_OnClick" runat="server" CssClass="btn btn-primary" ValidationGroup="1" />
        <asp:SqlDataSource ID="User_Login_InfoSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM [User_Login_Info]" UpdateCommand="UPDATE User_Login_Info SET Password = @Password WHERE (UserName = @UserName)">
            <UpdateParameters>
                <asp:Parameter Name="UserName" />
                <asp:Parameter Name="Password" Type="String" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:Label ID="Msg" ForeColor="#339933" runat="server" />
        <asp:RegularExpressionValidator ID="RegExp1" runat="server"
            ErrorMessage="Password length must be between 6 to 30 characters (Allow only (_.)"
            ControlToValidate="PasswordTextbox"
            ValidationExpression="^[a-zA-Z0-9'_.\s]{6,30}$" CssClass="EroorStar" ValidationGroup="1" />

    </div>
    <%} %>
</asp:Content>
