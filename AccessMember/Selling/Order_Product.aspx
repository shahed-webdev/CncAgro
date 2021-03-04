<%@ Page Title="Order Product" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Order_Product.aspx.cs" Inherits="CncAgro.AccessMember.Selling.Order_Product" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        #cartTotalProduct { cursor: pointer }
        .mGrid td a { color: #246adf }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Order Product
        <small id="cartTotalProduct" class="badge badge-pill badge-primary">0</small>
    </h3>

    <div class="card card-body">
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
                            <a class="add-to-cart" href="#" id="<%#Eval("Product_PointID") %>" data-name="<%# Eval("Product_Name") %>" data-price="<%#Eval("Product_Price") %>" data-stock="<%# Eval("Stock_Quantity") %>">
                                <i class="fa fa-cart-plus mr-1"></i>Add to cart
                            </a>
                        </ItemTemplate>
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
                    no product found
                </EmptyDataTemplate>
            </asp:GridView>
            <asp:SqlDataSource ID="Product_PointSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_PointID, Product_Name, Product_Code, Product_Point, Product_Price, Stock_Quantity FROM Product_Point_Code WHERE (Stock_Quantity &gt; 0) AND (IsActive = 1)" FilterExpression="Product_Name LIKE '{0}%' OR Product_Code LIKE '{0}%'" CancelSelectOnNullParameter="False">
                <FilterParameters>
                    <asp:ControlParameter ControlID="FindTextBox" Name="find" PropertyName="Text" />
                </FilterParameters>
            </asp:SqlDataSource>
        </div>
    </div>

    <script>
        $("#order-product").addClass('L_Active');

        (function () {
            //store
            let store = [];

            //add to cart click
            const productTable = document.getElementById("body_ProductGridView");
            productTable.addEventListener("click", function (evt) {
                evt.preventDefault();

                const element = evt.target;
                const onCart = element.classList.contains("add-to-cart");

                if (onCart) {
                    const ProductId = element.id;
                    const ProductName = element.getAttribute("data-name");
                    const UnitPrice = +element.getAttribute("data-price");
                    const stock = element.getAttribute("stock");

                    const obj = {
                        ProductID: ProductId,
                        UnitPoint: UnitPrice,
                        ProductName,
                        Quantity: 1,
                        UnitPrice
                    }

                    addToStore(obj)
                }
            });

            //add to store
            function addToStore(product) {
                store.forEach((item, i) => {
                    if (item.ProductID === product.ProductID) {
                        item.Quantity += 1;
                        item.TotalPrice *= item.Quantity;

                        $.notify("Product Already Added. Quantity Updated", "warn");
                        return;
                    }
                });

                store.push(product);
                saveCart();
                countOder();

                $.notify("Product added to cart", "success", { position: "to center" });
            }

            //save cart
            function saveCart() {
                localStorage.setItem("customer-order-cart", JSON.stringify(store));
            }

            //count order 
            function countOder() {
                const setCount = document.getElementById("cartTotalProduct");
                const total = store.reduce((acc, item) => acc + item.Quantity, 0);

                setCount.textContent = total;
            }
        })();
    </script>
</asp:Content>
