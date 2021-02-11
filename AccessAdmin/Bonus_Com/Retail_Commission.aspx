<%@ Page Title="Retail Commission" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Retail_Commission.aspx.cs" Inherits="CncAgro.AccessAdmin.Bonus_Com.Retail_Commission" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Retail Commission</h3>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:GridView ID="Records_CachBackGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="Records_CachBackSQL" AllowPaging="True" PageSize="50">
                <Columns>
                    <asp:BoundField DataField="UserName" HeaderText="Buy Point ID" SortExpression="UserName" />
                    <asp:BoundField DataField="Commission_Point" HeaderText="Point" SortExpression="Commission_Point" />
                    <asp:BoundField DataField="Commission_Amount" HeaderText="Amount" SortExpression="Commission_Amount" />
                    <asp:BoundField DataField="Tax_Service_Charge" HeaderText="Tax &amp; Charge" SortExpression="Tax_Service_Charge" />
                    <asp:BoundField DataField="Net_Amount" HeaderText="Net" ReadOnly="True" SortExpression="Net_Amount" />
                </Columns>
                <EmptyDataTemplate>
                    Empty
                </EmptyDataTemplate>
                <PagerStyle CssClass="pgr" />
            </asp:GridView>
            <asp:SqlDataSource ID="Records_CachBackSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Member_Bouns_Records_Gen_Retails.Commission_Point, Member_Bouns_Records_Gen_Retails.Commission_Amount, Member_Bouns_Records_Gen_Retails.Tax_Service_Charge, Member_Bouns_Records_Gen_Retails.Net_Amount, Member_Bouns_Records_Gen_Retails.Insert_Date, Registration.UserName, Member.MemberID FROM Member_Bouns_Records_Gen_Retails INNER JOIN Member ON Member_Bouns_Records_Gen_Retails.MemberID = Member.MemberID INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID"></asp:SqlDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
