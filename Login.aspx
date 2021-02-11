<%@ Page Title="" Language="C#" MasterPageFile="~/Design.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="CncAgro.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/DNBLogin.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <asp:Login ID="CustomerLogin" runat="server" OnLoginError="CustomerLogin_LoginError" OnLoggedIn="CustomerLogin_LoggedIn" DestinationPageUrl="~/Profile_Redirect.aspx" Width="100%">
        <LayoutTemplate>
            <div class="container">
                <div class="card card-container">
                    <h2 class='login_title text-center'>Sign In</h2>
                    <hr />
                    <div class="form-signin">
                        <p class="input_title">
                            User ID
                     <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName" ErrorMessage="User Name is required." ForeColor="#CC0000" ToolTip="User Name is required." ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                        </p>
                        <asp:TextBox ID="UserName" runat="server" class="login_box" placeholder="user ID"></asp:TextBox>


                        <p class="input_title">
                            Password
                     <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password" ErrorMessage="Password is required." ForeColor="Red" ToolTip="Password is required." ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                        </p>
                        <asp:TextBox ID="Password" runat="server" class="login_box" placeholder="******" TextMode="Password"></asp:TextBox>

                        <asp:Button ID="LoginButton" runat="server" CommandName="Login" class="btn btn-lg btn-primary" Text="Sign In" ValidationGroup="Login1" />

                        <div class="alert-danger">
                            <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                        </div>
                    </div>
                </div>
            </div>
        </LayoutTemplate>
    </asp:Login>
    <asp:Label ID="InvalidErrorLabel" runat="server" CssClass="Error"></asp:Label>

</asp:Content>
