<%@ Page Title="Referral Commission" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Referral_Bonus_Details.aspx.cs" Inherits="CncAgro.AccessMember.Bonus_Details.Referral_Bonus_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
   <h3>Referral Commission</h3>
   <a class="Sub_Link" href="../MemberProfile.aspx"><< Back To Previous</a>
   <asp:GridView ID="Referral_GridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="Referral_SQL" AllowPaging="True" PageSize="50">
      <Columns>
         <asp:BoundField DataField="UserName" HeaderText="Customer Userid" SortExpression="UserName" />
         <asp:BoundField DataField="Package_Point" HeaderText="Point" SortExpression="Package_Point" />
         <asp:BoundField DataField="Commission_Amount" HeaderText="Commission Amount" SortExpression="Commission_Amount" />
         <asp:BoundField DataField="Tax_Service_Charge" HeaderText="Tax &amp; Service Charge" SortExpression="Tax_Service_Charge" />
         <asp:BoundField DataField="Net_Amount" HeaderText="Net Amount" ReadOnly="True" SortExpression="Net_Amount" />
      </Columns>
      <EmptyDataTemplate>
         Empty
      </EmptyDataTemplate>
      <PagerStyle CssClass="pgr" />
   </asp:GridView>
   <asp:SqlDataSource ID="Referral_SQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Member_Bouns_Records_Referral.Upgraded_Pack_MemberID, Member_Bouns_Records_Referral.Package_Serial, Member_Bouns_Records_Referral.Package_Point, Member_Bouns_Records_Referral.Commission_Amount, Member_Bouns_Records_Referral.Tax_Service_Charge, Member_Bouns_Records_Referral.Net_Amount, Member_Bouns_Records_Referral.Insert_Date, Registration.UserName, Member_Package.Member_Package_Short_Key FROM Registration INNER JOIN Member ON Registration.RegistrationID = Member.MemberRegistrationID INNER JOIN Member_Bouns_Records_Referral ON Member.MemberID = Member_Bouns_Records_Referral.Upgraded_Pack_MemberID INNER JOIN Member_Package ON Member_Bouns_Records_Referral.Package_Serial = Member_Package.Package_Serial WHERE (Member_Bouns_Records_Referral.Referral_MemberID = @MemberID)">
      <SelectParameters>
         <asp:SessionParameter Name="MemberID" SessionField="MemberID" Type="Int32" />
      </SelectParameters>
   </asp:SqlDataSource>
</asp:Content>
