<%@ Page Title="Order Product" Language="C#" MasterPageFile="~/Seller.Master" AutoEventWireup="true" CodeBehind="Order_Product.aspx.cs" Inherits="CncAgro.AccessSeller.Order_Product" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">

    <asp:FormView ID="SellerFormView" runat="server" DataSourceID="SellerSQL" Width="100%">
        <ItemTemplate>
            <h3>Order Product
            <small class="alert-success">Balance:
                <label><%#Eval("Available_Balance","{0:N}") %></label>
                Tk</small></h3>
        </ItemTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="SellerSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Seller.Available_Balance FROM Seller INNER JOIN Registration ON Seller.SellerRegistrationID = Registration.RegistrationID WHERE (Registration.RegistrationID = @RegistrationID)">
        <SelectParameters>
            <asp:SessionParameter Name="RegistrationID" SessionField="RegistrationID" />
        </SelectParameters>
    </asp:SqlDataSource>

    <div class="form-inline">
        <div class="form-group">
            <asp:TextBox ID="FindTextBox" placeholder="Find By Code , Name" runat="server" CssClass="form-control"></asp:TextBox>
        </div>
        <div class="form-group">
            <asp:Button ID="FindButton" runat="server" CssClass="btn btn-primary" Text="Find" />
        </div>
    </div>

    <div class="table-responsive">
        <asp:GridView ID="ProductGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid table-hover" DataKeyNames="Product_PointID" DataSourceID="Product_PointSQL" AllowSorting="True">
            <Columns>
                <asp:TemplateField HeaderText="Add">
                    <ItemTemplate>
                        <button data-id="<%#Eval("Product_PointID") %>" data-name="<%# Eval("Product_Name") %>" data-price="<%#Eval("Product_Price") %>" data-point="<%# Eval("Product_Point") %>" data-stock="<%# Eval("Stock_Quantity") %>" data-commission="<%# Eval("Seller_Commission") %>" data-quantity="1" data-image="/CSS/Image/Cart.png" type="button" class="my-cart-btn"><i class="fa fa-cart-plus"></i></button>
                    </ItemTemplate>
                    <ItemStyle Width="50px" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Product Name" SortExpression="Product_Name">
                    <ItemTemplate>
                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("Product_Name") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Code" SortExpression="Product_Code">
                    <ItemTemplate>
                        <asp:Label ID="Label2" runat="server" Text='<%# Bind("Product_Code") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Stock" SortExpression="Stock_Quantity">
                    <ItemTemplate>
                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("Stock_Quantity") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Price" SortExpression="Product_Price">
                    <ItemTemplate>
                        <asp:Label ID="Label5" runat="server" Text='<%# Bind("Product_Price") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Point" SortExpression="Product_Point">
                    <ItemTemplate>
                        <asp:Label ID="Label4" runat="server" Text='<%# Bind("Product_Point") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Commission" SortExpression="Seller_Commission">
                    <ItemTemplate>
                        <asp:Label ID="Label5" runat="server" Text='<%# Bind("Seller_Commission") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                No Added Product
            </EmptyDataTemplate>
        </asp:GridView>
        <asp:SqlDataSource ID="Product_PointSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_Point_Code.Product_PointID, Product_Point_Code.Product_Name, Product_Point_Code.Product_Code, Product_Point_Code.Product_Point, Product_Point_Code.Product_Price, Product_Point_Code.Stock_Quantity, Product_Point_Code.Order_Quantity, Product_Point_Code.Net_Quantity, Product_Point_Code.Seller_Commission * Seller.CommissionPercentage / 100 AS Seller_Commission FROM Product_Point_Code CROSS JOIN Seller WHERE (Product_Point_Code.Stock_Quantity &gt; 0) AND (Product_Point_Code.IsActive = 1) AND (Seller.SellerID = @SellerID)" FilterExpression="Product_Name LIKE '{0}%' OR Product_Code LIKE '{0}%'" CancelSelectOnNullParameter="False">
            <FilterParameters>
                <asp:ControlParameter ControlID="FindTextBox" Name="find" PropertyName="Text" />
            </FilterParameters>
            <SelectParameters>
                <asp:SessionParameter Name="SellerID" SessionField="SellerID" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>

    <script>
        $(function () {
            $("#Order_Product").addClass('L_Active');

            $(window).scroll(function () {
                if ($(this).scrollTop() != 0) {
                    $('#toTop').fadeIn();
                } else {
                    $('#toTop').fadeOut();
                }

                //cart bar fixed
                if ($(window).scrollTop() > 120) {
                    $('#bh').fadeIn(4000).addClass('Flow_cart');
                }
                else {
                    $('#bh').removeClass('Flow_cart');
                }
            });
        });
    </script>
</asp:Content>
