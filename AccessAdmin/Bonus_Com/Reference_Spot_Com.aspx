<%@ Page Title="Reference & Spot Commission" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Reference_Spot_Com.aspx.cs" Inherits="CncAgro.AccessAdmin.Bonus_Com.Reference_Spot_Com" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Reference & Spot Commission</h3>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:GridView ID="RecordGridView" AllowPaging="true" AllowSorting="true" PageSize="100" runat="server" AutoGenerateColumns="False" DataSourceID="RecordsSQL" CssClass="mGrid">
                <Columns>
                    <asp:BoundField DataField="RefarelUserID" HeaderText="Referral Member" SortExpression="RefarelUserID" />
                    <asp:BoundField DataField="SpotUserID" HeaderText="Spot Member" SortExpression="SpotUserID" />
                    <asp:BoundField DataField="Package_Point" HeaderText="Point" SortExpression="Package_Point" />
                    <asp:BoundField DataField="Commission_Amount" HeaderText="Commission" SortExpression="Commission_Amount" />
                    <asp:BoundField DataField="Tax_Service_Charge" HeaderText="Tax &amp; Charge" SortExpression="Tax_Service_Charge" />
                    <asp:BoundField DataField="Net_Amount" HeaderText="Net" ReadOnly="True" SortExpression="Net_Amount" />
                    <asp:BoundField DataField="Insert_Date" HeaderText="Date" SortExpression="Insert_Date" DataFormatString="{0:d MMM yyyy}" />
                </Columns>
                <EmptyDataTemplate>
                    No Record
                </EmptyDataTemplate>
                <PagerStyle CssClass="pgr" />
            </asp:GridView>
            <asp:SqlDataSource ID="RecordsSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration_1.UserName AS RefarelUserID, Registration.UserName AS SpotUserID, Member_Package.Package_Name, Member_Bouns_Records_Referral.Package_Point, Member_Bouns_Records_Referral.Commission_Amount, Member_Bouns_Records_Referral.Tax_Service_Charge, Member_Bouns_Records_Referral.Net_Amount, Member_Bouns_Records_Referral.Insert_Date FROM Registration INNER JOIN Member INNER JOIN Member AS Member_1 INNER JOIN Member_Bouns_Records_Referral ON Member_1.MemberID = Member_Bouns_Records_Referral.Referral_MemberID INNER JOIN Registration AS Registration_1 ON Member_1.MemberRegistrationID = Registration_1.RegistrationID ON Member.MemberID = Member_Bouns_Records_Referral.Upgraded_Pack_MemberID ON Registration.RegistrationID = Member.MemberRegistrationID INNER JOIN Member_Package ON Member_Bouns_Records_Referral.Package_Serial = Member_Package.Package_Serial"></asp:SqlDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
