<%@ Page Title="Buying Details" Language="C#" MasterPageFile="~/Seller.Master" AutoEventWireup="true" CodeBehind="Buying_Details.aspx.cs" Inherits="CncAgro.AccessSeller.Buying_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Buying Details</h3>

    <a href="Order_Record.aspx"><i class="far fa-hand-point-left"></i>
        Back To Record</a>

    <div class="table-responsive">
        <asp:GridView ID="DetailsGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="DetailsSQL">
            <Columns>
                <asp:BoundField DataField="Product_Code" HeaderText="Code" SortExpression="Product_Code" />
                <asp:BoundField DataField="Product_Name" HeaderText="Product Name" SortExpression="Product_Name" />
                 <asp:BoundField DataField="SellingQuantity" HeaderText="Quantity" SortExpression="SellingQuantity" />
                <asp:BoundField DataField="SellingUnitPrice" HeaderText="Unit Price" SortExpression="SellingUnitPrice" />
                <asp:BoundField DataField="SellingUnitPoint" HeaderText="Unit Point" SortExpression="SellingUnitPoint" />
                <asp:BoundField DataField="SellingUnit_Commission" HeaderText="Unit Comm." SortExpression="SellingUnit_Commission" />
                <asp:BoundField DataField="ProductPrice" HeaderText="Total Price" ReadOnly="True" SortExpression="ProductPrice" />
                <asp:BoundField DataField="TotalPoint" HeaderText="Total Point" ReadOnly="True" SortExpression="TotalPoint" />
                <asp:BoundField DataField="Total_Commission" HeaderText="Total Comm." ReadOnly="True" SortExpression="Total_Commission" />
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="DetailsSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_Point_Code.Product_Code, Product_Point_Code.Product_Name, Shopping_Distributor_Record.DistributorShoppingID, Shopping_Distributor_Record.SellingQuantity, Shopping_Distributor_Record.SellingUnitPrice, Shopping_Distributor_Record.SellingUnitPoint, Shopping_Distributor_Record.SellingUnit_Commission, Shopping_Distributor_Record.TotalPoint, Shopping_Distributor_Record.ProductPrice, Shopping_Distributor_Record.Total_Commission FROM Product_Point_Code INNER JOIN Shopping_Distributor_Record ON Product_Point_Code.Product_PointID = Shopping_Distributor_Record.ProductID WHERE (Shopping_Distributor_Record.DistributorShoppingID = @DistributorShoppingID)">
            <SelectParameters>
                <asp:QueryStringParameter Name="DistributorShoppingID" QueryStringField="ShoppingID" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>
