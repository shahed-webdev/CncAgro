<%@ Page Title="Stock Details" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Product_stock.aspx.cs" Inherits="CncAgro.AccessMember.Selling.Product_stock" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Product Stock</h3>

    <div class="form-inline">
        <div class="form-group">
            <asp:TextBox ID="FindTextBox" placeholder="Find By Code , Name" runat="server" CssClass="form-control"></asp:TextBox>
        </div>
        <div class="form-group">
            <asp:Button ID="FindButton" runat="server" CssClass="btn btn-primary" Text="Find" />
        </div>
    </div>

    <div class="card card-body mt-4">
        <asp:FormView ID="Stock_FormView" runat="server" DataSourceID="StockSQL" Width="100%">
            <ItemTemplate>
                <h4 class="font-weight-bold">Stock: <%# Eval("Total_Stock") %></h4>
                <p>Total Price: ৳<%# Eval("Total_Price") %></p>
            </ItemTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="StockSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT SUM(MemberProduct.ProductStock) AS Total_Stock, SUM(MemberProduct.ProductStock * Product_Point_Code.Product_Point) AS Total_Point, SUM(MemberProduct.ProductStock * Product_Point_Code.Product_Price) AS Total_Price FROM MemberProduct INNER JOIN Product_Point_Code ON MemberProduct.Product_PointID = Product_Point_Code.Product_PointID WHERE (MemberProduct.MemberID = @MemberID)">
            <SelectParameters>
                <asp:SessionParameter Name="MemberID" SessionField="MemberID" />
            </SelectParameters>
        </asp:SqlDataSource>

        <div class="table-responsive">
            <asp:GridView ID="ProductStockGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="ProductStockSQL" AllowSorting="True">
                <Columns>
                    <asp:BoundField DataField="Product_Code" HeaderText="Code" SortExpression="Product_Code" />
                    <asp:BoundField DataField="Product_Name" HeaderText="Name" SortExpression="Product_Name" />
                    <asp:BoundField DataField="ProductStock" HeaderText="Quantity" SortExpression="ProductStock" />
                    <asp:BoundField DataField="Product_Price" HeaderText="Unit Price" SortExpression="Product_Price" />
                    <asp:BoundField DataField="Total_Price" HeaderText="Total Price" SortExpression="Total_Price" />
                </Columns>
                <EmptyDataTemplate>
                    No Stock Available
                </EmptyDataTemplate>
            </asp:GridView>
            <asp:SqlDataSource ID="ProductStockSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT MemberProduct.Product_PointID, MemberProduct.ProductStock, Product_Point_Code.Product_Name, Product_Point_Code.Product_Code, Product_Point_Code.Product_Point, Product_Point_Code.Product_Price, MemberProduct.ProductStock * Product_Point_Code.Product_Point AS Total_Point, MemberProduct.ProductStock * Product_Point_Code.Product_Price AS Total_Price FROM MemberProduct INNER JOIN Product_Point_Code ON MemberProduct.Product_PointID = Product_Point_Code.Product_PointID WHERE (MemberProduct.MemberID = @MemberID) AND (MemberProduct.ProductStock &lt;&gt; 0) ORDER BY MemberProduct.ProductStock DESC"
                FilterExpression="Product_Name LIKE '{0}%' OR Product_Code LIKE '{0}%'" CancelSelectOnNullParameter="False">
                <FilterParameters>
                    <asp:ControlParameter ControlID="FindTextBox" Name="Find" PropertyName="Text" />
                </FilterParameters>
                <SelectParameters>
                    <asp:SessionParameter Name="MemberID" SessionField="MemberID" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
    </div>

    <script>
        $(function () {
            $("#product-stock").addClass('L_Active');
        });
    </script>
</asp:Content>
