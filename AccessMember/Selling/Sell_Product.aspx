<%@ Page Title="Sell Product" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Sell_Product.aspx.cs" Inherits="CncAgro.AccessSeller.Sell_Product" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .remove { cursor: pointer; color: #ff0000 }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Sell Product</h3>

    <div class="row">
        <div class="col-md-8">
            <div class="card card-body">
                <div class="form-group">
                    <h6 class="font-weight-bold">Add Product by Code</h6>
                    <input id="inputProductCode" type="text" autocomplete="off" placeholder="find Product" class="form-control" />
                </div>

                <table class="table cart">
                    <thead>
                        <tr>
                            <th><strong>Name</strong></th>
                            <th><strong>Unit Price</strong></th>
                            <th><strong>Quantity</strong></th>
                            <th><strong>Total Price</strong></th>
                            <th class="text-center" style="width: 30px"><strong>Delete</strong></th>
                        </tr>
                    </thead>
                    <tbody id="tBody"></tbody>
                </table>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card card-body">
                <div class="mb-3">
                    <h5 id="grandTotal" class="font-weight-bold"></h5>
                </div>

                <div class="form-group">
                    <label id="errorCustomer">Add Customer</label>
                    <input id="inputCustomer" type="text" autocomplete="off" placeholder="find Customer" class="form-control" />
                    <asp:HiddenField ID="HiddenMemberId" runat="server" />
                    <div id="show-customer-info" class="mt-2"></div>
                </div>
            </div>
            <div id="postCustomer" class="mt-3">
                <asp:Button ID="Sell_Button" runat="server" CssClass="btn btn-primary" OnClientClick="return formValidation();" OnClick="SellButton_Click" Text="Sell Product" />
                <asp:Label ID="ErrorLabel" runat="server" CssClass="EroorStar"></asp:Label>

                <!--pass total amount/point-->
                <asp:HiddenField ID="HiddenGrandTotalAmount" runat="server" />
                <!--pass array as text-->
                <asp:HiddenField ID="JsonData" runat="server" />
            </div>
        </div>
    </div>

    <div>
        <asp:SqlDataSource ID="ShoppingSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO [Shopping] ([Seller_RegistrationID], [MemberID], [ShoppingAmount],ShoppingPoint) VALUES (@SellerRegistrationID, @MemberID, @ShoppingAmount,@ShoppingPoint)
