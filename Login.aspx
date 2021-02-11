<%@ Page Title="" Language="C#" MasterPageFile="~/Design.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="CncAgro.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <asp:Label ID="InvalidErrorLabel" runat="server" CssClass="Error"></asp:Label>
    <asp:Login ID="CustomerLogin" runat="server" OnLoginError="CustomerLogin_LoginError" OnLoggedIn="CustomerLogin_LoggedIn" DestinationPageUrl="~/Profile_Redirect.aspx" Width="100%">
        <LayoutTemplate>
            <div class="container mt-5">
                <div class="row">
                    <div class="col-lg-5 mx-auto">
                        <div class="card card-body">
                                <div class="text-center">
                                    <h4 class="modal-title w-100 font-weight-bold">Sign in</h4>
                                </div>
                                <div class="mx-3">
                                    <div class="md-form mb-5">
                                        <i class="fas fa-envelope prefix grey-text"></i>
                                        <asp:TextBox ID="UserName" runat="server" CssClass="form-control"></asp:TextBox>
                                        <label for="body_CustomerLogin_UserName">
                                            User Id
                                                <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName" ErrorMessage="User Name is required." ForeColor="#CC0000" ToolTip="User Name is required." ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                                        </label>
                                    </div>

                                    <div class="md-form mb-4">
                                        <i class="fas fa-lock prefix grey-text"></i>
                                        <asp:TextBox ID="Password" runat="server" class="form-control" TextMode="Password"></asp:TextBox>
                                        <label for="body_CustomerLogin_Password">
                                            Your password
                                            <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password" ErrorMessage="Password is required." ForeColor="Red" ToolTip="Password is required." ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                                        </label>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-center">
                                    <asp:Button ID="LoginButton" runat="server" CommandName="Login" class="btn btn-primary" Text="Sign In" ValidationGroup="Login1" />
                                </div>
                                <div class="alert-danger">
                                    <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                                </div>
                            </div>
                    </div>
                </div>
            </div>
        </LayoutTemplate>
    </asp:Login>
   

</asp:Content>
