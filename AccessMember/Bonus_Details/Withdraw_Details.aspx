<%@ Page Title="" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Withdraw_Details.aspx.cs" Inherits="CncAgro.AccessMember.Bonus_Details.Withdraw_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
   <h3>Withdraw Details</h3>
   <a class="Sub_Link" href="../MemberProfile.aspx"><< Back To Previous</a>
   <asp:GridView ID="WithdrawGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="WithdrawSQL" AllowPaging="True" PageSize="50">
      <Columns>
         <asp:BoundField DataField="Withdraw_Amount" HeaderText="Withdraw Amount" SortExpression="Withdraw_Amount" />
         <asp:BoundField DataField="Withdraw_Date" HeaderText="Withdraw Date" SortExpression="Withdraw_Date" DataFormatString="{0:d MMM yyyy}" />
      </Columns>
      <PagerStyle CssClass="pgr" />
      <EmptyDataTemplate>
         Empty
      </EmptyDataTemplate>
   </asp:GridView>
   <asp:SqlDataSource ID="WithdrawSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Withdraw_Amount, Withdraw_Date FROM Fund_Withdraw WHERE (Withdraw_RegistrationID = @Withdraw_RegistrationID)">
      <SelectParameters>
         <asp:SessionParameter Name="Withdraw_RegistrationID" SessionField="RegistrationID" />
      </SelectParameters>
   </asp:SqlDataSource>
</asp:Content>
