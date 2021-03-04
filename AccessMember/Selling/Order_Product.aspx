<%@ Page Title="Order Product" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Order_Product.aspx.cs" Inherits="CncAgro.AccessMember.Selling.Order_Product" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">

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
                        <button data-id="<%#Eval("Product_PointID") %>" data-name="<%# Eval("Product_Name") %>" data-price="<%#Eval("Product_Price") %>" data-point="<%# Eval("Product_Point") %>" data-stock="<%# Eval("Stock_Quantity") %>" data-quantity="1" data-image="/CSS/Image/Cart.png" type="button" class="my-cart-btn"><i class="fa fa-cart-plus"></i></button>
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
            </Columns>
            <EmptyDataTemplate>
                No Added Product
            </EmptyDataTemplate>
        </asp:GridView>
        <asp:SqlDataSource ID="Product_PointSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_PointID, Product_Name, Product_Code, Product_Point, Product_Price, Stock_Quantity FROM Product_Point_Code WHERE (Stock_Quantity &gt; 0) AND (IsActive = 1)" FilterExpression="Product_Name LIKE '{0}%' OR Product_Code LIKE '{0}%'" CancelSelectOnNullParameter="False">
            <FilterParameters>
                <asp:ControlParameter ControlID="FindTextBox" Name="find" PropertyName="Text" />
            </FilterParameters>
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
