<%@ Page Title="Generation Commission" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Generation_Bonus_Details.aspx.cs" Inherits="CncAgro.AccessMember.Bonus_Details.Generation_Bonus_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Generation Commission</h3>
      <a class="Sub_Link" href="../Point_And_Bonus_Details.aspx"><< Back To Previous</a>
   <asp:GridView ID="GenerationGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="Records_GenerationSQL" AllowPaging="True" PageSize="50">
      <Columns>
         <asp:BoundField DataField="UserName" HeaderText="UserName" SortExpression="UserName" />
         <asp:BoundField DataField="Generation" HeaderText="Generation" SortExpression="Generation" />
          <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" />
          <asp:BoundField DataField="Tax_Service_Charge" HeaderText="Tax_Service_Charge" SortExpression="Tax_Service_Charge" />
          <asp:BoundField DataField="Net_Amount" HeaderText="Net_Amount" SortExpression="Net_Amount" ReadOnly="True" />
         <asp:BoundField DataField="Insert_Date" HeaderText="Insert_Date" SortExpression="Insert_Date" />
      </Columns>
        <EmptyDataTemplate>
         Empty
      </EmptyDataTemplate>
      <PagerStyle CssClass="pgr" />
   </asp:GridView>
   <asp:SqlDataSource ID="Records_GenerationSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Member.MemberID, Registration.UserName, Member_Bouns_Records_Generation.Generation, Member_Bouns_Records_Generation.Amount, Member_Bouns_Records_Generation.Tax_Service_Charge, Member_Bouns_Records_Generation.Net_Amount, Member_Bouns_Records_Generation.Insert_Date, Member_Bouns_Records_Generation.GenerationMemberID, Member_Bouns_Records_Generation.Generation_Income_RecordsID FROM Registration INNER JOIN Member ON Registration.RegistrationID = Member.MemberRegistrationID INNER JOIN Member_Bouns_Records_Generation ON Member.MemberID = Member_Bouns_Records_Generation.MemberID WHERE (Member_Bouns_Records_Generation.GenerationMemberID = @MemberID)">
      <SelectParameters>
         <asp:SessionParameter Name="MemberID" SessionField="MemberID" Type="Int32" />
      </SelectParameters>
   </asp:SqlDataSource>
</asp:Content>
