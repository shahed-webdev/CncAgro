<%@ Page Title="Stock Details" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Seller_Products_Stock_Details.aspx.cs" Inherits="CncAgro.AccessAdmin.Seller.Seller_Products_Stock_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .Box { color: #fff; padding: 15px; font-size: 15px; margin-bottom: 15px; }
            .Box h5 { font-size: 20px; }

        .Total_Stock { background-color: #2F4254; }
        .Total_Price { background-color: #6F196E; }
        .Total_Point { background-color: #F39C12; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <asp:FormView ID="SellerFormView" runat="server" DataSourceID="SellerSQL" Width="100%">
        <ItemTemplate>
            <h3>Stock Details For:
         <asp:Label ID="NameLabel" runat="server" Text='<%# Bind("Name") %>' />
            </h3>
        </ItemTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="SellerSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.Name + '(' + Registration.UserName + ')' AS Name FROM Seller INNER JOIN Registration ON Seller.SellerRegistrationID = Registration.RegistrationID WHERE (Seller.SellerID = @SellerID)">
        <SelectParameters>
            <asp:QueryStringParameter Name="SellerID" QueryStringField="d" />
        </SelectParameters>
    </asp:SqlDataSource>


    <asp:FormView ID="Stock_FormView" runat="server" DataSourceID="StockSQL" Width="100%">
        <ItemTemplate>
            <div class="row text-center">
                <div class="col-sm-4">
                    <div class="Total_Stock Box">
                        <h5><%# Eval("Total_Stock") %></h5>
                        <small>STOCK QUANTITY</small>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="Total_Price Box">
                        <h5><%# Eval("Total_Price") %> Tk</h5>
                        <small>TOTAL PRICE</small>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="Total_Point Box">
                        <h5><%# Eval("Total_Point") %></h5>
                        <small>TOTAL POINT</small>
                    </div>
                </div>
            </div>
        </ItemTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="StockSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT SUM(Seller_Product.SellerProduct_Stock) AS Total_Stock, SUM(Seller_Product.SellerProduct_Stock * Product_Point_Code.Product_Point) AS Total_Point, SUM(Seller_Product.SellerProduct_Stock * Product_Point_Code.Product_Price) AS Total_Price FROM Seller_Product INNER JOIN Product_Point_Code ON Seller_Product.Product_PointID = Product_Point_Code.Product_PointID WHERE (Seller_Product.SellerID = @SellerID)">
        <SelectParameters>
            <asp:QueryStringParameter Name="SellerID" QueryStringField="d" />
        </SelectParameters>
    </asp:SqlDataSource>

    <a href="Seller_List.aspx" class="btn btn-success" style="margin-bottom:10px;"><< Back</a>
    <asp:GridView ID="ProductGridView" runat="server" AllowSorting="true" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="Seller_ProductSQL">
        <Columns>
            <asp:BoundField DataField="Product_Code" HeaderText="P.Code" SortExpression="Product_Code" />
            <asp:BoundField DataField="Product_Name" HeaderText="P.Name" SortExpression="Product_Name" />
            <asp:BoundField DataField="Product_Price" HeaderText="Price" SortExpression="Product_Price" />
            <asp:BoundField DataField="Product_Point" HeaderText="Point" SortExpression="Product_Point" />
            <asp:BoundField DataField="SellerProduct_Stock" HeaderText="Stock" SortExpression="SellerProduct_Stock" />
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="Seller_ProductSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_Point_Code.Product_Code, Product_Point_Code.Product_Name, Product_Point_Code.Product_Price, Product_Point_Code.Product_Point, Seller_Product.SellerProduct_Stock FROM Seller_Product INNER JOIN Product_Point_Code ON Seller_Product.Product_PointID = Product_Point_Code.Product_PointID WHERE (Seller_Product.SellerID = @SellerID) AND (Seller_Product.SellerProduct_Stock &lt;&gt; 0) ORDER BY Seller_Product.SellerProduct_Stock DESC">
        <SelectParameters>
            <asp:QueryStringParameter Name="SellerID" QueryStringField="d" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
