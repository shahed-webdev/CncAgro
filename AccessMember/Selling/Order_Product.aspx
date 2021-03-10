<%@ Page Title="Order Product" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Order_Product.aspx.cs" Inherits="CncAgro.AccessMember.Selling.Order_Product" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        #cartTotalProduct { cursor: pointer; font-size: 15px; margin-right: 7px; }
        .mGrid td a { color: #246adf }
        .remove { color: crimson; cursor: pointer }

        #modalCart .table td, .table th { vertical-align: middle; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="mb-0">Order Product</h3>
        <a id="btnShowCart" class="btn btn-outline-primary">
            <small id="cartTotalProduct" class="badge badge-pill badge-primary">0</small>
            View Product
        </a>
    </div>

    <div class="card card-body">
        <div class="form-inline">
            <div class="form-group">
                <asp:TextBox ID="FindTextBox" placeholder="Find By Code, Name" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="form-group">
                <button id="btnFind" class="btn btn-primary">Find</button>
            </div>
        </div>


        <div class="table-responsive">
            <asp:GridView ID="ProductGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataKeyNames="Product_PointID" DataSourceID="Product_PointSQL" AllowSorting="True">
                <Columns>
                    <asp:TemplateField HeaderText="Product Name" SortExpression="Product_Name">
                        <ItemTemplate>
                            <strong><%# Eval("Product_Name") %></strong>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Code" SortExpression="Product_Code">
                        <ItemTemplate>
                            <%# Eval("Product_Code") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Stock" SortExpression="Stock_Quantity">
                        <ItemTemplate>
                            <%# Eval("Stock_Quantity") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Unit Price" SortExpression="Product_Price">
                        <ItemTemplate>
                            ৳<%# Eval("Product_Price") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Add">
                        <ItemTemplate>
                            <a class="add-to-cart" href="#" id="<%#Eval("Product_PointID") %>" data-name="<%# Eval("Product_Name") %>" data-price="<%#Eval("Product_Price") %>" data-stock="<%# Eval("Stock_Quantity") %>">
                                <i class="fa fa-cart-plus mr-1"></i>Add to cart
                            </a>
                        </ItemTemplate>
                        <ItemStyle Width="120px" />
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


    <!--cart modal-->
    <div class="modal fade" id="modalCart" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title font-weight-bold">Place Order</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table table-sm">
                        <thead>
                            <tr>
                                <th><strong>Product</strong></th>
                                <th><strong>Unit Price</strong></th>
                                <th><strong>Quantity</strong></th>
                                <th><strong>Line Total</strong></th>
                                <th class="text-center"><strong>Remove</strong></th>
                            </tr>
                        </thead>
                        <tbody id="cartBody"></tbody>
                    </table>
                </div>
                <div class="modal-footer">
                    <h4 class="mb-0 font-weight-bold" id="cartGrandTotal"></h4>
                    <button type="submit" class="btn btn-secondary btn-md">Place Order</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        $("#order-product").addClass('L_Active');

        (function () {
            //store
            let store = [];

            //order method
            const order = {
                //add to store
                addToStore: function (product) {
                    const isExists = store.some(item => item.ProductID === product.ProductID);

                    if (isExists) {
                        store.forEach(item => {
                            if (item.ProductID === product.ProductID) {
                                item.Quantity += 1;
                                item.TotalPrice = item.Quantity * item.UnitPrice;

                                $.notify("Product Already Added. Quantity Updated", "warn");
                                return;
                            }
                        });

                        //update cart
                        this.saveCart();
                        this.countOder();

                        return;
                    }

                    //insert cart
                    store.push(product);
                    this.saveCart();
                    this.countOder();

                    $.notify("Product added to cart", "success");
                },

                //save cart
                saveCart: function () {
                    localStorage.setItem("customer-order-cart", JSON.stringify(store));
                },

                //get cart
                getCart: function () {
                    store = localStorage.getItem("customer-order-cart") ? JSON.parse(localStorage.getItem("customer-order-cart")) : [];
                },

                //count order 
                countOder: function () {
                    const setCount = document.getElementById("cartTotalProduct");
                    const total = store.reduce((acc, item) => acc + item.Quantity, 0);

                    setCount.textContent = total;
                },

                //total order amount
                totalPrice: function () {
                    const setCount = document.getElementById("cartGrandTotal");
                    const total = store.reduce((acc, item) => acc + item.TotalPrice, 0);

                    setCount.textContent = `Grand Total: ৳${total}`;
                    return total;
                },

                //show cart
                showCart: function () {
                    const modalCart = $("#modalCart");
                    const cartBody = document.getElementById("cartBody");
                    cartBody.innerHTML = "";

                    this.getCart();

                    if (!store.length) return;

                    store.forEach(item => {
                        cartBody.appendChild(this.createRow(item));
                    });

                    this.totalPrice();

                    modalCart.modal("show");
                },

                //create table row
                createRow: function (item) {
                    const tr = document.createElement("tr");
                    tr.innerHTML = `<tr>
                            <td>${item.ProductName}</td>
                            <td>৳${item.UnitPrice}</td>
                            <td><input type="number" value="${item.Quantity}" min="1" max="${item.Stock}" class="inputQuantity form-control" required></td>
                            <td>৳<span class="lineTotal">${item.TotalPrice}</span></td>
                            <td class="text-center"><i class="remove fas fa-trash-alt"></i></td>
                        </tr>`
                    return tr;
                },

                //show total order count on after page loaded
                showOrderOnLoad: function () {
                    this.getCart();
                    this.countOder();
                }
            }


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
                    const Stock = +element.getAttribute("data-stock");

                    const obj = {
                        ProductID: ProductId,
                        UnitPoint: UnitPrice,
                        ProductName,
                        Quantity: 1,
                        UnitPrice,
                        TotalPrice: UnitPrice,
                        Stock
                    }

                    order.addToStore(obj)
                }
            });

            //show cart
            const btnShowCart = document.getElementById("btnShowCart");
            btnShowCart.addEventListener("click", function () {
                order.showCart();
            });

            //place order
            const formPost = document.getElementById("formPost");
            formPost.addEventListener("submit", function (evt) {
                evt.preventDefault();

                const body = {
                    listProduct: store,
                    totalPrice: order.totalPrice()
                }

                if (!store.length) return;

                $.ajax({
                    type: "POST",
                    url: "Order_Product.aspx/PostOderProduct",
                    data: JSON.stringify(body),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        console("success");
                    },
                    error: function (err) {
                        console.log(err);
                    }
                });
            });

            //find btn click
            document.getElementById("btnFind").addEventListener("click", function () {
                location.href = location.href;
            });

            //on page load
            order.showOrderOnLoad();
        })();
    </script>
</asp:Content>
