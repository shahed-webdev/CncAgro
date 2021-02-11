<%@ Page Title="Commission Record" Language="C#" MasterPageFile="~/Seller.Master" AutoEventWireup="true" CodeBehind="Commission_Records.aspx.cs" Inherits="CncAgro.AccessSeller.Commission_Records" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Commission Record</h3>
    <asp:GridView ID="CommissionGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="CommissionSQL">
        <Columns>
            <asp:BoundField DataField="Shop_Name" HeaderText="Shop Name" SortExpression="Shop_Name" />
            <asp:BoundField DataField="UserName" HeaderText="Username" SortExpression="UserName" />
            <asp:BoundField DataField="Commission_Point" HeaderText="Commission Point" SortExpression="Commission_Point" />
            <asp:BoundField DataField="Commission" HeaderText="Commission" SortExpression="Commission" />
            <asp:BoundField DataField="ServiceCharge" HeaderText="Service Charge" SortExpression="ServiceCharge" />
            <asp:BoundField DataField="NetAmount" HeaderText="Net Amount" ReadOnly="True" SortExpression="NetAmount" />
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="CommissionSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Seller_Commission.Commission_Point, Seller_Commission.Commission, Seller_Commission.ServiceCharge, Seller_Commission.NetAmount, Seller.Shop_Name, Registration.UserName FROM Seller_Commission INNER JOIN Seller ON Seller_Commission.SellerID = Seller.SellerID INNER JOIN Registration ON Seller.SellerRegistrationID = Registration.RegistrationID WHERE (Seller_Commission.Commission_SellerID = @Commission_SellerID)">
        <SelectParameters>
            <asp:SessionParameter Name="Commission_SellerID" SessionField="SellerID" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
