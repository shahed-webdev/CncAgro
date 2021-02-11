<%@ Page Title="Duplex Commission" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Infinity_Bonus_Details.aspx.cs" Inherits="CncAgro.AccessMember.Bonus_Details.Infinity_Bonus_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
   <h3>Duplex Commission</h3>
   <a class="Sub_Link" href="../MemberProfile.aspx"><< Back To Previous</a>
   <asp:GridView ID="Records_Infinity_MatchingGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataKeyNames="Infinity_Matching_Income_RecordsID" DataSourceID="Records_Infinity_MatchingSQL" AllowPaging="True" PageSize="50">
      <Columns>
         <asp:BoundField DataField="Matching_Point" HeaderText="Matching Point" SortExpression="Matching_Point" />
         <asp:BoundField DataField="Flash_Point" HeaderText="Flash Point" SortExpression="Flash_Point" />
         <asp:BoundField DataField="Carry_Point" HeaderText="Carry Point" SortExpression="Carry_Point" />
         <asp:BoundField DataField="Weak_Side" HeaderText="Weak Side" SortExpression="Weak_Side" />
         <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" />
         <asp:BoundField DataField="Tax_Service_Charge" HeaderText="Tax &amp; Service Charge" SortExpression="Tax_Service_Charge" />
         <asp:BoundField DataField="Net_Amount" HeaderText="Net Amount" ReadOnly="True" SortExpression="Net_Amount" />
      </Columns>
      <EmptyDataTemplate>
         Empty
      </EmptyDataTemplate>
      <PagerStyle CssClass="pgr" />
   </asp:GridView>
   <asp:SqlDataSource ID="Records_Infinity_MatchingSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Infinity_Matching_Income_RecordsID, RegistrationID, MemberID, Package_Serial, Matching_Point, Flash_Point, Carry_Point, Weak_Side, Amount, Tax_Service_Charge, Net_Amount, Insert_Date FROM Member_Bouns_Records_Infinity_Matching WHERE (MemberID = @MemberID)">
      <SelectParameters>
         <asp:SessionParameter Name="MemberID" SessionField="MemberID" Type="Int32" />
      </SelectParameters>
   </asp:SqlDataSource>
</asp:Content>
