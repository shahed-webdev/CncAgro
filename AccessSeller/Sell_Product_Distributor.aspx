<%@ Page Title="" Language="C#" MasterPageFile="~/Seller.Master" AutoEventWireup="true" CodeBehind="Sell_Product_Distributor.aspx.cs" Inherits="CncAgro.AccessSeller.Sell_Product_Distributor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        #user-info { display: none; }
        #Product-info { display: none; }

        .userid { font-size: 14px; padding: 13px 5px; margin-bottom: 7px; }
            .userid i { padding-left: 10px; }
        .ItemDelete { color: red; cursor: pointer; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Sell Product To Distributor</h3>

    <div class="col-md-6 card">
        <div class="form-group">
            <label>
                Distributor Id
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="DistributorUserNameTextBox" CssClass="EroorStar" ErrorMessage="Required" ValidationGroup="1"></asp:RequiredFieldValidator>
            </label>
            <asp:TextBox ID="DistributorUserNameTextBox" placeholder="Distributor Id" runat="server" CssClass="form-control" autocomplete="off"></asp:TextBox>
        </div>

        <div id="user-info" class="alert-success">
            <div class="userid">
                <i class="fa fa-user-circle" aria-hidden="true"></i>
                <label id="Seller_Name_Label"></label>
                <i class="fa fa-phone-square" aria-hidden="true"></i>
                <label id="Seller_Phone_Label"></label>
            </div>
            <asp:HiddenField ID="SellerID_HF" runat="server" />
        </div>

        <div class="form-group">
            <label>
                Product Code
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="ProductCodeTextBox" CssClass="EroorStar" ErrorMessage="Required" ValidationGroup="1"></asp:RequiredFieldValidator>
            </label>
            <asp:TextBox ID="ProductCodeTextBox" placeholder="Product Code" runat="server" CssClass="form-control" autocomplete="off"></asp:TextBox>
        </div>

        <div id="Product-info" class="alert-success">
            <div class="userid">
                <i class="fa fa-shopping-bag" aria-hidden="true"></i>
                <label id="ProductNameLabel"></label>
                <br />

                <i class="fa fa-money" aria-hidden="true"></i>
                Price:
                <label id="ProductPriceLabel"></label>

                <i class="fa fa-star" aria-hidden="true"></i>
                Point:
                <label id="ProductPointLabel"></label>

                <i class="fa fa-star" aria-hidden="true"></i>
                Commission:
                <label id="CommissionLabel"></label>

                <strong><i class="fa fa-shopping-basket"></i>
                    Current Stock:
                    <label id="Current_Stock_Label"></label>
                </strong>
            </div>
            <input id="ProductID_HF" type="hidden" />
        </div>

        <div class="form-group">
            <label>
                Quantity
                <asp:Label ID="StockErLabel" runat="server" ForeColor="#009933"></asp:Label>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="QuantityTextBox" CssClass="EroorStar" ErrorMessage="Required" ValidationGroup="1"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="Rex" runat="server" ControlToValidate="QuantityTextBox" ErrorMessage="0 Not Allowed" ValidationExpression="^(?=.*[1-9])(?:[1-9]\d*\.?|0?\.)\d*$" ValidationGroup="1" CssClass="EroorStar" />
            </label>
            <asp:TextBox ID="QuantityTextBox" placeholder="Quantity" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" runat="server" CssClass="form-control"></asp:TextBox>
            <label class="P_Tag" id="Tota_Price_Label"></label>
        </div>
        <input id="CartButton" type="button" value="Add To Cart" onclick="addToCart()" class="btn btn-danger" />
    </div>

    <div class="clearfix"></div>
    <div class="table-responsive">
        <table style="visibility: hidden;" class="mGrid cart">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Quantity</th>
                    <th>Unit Price</th>
                    <th>Unit Point</th>
                    <th>Unit Comm.</th>
                    <th>Total Price</th>
                    <th>Total Point</th>
                    <th>Total Comm.</th>
                    <th></th>
                </tr>
            </thead>
            <tbody id="cartBody"></tbody>
        </table>

        <asp:HiddenField ID="Total_Price_HF" runat="server" />
        <asp:HiddenField ID="Total_Point_HF" runat="server" />
        <asp:HiddenField ID="Total_Commission_HF" runat="server" />
    </div>

    <div id="Add_Product" style="visibility: hidden; margin-top: 15px;">
        <asp:Button ID="Sell_Button" runat="server" CssClass="btn btn-primary" OnClick="SellButton_Click" Text="Distribution Product" />
        <asp:HiddenField ID="JsonData" runat="server" />
    </div>

    <asp:SqlDataSource ID="Product_DistributionSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO Shopping_Distributor(SellerID, Product_Total_Amount, Commission_Amount, BuyingSellerID, ShoppingPoint, DistributorShopping_SN) VALUES (@SellerID, @Product_Total_Amount, @Commission_Amount, @BuyingSellerID, @ShoppingPoint, dbo.Shopping_Distributor_SerialNumber()) SELECT @DistributorShoppingID = Scope_identity()"
        SelectCommand="SELECT * FROM [Product_Distribution]" OnInserted="Product_DistributionSQL_Inserted" UpdateCommand="UPDATE Seller SET Buying_Amount = @Sopping_Amount WHERE (SellerID = @BuyingSellerID)
UPDATE Seller SET Selling_Amount = @Sopping_Amount WHERE (SellerID = @SellerID)">
        <InsertParameters>
            <asp:SessionParameter Name="SellerID" SessionField="SellerID" />
            <asp:ControlParameter ControlID="Total_Price_HF" Name="Product_Total_Amount" PropertyName="Value" />
            <asp:ControlParameter ControlID="Total_Commission_HF" Name="Commission_Amount" PropertyName="Value" />
            <asp:ControlParameter ControlID="SellerID_HF" Name="BuyingSellerID" PropertyName="Value" />
            <asp:ControlParameter ControlID="Total_Point_HF" Name="ShoppingPoint" PropertyName="Value" />
            <asp:Parameter Name="DistributorShoppingID" Direction="Output" Size="50" />
        </InsertParameters>
        <UpdateParameters>
            <asp:SessionParameter Name="SellerID" SessionField="SellerID" />
            <asp:ControlParameter ControlID="SellerID_HF" Name="BuyingSellerID" PropertyName="Value" />
            <asp:Parameter Name="Sopping_Amount" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="Product_Distribution_RecordsSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO Shopping_Distributor_Record(ProductID, SellingQuantity, SellingUnitPrice, SellingUnitPoint, SellingUnit_Commission, DistributorShoppingID) VALUES (@ProductID, @SellingQuantity, @SellingUnitPrice, @SellingUnitPoint, @SellingUnit_Commission, @DistributorShoppingID)" SelectCommand="SELECT SellerID FROM Shopping_Distributor">
        <InsertParameters>
            <asp:Parameter Name="DistributorShoppingID" />
            <asp:Parameter Name="ProductID" Type="Int32" />
            <asp:Parameter Name="SellingQuantity" Type="Int32" />
            <asp:Parameter Name="SellingUnitPrice" Type="Double" />
            <asp:Parameter Name="SellingUnitPoint" Type="Double" />
            <asp:Parameter Name="SellingUnit_Commission" />
        </InsertParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="Seller_Product_insert_UpdateSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM [Seller]" InsertCommand=" IF NOT EXISTS (SELECT * FROM  Seller_Product WHERE (SellerID = @BuyingSellerID) AND (Product_PointID = @Product_PointID))
BEGIN
INSERT INTO Seller_Product (SellerID, Product_PointID, SellerProduct_Stock) VALUES(@BuyingSellerID, @Product_PointID, @SellerProduct_Stock)
END
ELSE
BEGIN
UPDATE Seller_Product SET SellerProduct_Stock =SellerProduct_Stock + @SellerProduct_Stock WHERE (SellerID = @BuyingSellerID) AND (Product_PointID = @Product_PointID)
END">
        <InsertParameters>
            <asp:ControlParameter ControlID="SellerID_HF" Name="BuyingSellerID" PropertyName="Value" />
            <asp:Parameter Name="Product_PointID" />
            <asp:Parameter Name="SellerProduct_Stock" />
        </InsertParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="Stock_UpdateSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM [Product_Point_Code]" UpdateCommand="UPDATE Seller_Product SET SellerProduct_Stock = SellerProduct_Stock - @Stock_Quantity WHERE (Product_PointID = @Product_PointID) AND (SellerID = @SellerID)">
        <UpdateParameters>
            <asp:SessionParameter Name="SellerID" SessionField="SellerID" />
            <asp:Parameter Name="Product_PointID" />
            <asp:Parameter Name="Stock_Quantity" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <script>
        var SellerSalesCart = [];

        $(function () {
            $("[id*=Sell_Button]").click(function () {
                if (localStorage.SellerSalesCart) {
                    $("[id*=JsonData]").val(JSON.stringify(SellerSalesCart));
                }
            });

            if (localStorage.SellerSalesCart) {
                SellerSalesCart = JSON.parse(localStorage.SellerSalesCart);
                showCart();
            }
        });

        function addToCart() {
            var ProductID = $("#ProductID_HF").val();
            var SellerID = $("[id$=SellerID_HF]").val();
            var Code = $("[id*=ProductCodeTextBox]").val();
            var Name = $("#ProductNameLabel").text();
            var Quantity = $("[id*=QuantityTextBox]").val().trim();
            var Unit_Price = $("#ProductPriceLabel").text();
            var Unit_Point = $("#ProductPointLabel").text();
            var Commission = $("#CommissionLabel").text();


            // create JavaScript Object
            if (Code != '' && Quantity != '' && ProductID != '' && SellerID != '') {
                // if Code is already present
                for (var i in SellerSalesCart) {
                    if (SellerSalesCart[i].ProductID == ProductID) { alert("This Product already added"); return; }
                }

                var item = { Code: Code, ProductID: ProductID, Name: Name, Quantity: Quantity, Unit_Price: Unit_Price, Unit_Point: Unit_Point, Commission: Commission };
                SellerSalesCart.push(item);
                saveCart();
                showCart();

                $("[id*=ProductCodeTextBox]").val(null);
                $("[id*=QuantityTextBox]").val("");
                $("#ProductNameLabel").text("");
                $("#ProductPriceLabel").text("");
                $("#ProductPointLabel").text("");
                $("#Current_Stock_Label").text("");
                $("#Tota_Price_Label").text("");
                $("[id*=StockErLabel]").text("");
                $("#ProductID_HF").val("");
                $("#Product-info").css("display", "none");
            }
            else {
                alert("Product code & quantity required");
            }
        }

        function saveCart() {
            if (window.localStorage) {
                localStorage.SellerSalesCart = JSON.stringify(SellerSalesCart);
            }
        }

        //Delete
        $(document).on("click", ".ItemDelete", function () {
            var index = $(this).closest("tr").index();

            SellerSalesCart.splice(index, 1);
            showCart();
            saveCart();

            getTotalPrice();
            getTotalPoint();
            getTotalCommission();
        });

        function getTotalPrice() {
            var total = 0;
            $.each(SellerSalesCart, function () {
                total += this.Quantity * this.Unit_Price;
            });
            $("#GrandTotal").text(total.toFixed(2));
            $("[id*=Total_Price_HF]").val(total);
        }

        function getTotalPoint() {
            var total = 0;
            $.each(SellerSalesCart, function () {
                total += this.Quantity * this.Unit_Point;
            });
            $("#PointGrandTotal").text(total.toFixed(2));
            $("[id*=Total_Point_HF]").val(total);
        }

        function getTotalCommission() {
            var total = 0;
            $.each(SellerSalesCart, function () {
                total += this.Quantity * this.Commission;
            });
            $("#CommissionGrandTotal").text(total.toFixed(2));
            $("[id*=Total_Commission_HF]").val(total);
        }

        function showCart() {
            if (SellerSalesCart.length == 0) {
                $(".cart").css("visibility", "hidden");
                $("#Add_Product").css("visibility", "hidden");
                return;
            }

            $(".cart").css("visibility", "visible");
            $("#Add_Product").css("visibility", "visible");
            var cartTable = $("#cartBody");
            cartTable.empty();

            $.each(SellerSalesCart, function () {
                var tPrice = this.Quantity * this.Unit_Price;
                var tPoint = this.Quantity * this.Unit_Point;
                var tComm = this.Quantity * this.Commission;
                cartTable.append(
                  '<tr>' +
                  '<td>' + this.Name + '</td>' +
                  '<td>' + this.Quantity + '</td>' +
                  '<td>৳' + this.Unit_Price + '</td>' +
                  '<td>' + this.Unit_Point + '</td>' +
                  '<td>' + this.Commission + '</td>' +
                  '<td>৳' + tPrice.toFixed(2) + '</td>' +
                  '<td>' + tPoint.toFixed(2) + '</td>' +
                  '<td>' + tComm.toFixed(2) + '</td>' +
                  '<td class="text-center" style="width:30px;"><i class="fa fa-trash ItemDelete"></i></td>' +
                  '</tr>'
                );
            });
            cartTable.append(
              '<tr>' +
              '<td></td>' +
              '<td></td>' +
              '<td></td>' +
              '<td></td>' +
              '<td></td>' +
              '<td>৳<strong id="GrandTotal"></strong></td>' +
              '<td><strong id="PointGrandTotal"></strong></td>' +
              '<td><strong id="CommissionGrandTotal"></strong></td>' +
              '<td></td>' +
              '</tr>'
            );
            getTotalPrice();
            getTotalPoint();
            getTotalCommission();
        }

        function RemoveCart() {
            localStorage.removeItem("SellerSalesCart");
        }
        /**End Cart*/

        $(function () {
            $("#SellerSell").addClass('L_Active');
            //Get Seller Info
            $('[id*=DistributorUserNameTextBox]').typeahead({
                minLength: 1,
                source: function (request, result) {
                    $.ajax({
                        url: "Sell_Product_Distributor.aspx/GetCustomers",
                        data: JSON.stringify({ 'prefix': request }),
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (response) {
                            label = [];
                            map = {};
                            $.map(JSON.parse(response.d), function (item) {
                                label.push(item.Username);
                                map[item.Username] = item;
                            });
                            result(label);
                        }
                    });
                },
                updater: function (item) {
                    $("#user-info").css("display", "block");
                    $("#Seller_Name_Label").text(map[item].Name);
                    $("#Seller_Phone_Label").text(map[item].Phone);
                    $("[id$=SellerID_HF]").val(map[item].SellerID);
                    return item;
                }
            });

            //Get Product info
            $('[id*=ProductCodeTextBox]').typeahead({
                minLength: 1,
                source: function (request, result) {
                    $.ajax({
                        url: "Sell_Product_Distributor.aspx/GetProduct",
                        data: JSON.stringify({ 'prefix': request, 'Client_SellerID': $("[id$=SellerID_HF]").val() }),
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (response) {
                            label = [];
                            map = {};
                            $.map(JSON.parse(response.d), function (item) {
                                label.push(item.Code);
                                map[item.Code] = item;
                            });
                            result(label);
                        }
                    });
                },
                updater: function (item) {
                    $("#Product-info").css("display", "block");
                    $("#ProductNameLabel").text(map[item].Name);
                    $("#ProductPriceLabel").text(map[item].Price);
                    $("#ProductPointLabel").text(map[item].Point);
                    $("#Current_Stock_Label").text(map[item].Stock);
                    $("#CommissionLabel").text(map[item].Commission);
                    $("#ProductID_HF").val(map[item].ProductID);
                    return item;
                }
            });

            //Seller reset
            $("[id*=DistributorUserNameTextBox]").on('keyup', function () {
                $("#Seller_Name_Label").text("");
                $("#Seller_Phone_Label").text("");
                $("[id$=SellerID_HF]").val("");
                $("#user-info").css("display", "none");

                localStorage.removeItem("SellerSalesCart");
                $(".cart").css("visibility", "hidden");
                $("#Add_Product").css("visibility", "hidden");
            });

            //Product reset
            $("[id*=ProductCodeTextBox]").on('keyup', function () {
                $("#ProductNameLabel").text("");
                $("#ProductPriceLabel").text("");
                $("#ProductPointLabel").text("");
                $("#ProductID_HF").val("");
                $("#Product-info").css("display", "none");
            });

            //Quantity TextBox
            $("[id*=QuantityTextBox]").on('keyup', function () {
                var Price = parseFloat($("#ProductPriceLabel").text());
                var Qntity = parseFloat($("[id*=QuantityTextBox]").val());
                var StockQunt = parseFloat($("#Current_Stock_Label").text());

                var total = parseFloat(Price * Qntity);

                if (!isNaN(total)) {
                    $("#Tota_Price_Label").text("Total Price: " + total.toFixed() + " Tk");
                    StockQunt >= Qntity ? ($("#CartButton").prop("disabled", !1), $("[id*=StockErLabel]").text("Remaining Stock " + (StockQunt - Qntity))) : ($("#CartButton").prop("disabled", !0), $("[id*=StockErLabel]").text("Stock Product Quantity " + StockQunt + ". You Don't Sell " + Qntity));
                }
                else {
                    $("#Tota_Price_Label").text("");
                    $("[id*=StockErLabel]").text("");
                }
            });
        });

        function isNumberKey(a) { a = a.which ? a.which : event.keyCode; return 46 != a && 31 < a && (48 > a || 57 < a) ? !1 : !0 };
    </script>
</asp:Content>