SELECT @ShoppingID = Scope_identity()"
            SelectCommand="SELECT * FROM [Shopping]" OnInserted="ShoppingSQL_Inserted">
            <InsertParameters>
                <asp:SessionParameter Name="SellerRegistrationID" SessionField="RegistrationID" />
                <asp:ControlParameter ControlID="HiddenMemberId" Name="MemberID" PropertyName="Value" Type="Int32" />
                <asp:ControlParameter ControlID="HiddenGrandTotalAmount" Name="ShoppingAmount" PropertyName="Value" />
                <asp:ControlParameter ControlID="HiddenGrandTotalAmount" Name="ShoppingPoint" PropertyName="Value" />
                <asp:Parameter Direction="Output" Name="ShoppingID" Size="50" />
            </InsertParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="Product_Selling_RecordsSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO Product_Selling_Records(ProductID, ShoppingID, SellingQuantity, SellingUnitPrice, SellingUnitPoint) VALUES (@ProductID,@ShoppingID, @SellingQuantity, @SellingUnitPrice, @SellingUnitPoint)" SelectCommand="SELECT * FROM [Product_Selling_Records]">
            <InsertParameters>
                <asp:Parameter Name="ProductID" Type="Int32" />
                <asp:Parameter Name="ShoppingID" />
                <asp:Parameter Name="SellingQuantity" />
                <asp:Parameter Name="SellingUnitPrice" Type="Double" />
                <asp:Parameter Name="SellingUnitPoint" Type="Double" />
            </InsertParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="MemberProductSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT MemberID FROM MemberProduct WHERE (MemberID = @MemberID)" UpdateCommand="UPDATE MemberProduct SET ProductStock = ProductStock - @ProductStock WHERE (MemberID = @MemberID) AND (Product_PointID = @Product_PointID)">
            <SelectParameters>
                <asp:SessionParameter Name="MemberID" SessionField="MemberID" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="ProductStock" />
                <asp:Parameter Name="Product_PointID" Type="Int32" />
                <asp:SessionParameter Name="MemberID" SessionField="MemberID" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="RetailSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Generation_Retail_RecordsID FROM Member_Bouns_Records_Gen_Retails" UpdateCommand="Add_Retail_Income" UpdateCommandType="StoredProcedure">
            <UpdateParameters>
                <asp:ControlParameter ControlID="HiddenMemberId" Name="MemberID" PropertyName="Value" Type="Int32" />
                <asp:ControlParameter ControlID="HiddenGrandTotalAmount" Name="Point" PropertyName="Value" />
            </UpdateParameters>
        </asp:SqlDataSource>
    </div>

    <script>
        const sellProduct = (function () {
            //**** REFERENCE INFO ****
            const inputCustomer = document.getElementById("inputCustomer");
            const hiddenMemberId = document.getElementById("body_HiddenMemberId");
            const customerInfo = document.getElementById("show-customer-info");

            //autocomplete
            $(inputCustomer).typeahead({
                minLength: 2,
                displayText: function (item) {
                    return item.UserName;
                },
                afterSelect: function (item) {
                    this.$element[0].value = item.UserName;
                },
                source: function (request, result) {
                    $.ajax({
                        type: "POST",
                        url: "Sell_Product.aspx/GetCustomers",
                        data: JSON.stringify({ 'prefix': request }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            result(JSON.parse(response.d));
                        },
                        error: function (err) { console.log(err) }
                    });
                },
                updater: function (item) {
                    appendCustomerInfo(item);
                    return item;
                }
            })

            //on input customer id
            inputCustomer.addEventListener("input", function () {
                hiddenMemberId.value = "";
                customerInfo.innerHTML = "";
            });

            //append find customer info
            function appendCustomerInfo(item) {
                hiddenMemberId.value = item.MemberID;
                customerInfo.innerHTML = `<span class="badge badge-secondary mr-2">${item.Name}</span><span class="badge badge-secondary">${item.Phone}</span>`
            }


            //**** PRODUCT ****//
            let cart = [];
            const inputProductCode = document.getElementById("inputProductCode");
            const tBody = document.getElementById("tBody");

            //product autocomplete
            $(inputProductCode).typeahead({
                minLength: 2,
                displayText: function (item) {
                    return item.Code;
                },
                afterSelect: function (item) {
                    this.$element[0].value = "";
                },
                source: function (request, result) {
                    $.ajax({
                        type: "POST",
                        url: "Sell_Product.aspx/GetProduct",
                        data: JSON.stringify({ 'prefix': request }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            result(JSON.parse(response.d));
                        },
                        error: function (err) { console.log(err) }
                    });
                },
                updater: function (item) {
                    addProduct(item);
                    return item;
                }
            })

            //save to cart
            function saveCart() {
                localStorage.setItem('_customer-products-sell_cart_', JSON.stringify(cart));

                grandTotalAmount();
            }

            //sum total amount
            const postJsonData = document.getElementById("body_JsonData");

            function grandTotalAmount() {
                const total = cart.reduce((acc, item) => acc + item.TotalPrice, 0);

                document.getElementById("body_HiddenGrandTotalAmount").value = total;
                document.getElementById("grandTotal").textContent = `Grand Total: ৳${total}`;

                //set array for submit to database
                postJsonData.value = cart.length ? JSON.stringify(cart) : "";
            }

            //add new product to table
            function addProduct(product) {
                const isAdded = cart.some(item => item.ProductID === product.ProductID);
                if (isAdded) {
                    $(inputProductCode).notify(`'${product.Code}' Product already added to list`, { position: "bottom left" });
                    return;
                }

                product.Quantity = 1;
                product.TotalPrice = product.Price;
                cart.push(product);

                //save data to local store
                saveCart();

                //append row in table
                tBody.appendChild(createRow(product));
            }

            //create table row
            function createRow(item) {
                const tr = document.createElement("tr");
                tr.innerHTML = `
                    <td><strong class="d-block">${item.Name}</strong><em>${item.Code}</em></td>
                    <td>৳${item.Price}</td>
                    <td><input min="1" max="${item.Stock}" id="${item.ProductID}" data-stock="${item.Stock}" data-price="${item.Price}" type="number" value="${item.Quantity}" class="form-control inputQuantity" required></td>
                    <td>৳<span class="total-price">${item.TotalPrice}</span></td>
                    <td class="text-center"><i id="${item.ProductID}" class="remove fas fa-trash"></i></td>`
                return tr;
            }

            //append product info
            const rebuildProductTable = function () {
                tBody.innerHTML = "";
                const store = localStorage.getItem("_customer-products-sell_cart_");
                if (!store) return;

                cart = JSON.parse(store);

                cart.forEach(item => {
                    tBody.appendChild(createRow(item));
                });

                grandTotalAmount();
            }

            //on update quantity/delete
            tBody.addEventListener("input", onQuantityAndDelete);
            tBody.addEventListener("click", onQuantityAndDelete);

            //reset reference info 
            const resetCustomerInfo = function () {
                if (inputCustomer.value)
                    inputCustomer.value = "";

                hiddenMemberId.value = "";
                customerInfo.innerHTML = "";
            }

            //function delete and quantity update
            function onQuantityAndDelete(evt) {
                const element = evt.target;

                const onQuantity = element.classList.contains("inputQuantity");
                const onRemove = element.classList.contains("remove");

                //quantity update
                if (onQuantity) {
                    const id = +element.id;
                    const price = +element.getAttribute("data-price");
                    const stock = +element.getAttribute("data-stock");
                    const inputQuantity = +element.value;
                    const setTotalPrice = element.parentElement.parentElement.querySelector(".total-price");

                    if (stock < inputQuantity) {
                        $("#tBody").notify(`Quantity more than stock. current stock: ${stock}`, { position: "bottom center" });
                        return;
                    }

                    const totalPrice = price * inputQuantity;

                    cart.forEach((item, i) => {
                        if (item.ProductID === id) {
                            cart[i].Quantity = inputQuantity;
                            cart[i].TotalPrice = totalPrice;
                        }
                    });

                    setTotalPrice.textContent = totalPrice;
                }

                //remove product from list

                if (onRemove) {
                    const id = +element.id;
                    cart = cart.filter(item => item.ProductID !== id);
                    element.parentElement.parentElement.remove();
                }

                //save changes cart
                saveCart();
            }

            //check form validation before submit
            const formIsValid = function () {
                if (!postJsonData.value) {
                    $("#postCustomer").notify("No Product Added!", { position: "bottom left" });
                    return false;
                }

                if (!hiddenMemberId.value) {
                    $("#errorCustomer").notify("insert valid customer", { position: "top left" });
                    return false;
                }

                return true;
            }

            //clear cart after submit
            const emptyCart = function () {
                cart = [];
                localStorage.removeItem('_customer-products-sell_cart_');
            }

            //***public function***
            return {
                rebuildProductTable,
                resetCustomerInfo,
                formIsValid,
                emptyCart
            }
        })();


        //call function
        sellProduct.resetCustomerInfo();
        sellProduct.rebuildProductTable();

        //check form validation before submit
        function formValidation() {
            const isValid = sellProduct.formIsValid();

            if (isValid) sellProduct.emptyCart();

            return isValid;
        }

        //allow only number
        function isNumberKey(a) { a = a.which ? a.which : event.keyCode; return 46 !== a && 31 < a && (48 > a || 57 < a) ? false : true };

        //prevent submit on enter press
        $(document).on("keypress", "input", function (e) {
            const code = e.keyCode || e.which;
            if (code === 13) {
                e.preventDefault();
                return false;
            }
            return true;
        });

        $(function () {
            $("#sell-product").addClass('L_Active');
        });
    </script>
</asp:Content>
