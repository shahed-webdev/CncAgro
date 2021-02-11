<%@ Page Title="Change Password" Language="C#" MasterPageFile="~/Seller.Master" AutoEventWireup="true" CodeBehind="Change_Password.aspx.cs" Inherits="CncAgro.AccessSeller.Change_Password" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
   <h3>Change Password</h3>

  <asp:ChangePassword ID="ChangePassword" Width="100%" runat="server" ChangePasswordFailureText="Password incorrect or New Password invalid." OnChangedPassword="ChangePassword1_ChangedPassword">
        <ChangePasswordTemplate>
            <div class="well col-md-6">
                <div class="form-group">
                    <label>
                        Old Password 
                    <asp:RequiredFieldValidator ID="CurrentPasswordRequired" runat="server" ControlToValidate="CurrentPassword" CssClass="EroorStar" ErrorMessage="Password is required." ToolTip="Password is required." ValidationGroup="ChangePassword1">*</asp:RequiredFieldValidator></label>
                    <asp:TextBox ID="CurrentPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>
                        New Password<asp:RequiredFieldValidator ID="NewPasswordRequired" runat="server" ControlToValidate="NewPassword" CssClass="EroorStar" ErrorMessage="New Password is required." ToolTip="New Password is required." ValidationGroup="ChangePassword1">*</asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" ControlToValidate="NewPassword" CssClass="EroorStar" Display="Dynamic" ErrorMessage="Minimum 6 and Maximum 30 characters required." ValidationExpression="^[\s\S]{6,30}$" ValidationGroup="ChangePassword1"></asp:RegularExpressionValidator></label>
                    <asp:TextBox ID="NewPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>
                        New Password Again
                            <asp:RequiredFieldValidator ID="ConfirmNewPasswordRequired" runat="server" ControlToValidate="ConfirmNewPassword" CssClass="EroorStar" ErrorMessage="Confirm New Password is required." ToolTip="Confirm New Password is required." ValidationGroup="ChangePassword1">*</asp:RequiredFieldValidator>
                        <asp:CompareValidator ID="NewPasswordCompare" runat="server" ControlToCompare="NewPassword" ControlToValidate="ConfirmNewPassword" CssClass="EroorStar" Display="Dynamic" ErrorMessage="New password does not match" ValidationGroup="ChangePassword1"></asp:CompareValidator>
                    </label>
                    <asp:TextBox ID="ConfirmNewPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                </div>

                <div class="form-group">
                    <asp:Button ID="ChangePasswordPushButton" runat="server" CommandName="ChangePassword" CssClass="btn btn-primary" Text="Change" ValidationGroup="ChangePassword1" />
                    <asp:Button ID="CancelPushButton" runat="server" CausesValidation="False" CommandName="Cancel" CssClass="btn btn-primary" Text="Cancel" />
                </div>

                <div class="alert-danger">
                    <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                </div>
            </div>
        </ChangePasswordTemplate>
        <SuccessTemplate>
            <div class="alert alert-success">
                <label>Congratulation!! You have Successfully Changed Your Password!</label>
            </div>
            <asp:Button ID="ContinuePushButton" runat="server" CausesValidation="False" CommandName="Continue" CssClass="btn btn-primary" PostBackUrl="~/Profile_Redirect.aspx" Text="Continue" />
        </SuccessTemplate>
    </asp:ChangePassword>
    <asp:SqlDataSource ID="User_Login_InfoSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM [User_Login_Info]" UpdateCommand="UPDATE User_Login_Info SET Password = @Password WHERE (UserName = @UserName)">
        <UpdateParameters>
            <asp:Parameter Name="Password" Type="String" />
            <asp:Parameter Name="UserName" />
        </UpdateParameters>
    </asp:SqlDataSource>

   <script>
      $(document).ready(function () {
         $("#Password_C").addClass('L_Active');
      });
   </script>
</asp:Content>
