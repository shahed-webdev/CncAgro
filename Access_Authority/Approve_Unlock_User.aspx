<%@ Page Title="Approve/Unlock User" Language="C#" MasterPageFile="~/Design.Master" AutoEventWireup="true" CodeBehind="Approve_Unlock_User.aspx.cs" Inherits="CncAgro.Access_Authority.Approve_Unlock_User" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="container">
        <h3>Approve/Unlock <asp:Label runat="server" ID="UserNameLabel"></asp:Label></h3>

        <div class="form-group">
            <label>Approved</label>
            <asp:CheckBox ID="IsApproved" Text=" " runat="server" AutoPostBack="true" OnCheckedChanged="IsApproved_CheckedChanged" />
        </div>
        <div class="form-group">
            <label>Locked Out:</label>

            <asp:Label runat="server" ID="LastLockoutDateLabel"></asp:Label>
            <br />
            <asp:Button runat="server" ID="UnlockUserButton" CssClass="btn btn-primary" Text="Unlock User" OnClick="UnlockUserButton_Click" />

        </div>

        <div class="alert-success">
            <asp:Label ID="StatusMessage" CssClass="Important" runat="server"></asp:Label>
        </div>
    </div>
</asp:Content>
