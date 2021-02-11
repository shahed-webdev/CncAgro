<%@ Page Title="Default Customer" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Default_Member.aspx.cs" Inherits="CncAgro.AccessAdmin.Member.Default_Member" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
      .M_Info {background-color: #fff; border: 1px solid #ced4d4; font-size: 16px; margin: 8px 0; padding: 6px 7px; }
   </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Default Customer</h3>
   <asp:FormView ID="DefaultMemberFormView" runat="server" DataKeyNames="MemberID" DataSourceID="DefaultMemberSQL" Width="100%">
      <ItemTemplate>
           <div class="M_Info">
            User Id:
            <asp:Label ID="Label1" runat="server" Text='<%# Bind("UserName") %>' />
         </div>
         <div class="M_Info">
            Name:
            <asp:Label ID="NameLabel" runat="server" Text='<%# Bind("Name") %>' />
         </div>
         <div class="M_Info">
            Phone:
            <asp:Label ID="PhoneLabel" runat="server" Text='<%# Bind("Phone") %>' />
         </div>
         <div class="M_Info">
            Email:
            <asp:Label ID="EmailLabel" runat="server" Text='<%# Bind("Email") %>' />
         </div>
      </ItemTemplate>
   </asp:FormView>
   <asp:SqlDataSource ID="DefaultMemberSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Member.MemberID, Member.MemberRegistrationID, Registration.Name, Registration.FatherName, Registration.UserName, Registration.Phone, Registration.Email, Registration.Gender FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID"></asp:SqlDataSource>
</asp:Content>
