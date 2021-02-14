<%@ Page Title="Generation Commission" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Generation_Commission.aspx.cs" Inherits="CncAgro.AccessAdmin.Bonus_Com.Duplex_Commission" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .Archivers { margin-bottom: 2px; font-size: 18px; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Generation Commission</h3>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:GridView ID="RecordGridView" AllowPaging="True" AllowSorting="True" PageSize="100" runat="server" AutoGenerateColumns="False" DataSourceID="RecordsSQL" CssClass="mGrid" DataKeyNames="Generation_Income_RecordsID">
                <Columns>
                    <asp:BoundField DataField="UserName" HeaderText="User Id" SortExpression="UserName" />
                    <asp:BoundField DataField="GenerationUser" HeaderText="Generation User" SortExpression="GenerationUser" />
                    <asp:BoundField DataField="Generation" HeaderText="Generation" SortExpression="Generation" />
                    <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" />
                    <asp:BoundField DataField="Tax_Service_Charge" HeaderText="Tax/Service Charge" SortExpression="Tax_Service_Charge" />
                    <asp:BoundField DataField="Net_Amount" HeaderText="Net Amount" ReadOnly="True" SortExpression="Net_Amount" />
                    <asp:BoundField DataField="Insert_Date" HeaderText="Date" SortExpression="Insert_Date" />
                </Columns>
                <EmptyDataTemplate>
                    No Record
                </EmptyDataTemplate>
                <PagerStyle CssClass="pgr" />
            </asp:GridView>
            <asp:SqlDataSource ID="RecordsSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.UserName, Member_Bouns_Records_Generation.Generation, Member_Bouns_Records_Generation.Amount, Member_Bouns_Records_Generation.Tax_Service_Charge, Member_Bouns_Records_Generation.Net_Amount, Member_Bouns_Records_Generation.Insert_Date, Member_Bouns_Records_Generation.GenerationMemberID, Member_Bouns_Records_Generation.Generation_Income_RecordsID, Registration_1.UserName AS GenerationUser, Member_Bouns_Records_Generation.MemberID FROM Registration INNER JOIN Member ON Registration.RegistrationID = Member.MemberRegistrationID INNER JOIN Member_Bouns_Records_Generation ON Member.MemberID = Member_Bouns_Records_Generation.MemberID INNER JOIN Member AS Member_1 ON Member_Bouns_Records_Generation.GenerationMemberID = Member_1.MemberID INNER JOIN Registration AS Registration_1 ON Member_1.MemberRegistrationID = Registration_1.RegistrationID"></asp:SqlDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
