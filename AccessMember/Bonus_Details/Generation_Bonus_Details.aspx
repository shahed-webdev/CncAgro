<%@ Page Title="Generation Commission" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Generation_Bonus_Details.aspx.cs" Inherits="CncAgro.AccessMember.Bonus_Details.Generation_Bonus_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Generation Commission</h3>
      <a class="Sub_Link" href="../Point_And_Bonus_Details.aspx"><< Back To Previous</a>
   <asp:GridView ID="GenerationGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataKeyNames="Generation_UniLevel_RecordsID" DataSourceID="Records_GenerationSQL" AllowPaging="True" PageSize="50">
      <Columns>
         <asp:BoundField DataField="UserName" HeaderText="Buy Point ID" SortExpression="UserName" />
         <asp:BoundField DataField="Generation_Details" HeaderText="Generation" SortExpression="Generation" />
         <asp:BoundField DataField="Commission_Point" HeaderText="Point" SortExpression="Commission_Point" />
         <asp:BoundField DataField="Commission_Amount" HeaderText="Amount" SortExpression="Commission_Amount" />
          <asp:BoundField DataField="Tax_Service_Charge" HeaderText="Tax &amp; Charge" SortExpression="Tax_Service_Charge" />
          <asp:BoundField DataField="Net_Amount" HeaderText="Net" ReadOnly="True" SortExpression="Net_Amount" />
          <asp:BoundField DataField="Insert_Date" HeaderText="Date" SortExpression="Insert_Date" />
      </Columns>
        <EmptyDataTemplate>
         Empty
      </EmptyDataTemplate>
      <PagerStyle CssClass="pgr" />
   </asp:GridView>
   <asp:SqlDataSource ID="Records_GenerationSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Member.MemberID, Member_Bouns_Records_Gen_UniLevel.Generation_UniLevel_RecordsID, Member_Bouns_Records_Gen_UniLevel.Generation_MemberID, Registration.UserName, Generation_Uni_Level.Generation_Details, Member_Bouns_Records_Gen_UniLevel.Generation, Member_Bouns_Records_Gen_UniLevel.Commission_Point, Member_Bouns_Records_Gen_UniLevel.Commission_Amount, Member_Bouns_Records_Gen_UniLevel.Tax_Service_Charge, Member_Bouns_Records_Gen_UniLevel.Net_Amount, Member_Bouns_Records_Gen_UniLevel.Insert_Date FROM Registration INNER JOIN Member ON Registration.RegistrationID = Member.MemberRegistrationID INNER JOIN Member_Bouns_Records_Gen_UniLevel ON Member.MemberID = Member_Bouns_Records_Gen_UniLevel.MemberID INNER JOIN Generation_Uni_Level ON Member_Bouns_Records_Gen_UniLevel.Generation = Generation_Uni_Level.Generation WHERE (Member_Bouns_Records_Gen_UniLevel.Generation_MemberID = @MemberID)">
      <SelectParameters>
         <asp:SessionParameter Name="MemberID" SessionField="MemberID" Type="Int32" />
      </SelectParameters>
   </asp:SqlDataSource>
</asp:Content>
