<%@ Page Title="Change Password" Language="C#" MasterPageFile="~/Design.Master" AutoEventWireup="true" CodeBehind="Change_Password.aspx.cs" Inherits="CncAgro.Access_Authority.Change_Password" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="container">
        <h3>Change Password</h3>
        <asp:ChangePassword ID="ChangePassword1" runat="server" ChangePasswordFailureText="Password incorrect or New Password invalid." Width="100%">
            <ChangePasswordTemplate>
                <div class="well">
                <div class="form-group">
                    <label>
                        Old Password
                                          <asp:RequiredFieldValidator ID="CurrentPasswordRequired" runat="server" ControlToValidate="CurrentPassword" CssClass="Rf-Error" ErrorMessage="*" ValidationGroup="ChangePassword1" /></label>
                    <asp:TextBox ID="CurrentPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>
                        New Password
                                          <asp:RequiredFieldValidator ID="NewPasswordRequired" runat="server" ControlToValidate="NewPassword" CssClass="Rf-Error" ErrorMessage="*" ValidationGroup="ChangePassword1" /></label>
                    <asp:TextBox ID="NewPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>
                        Confirm New Password
                              <asp:RequiredFieldValidator ID="ConfirmNewPasswordRequired" runat="server" ControlToValidate="ConfirmNewPassword" CssClass="Rf-Error" ErrorMessage="*" ValidationGroup="ChangePassword1" />
                        <asp:CompareValidator ID="NewPasswordCompare" runat="server" ControlToCompare="NewPassword" ControlToValidate="ConfirmNewPassword" CssClass="Rf-Error" Display="Dynamic" ErrorMessage="The Confirm New Password must match the New Password entry." ValidationGroup="ChangePassword1"></asp:CompareValidator>
                    </label>
                    <asp:TextBox ID="ConfirmNewPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                </div>
                <div class="form-group">
                    <asp:Button ID="ChangePasswordPushButton" runat="server" CommandName="ChangePassword" CssClass="btn btn-primary" Text="Change" ValidationGroup="ChangePassword1" />
                    <asp:Button ID="CancelPushButton" runat="server" CausesValidation="False" CommandName="Cancel" CssClass="btn btn-primary" Text="Cancel" />
                </div>
                <div class="Rf-Error">
                    <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                </div>
                    </div>
            </ChangePasswordTemplate>
            <SuccessTemplate>
                <div class="alert alert-success">
                    Your password has been changed
                         <asp:Button ID="ContinuePushButton" runat="server" CausesValidation="False" CommandName="Continue" CssClass="btn btn-primary" PostBackUrl="~/Profile_Redirect.aspx" Text="Continue" />
                </div>
            </SuccessTemplate>
        </asp:ChangePassword>
    </div>
</asp:Content>
