<%@ Page Title="Sell Product" Language="C#" MasterPageFile="~/Seller.Master" AutoEventWireup="true" CodeBehind="Sell_Product.aspx.cs" Inherits="CncAgro.AccessSeller.Sell_Product" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        #user-info { display: none; }
        #Product-info { display: none; }

        .userid { font-size: 14px; padding: 13px 5px; margin-bottom: 7px; }
            .userid .fa { padding-left: 10px; }
        .ItemDelete { color: red; cursor: pointer; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Sell Product To Customer</h3>

    <div class="col-md-6 well">
        <div class="form-group">
            <label>
                Customer id</label><asp:TextBox ID="MemberUserNameTextBox" placeholder="Customer id" autocomplete="off" runat="server" CssClass="form-control"></asp:TextBox>
        </div>

        <div id="user-info" class="alert-success">
            <div class="userid">
                <i class="fa fa-user-circle" aria-hidden="true"></i>
                <asp:Label ID="Member_Name_Label" runat="server"></asp:Label>
                <i class="fa fa-phone-square" aria-hidden="true"></i>
                <asp:Label ID="Member_Phone_Label" runat="server"></asp:Label>
            </div>
            <asp:HiddenField ID="MemberID_HF" runat="server" />
            <asp:HiddenField ID="Member_Phone_HF" runat="server" />
        </div>

        <div class="form-group">
            <label>
                Product Code</label><asp:TextBox ID="ProductCodeTextBox" placeholder="Product Code" autocomplete="off" runat="server" CssClass="form-control"></asp:TextBox>
        </div>

        <div id="Product-info" class="alert-success">
            <div class="userid">
                <i class="fa fa-shopping-bag"></i>
                <label id="ProductNameLabel"></label>

                <i class="fa fa-money"></i>
                Price:
                <label id="ProductPriceLabel"></label>

                <i class="fa fa-star"></i>
                Point:
                <label id="ProductPointLabel"></label>

                <i class="fa fa-chart-pie"></i>
                Curent Stock:
                <label id="Current_Stook_Label"></label>
            </div>
            <input id="ProductID_HF" type="hidden" />
        </div>

        <div class="form-group">
            <label>
                Quantity
                <asp:Label ID="StookErLabel" runat="server" ForeColor="#009933"></asp:Label>
            </label>
            <asp:TextBox ID="QuantityTextBox" placeholder="Quantity" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" runat="server" CssClass="form-control"></asp:TextBox>
            <label id="Tota_Price_Label"></label>
        </div>

        <input id="CartButton" type="button" value="Add To Cart" onclick="addToCart()" class="btn btn-success" />
    </div>
    <div class="clearfix"></div>

    <table style="visibility: hidden;" class="mGrid cart">
        <thead>
            <tr>
                <th>Name</th>
                <th>Quantity</th>
                <th>Unit Price</th>
                <th>Unit Point</th>
                <th>Total Price</th>
                <th>Total Point</th>
                <th>Delete</th>
            </tr>
        </thead>
        <tbody id="cartBody"></tbody>
    </table>

    <asp:HiddenField ID="GTpriceHF" runat="server" />
    <asp:HiddenField ID="GTpointHF" runat="server" />

    <div id="Add_Product" class="form-inline" style="visibility: hidden; margin-top: 15px;">
        <div class="form-group">
            <asp:RadioButtonList ID="Generation_Type_RadioB" runat="server" CssClass="form-control" RepeatDirection="Horizontal" RepeatLayout="Flow">
                <asp:ListItem Selected="True" Value="G">Generation Commission</asp:ListItem>
                <asp:ListItem Value="R">Retail Profit  Commission</asp:ListItem>
            </asp:RadioButtonList>
        </div>
        <div class="form-group">
            <asp:Button ID="Sell_Button" runat="server" CssClass="btn btn-primary" OnClick="SellButton_Click" Text="Sell Product" />
            <asp:HiddenField ID="JsonData" runat="server" />
        </div>
    </div>


    <asp:SqlDataSource ID="ShoppingSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO [Shopping] ([SellerID], [MemberID], [ShoppingAmount],ShoppingPoint) VALUES ((SELECT  SellerID FROM Seller WHERE (SellerRegistrationID = @SellerRegistrationID)), @MemberID, @ShoppingAmount,@ShoppingPoint)
SELECT @ShoppingID = Scope_identity()"
        SelectCommand="SELECT * FROM [Shopping]" OnInserted="ShoppingSQL_Inserted">
        <InsertParameters>
            <asp:SessionParameter Name="SellerRegistrationID" SessionField="RegistrationID" />
            <asp:ControlParameter ControlID="MemberID_HF" Name="MemberID" PropertyName="Value" Type="Int32" />
            <asp:ControlParameter ControlID="GTpriceHF" Name="ShoppingAmount" PropertyName="Value"/>
            <asp:ControlParameter ControlID="GTpointHF" Name="ShoppingPoint" PropertyName="Value" />
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
    <asp:SqlDataSource ID="SellerUpdateSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM [Seller]" UpdateCommand="UPDATE Seller SET SellingPoint = SellingPoint + @SellingPoint, Selling_Amount = Selling_Amount +@Selling_Amount WHERE (SellerRegistrationID = @SellerRegistrationID)">
        <UpdateParameters>
            <asp:SessionParameter Name="SellerRegistrationID" SessionField="RegistrationID" />
            <asp:ControlParameter ControlID="GTpointHF" Name="SellingPoint" PropertyName="Value"/>
            <asp:ControlParameter ControlID="GTpriceHF" Name="Selling_Amount" PropertyName="Value" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SellerProductSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM [Seller_Product] WHERE ([SellerID] = @SellerID)" UpdateCommand="UPDATE Seller_Product SET SellerProduct_Stock =SellerProduct_Stock - @SellerProduct_Stock WHERE (SellerID = @SellerID) AND (Product_PointID = @Product_PointID)">
        <SelectParameters>
            <asp:SessionParameter Name="SellerID" SessionField="SellerID" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:SessionParameter Name="SellerID" SessionField="SellerID" Type="Int32" />
            <asp:Parameter Name="SellerProduct_Stock" Type="Int32" />
            <asp:Parameter Name="Product_PointID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="A_PointSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="Add_Point" InsertCommandType="StoredProcedure" SelectCommand="SELECT * FROM Member " UpdateCommand="Add_Referral_Bonus" UpdateCommandType="StoredProcedure">
        <InsertParameters>
            <asp:ControlParameter ControlID="GTpointHF" Name="Point" PropertyName="Value"/>
            <asp:ControlParameter ControlID="MemberID_HF" Name="MemberID" PropertyName="Value" Type="Int32" />
        </InsertParameters>
        <UpdateParameters>
            <asp:ControlParameter ControlID="MemberID_HF" Name="MemberID" PropertyName="Value" Type="Int32" />
            <asp:ControlParameter ControlID="GTpointHF" Name="Point" PropertyName="Value"/>
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="AutoPlan_SQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="IF EXISTS(SELECT MemberID, Auto_Member_SN FROM  Member  Where MemberID = @MemberID  AND Own_Point &gt;= 500 AND  Auto_Member_SN IS NULL)
BEGIN
  INSERT INTO Member_AutoPlan (MemberID,AutoPlan_No) Values (@MemberID,1)
END"
        SelectCommand="SELECT * FROM [Member_AutoPlan]" UpdateCommand="Add_Designation_Loop" UpdateCommandType="StoredProcedure">
        <InsertParameters>
            <asp:ControlParameter ControlID="MemberID_HF" Name="MemberID" PropertyName="Value" />
        </InsertParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="GenerationSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="Add_Generation_Retail" InsertCommandType="StoredProcedure" SelectCommand="SELECT Generation_UniLevel_ID FROM Generation_Uni_Level" UpdateCommand="Add_Generation_UniLevel" UpdateCommandType="StoredProcedure">
        <InsertParameters>
            <asp:ControlParameter ControlID="MemberID_HF" Name="MemberID" PropertyName="Value" Type="Int32" />
            <asp:ControlParameter ControlID="GTpointHF" Name="Point" PropertyName="Value"/>
        </InsertParameters>
        <UpdateParameters>
            <asp:ControlParameter ControlID="MemberID_HF" Name="MemberID" PropertyName="Value" Type="Int32" />
            <asp:ControlParameter ControlID="GTpointHF" Name="Point" PropertyName="Value"/>
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="Package_UpdateSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Member_PackageID FROM Member_Package" UpdateCommand="Add_Package_Update" UpdateCommandType="StoredProcedure">
        <UpdateParameters>
            <asp:ControlParameter ControlID="MemberID_HF" Name="MemberID" PropertyName="Value" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="Seller_ComissionSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="Add_Seller_Commission" InsertCommandType="StoredProcedure" SelectCommand="SELECT * FROM [Seller]">
        <InsertParameters>
            <asp:ControlParameter ControlID="GTpointHF" Name="Point" PropertyName="Value"/>
            <asp:SessionParameter Name="SellerID" SessionField="SellerID" Type="Int32" />
            <asp:Parameter Name="ShoppingID" Type="Int32" />
        </InsertParameters>
    </asp:SqlDataSource>


    <script>
        var Sell_Cart = [];

        $(function () {
            $("[id*=Sell_Button]").click(function () {
                if (localStorage.Sell_Cart) {
                    $("[id*=JsonData]").val(JSON.stringify(Sell_Cart));
                }
            });

            if (localStorage.Sell_Cart) {
                Sell_Cart = JSON.parse(localStorage.Sell_Cart);
                showCart();
            }
        });

        function addToCart() {
            var ProductID = $("#ProductID_HF").val();
            var MemberID = $("[id$=MemberID_HF]").val();
            var Code = $("[id*=ProductCodeTextBox]").val();
            var Name = $("#ProductNameLabel").text();
            var Quantity = $("[id*=QuantityTextBox]").val().trim();
            var Unit_Price = $("#ProductPriceLabel").text();
            var Unit_Point = $("#ProductPointLabel").text();


            // create JavaScript Object
            if (Code != '' && Quantity != '' && ProductID != '' && MemberID != '') {
                // if Code is already present
                for (var i in Sell_Cart) {
                    if (Sell_Cart[i].ProductID == ProductID) { alert("This Product already added"); return; }
                }

                var item = { Code: Code, ProductID: ProductID, Name: Name, Quantity: Quantity, Unit_Price: Unit_Price, Unit_Point: Unit_Point };
                Sell_Cart.push(item);
                saveCart();
                showCart();

                $("[id*=ProductCodeTextBox]").val(null);
                $("[id*=QuantityTextBox]").val("");
                $("#ProductNameLabel").text("");
                $("#ProductPriceLabel").text("");
                $("#ProductPointLabel").text("");
                $("#Current_Stook_Label").text("");
                $("#Tota_Price_Label").text("");
                $("[id*=StookErLabel]").text("");
                $("#ProductID_HF").val("");
                $("#Product-info").css("display", "none");
            }
            else {
                alert("Product code & quantity required");
            }
        }

        function saveCart() {
            if (window.localStorage) {
                localStorage.Sell_Cart = JSON.stringify(Sell_Cart);
            }
        }

        //Delete
        $(document).on("click", ".ItemDelete", function () {
            var index = $(this).closest("tr").index();

            Sell_Cart.splice(index, 1);
            showCart();
            saveCart();

            getTotalPrice();
            getTotalPoint();
        });

        function getTotalPrice() {
            var total = 0;
            $.each(Sell_Cart, function () {
                total += this.Quantity * this.Unit_Price;
            });
            $("#GrandTotal").text(total.toFixed(2));
            $("[id*=GTpriceHF]").val(total);
        }

        function getTotalPoint() {
            var total = 0;
            $.each(Sell_Cart, function () {
                total += this.Quantity * this.Unit_Point;
            });
            $("#PointGrandTotal").text(total.toFixed(2));
            $("[id*=GTpointHF]").val(total);
        }

        function showCart() {
            if (Sell_Cart.length == 0) {
                $(".cart").css("visibility", "hidden");
                $("#Add_Product").css("visibility", "hidden");
                return;
            }

            $(".cart").css("visibility", "visible");
            $("#Add_Product").css("visibility", "visible");
            var cartTable = $("#cartBody");
            cartTable.empty();

            $.each(Sell_Cart, function () {
                var tPrice = this.Quantity * this.Unit_Price;
                var tPoint = this.Quantity * this.Unit_Point;
                cartTable.append(
                  '<tr>' +
                  '<td>' + this.Name + '</td>' +
                  '<td>' + this.Quantity + '</td>' +
                  '<td>৳' + this.Unit_Price + '</td>' +
                  '<td>' + this.Unit_Point + '</td>' +
                  '<td>৳' + tPrice.toFixed(2) + '</td>' +
                  '<td>' + tPoint.toFixed(2) + '</td>' +
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
              '<td>৳<strong id="GrandTotal"></strong></td>' +
              '<td><strong id="PointGrandTotal"></strong></td>' +
              '<td></td>' +
              '</tr>'
            );
            getTotalPrice();
            getTotalPoint();
        }

        function RemoveCart() {
            localStorage.removeItem("Sell_Cart");
        }
        /**End Cart*/

        $(function () {
            $("#Sell").addClass('L_Active');

            //Get Member UserName
            $('[id*=MemberUserNameTextBox]').typeahead({
                minLength: 4,
                source: function (request, result) {
                    $.ajax({
                        url: "Sell_Product.aspx/GetCustomers",
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
                    $("[id$=Member_Name_Label]").text(map[item].Name);
                    $("[id$=Member_Phone_Label]").text(map[item].Phone);
                    $("[id$=MemberID_HF]").val(map[item].MemberID);
                    $("[id$=Member_Phone_HF]").val(map[item].Phone);
                    return item;
                }
            });

            //Get Product info
            $('[id*=ProductCodeTextBox]').typeahead({
                minLength: 1,
                source: function (request, result) {
                    $.ajax({
                        url: "Add_New_Member.aspx/GetProduct",
                        data: JSON.stringify({ 'prefix': request }),
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
                    $("#Current_Stook_Label").text(map[item].Stock);
                    $("#ProductID_HF").val(map[item].ProductID);
                    return item;
                }
            });

            if (parseFloat($("[id*=GTpointHF]").val()) > 125) {
                $("[id*=Generation_Type_RadioB]").hide();
                $("[id*=Generation_Type_RadioB]").find("input[value='G']").attr("checked", "checked");
            }

            //User reset
            $("[id*=MemberUserNameTextBox]").on('keyup', function () {
                $("[id$=Member_Name_Label]").text("");
                $("[id$=Member_Phone_Label]").text("");
                $("[id$=MemberID_HF]").val("");
                $("[id$=Member_Phone_HF]").val("");
                $("[id*=ProductCodeTextBox]").val("");
                $("#user-info").css("display", "none");
            });

            //Product reset
            $("[id*=ProductCodeTextBox]").on('keyup', function () {
                $("[id*=QuantityTextBox]").val("");
                $("#ProductNameLabel").text("");
                $("#ProductPriceLabel").text("");
                $("#ProductPointLabel").text("");
                $("#Current_Stook_Label").text("");
                $("#Tota_Price_Label").text("");
                $("[id*=StookErLabel]").text("");
                $("#ProductID_HF").val("");
                $("#Product-info").css("display", "none");
            });

            //Quantity TextBox
            $("[id*=QuantityTextBox]").on('keyup', function () {
                var Price = parseFloat($("#ProductPriceLabel").text());
                var Qntity = parseFloat($("[id*=QuantityTextBox]").val());
                var StookQunt = parseFloat($("#Current_Stook_Label").text());

                var total = parseFloat(Price * Qntity);

                if (!isNaN(total)) {
                    $("#Tota_Price_Label").text("Total Price: " + total.toFixed(2) + " Tk");
                    StookQunt >= Qntity ? ($("#CartButton").prop("disabled", !1), $("[id*=StookErLabel]").text("Remaining Stook " + (StookQunt - Qntity))) : ($("#CartButton").prop("disabled", !0), $("[id*=StookErLabel]").text("Stock Product Quantity " + StookQunt + ". You Don't Sell " + Qntity));
                }
                else {
                    $("#Tota_Price_Label").text("");
                    $("[id*=StookErLabel]").text("");
                }
            });
        });

        function isNumberKey(a) { a = a.which ? a.which : event.keyCode; return 46 != a && 31 < a && (48 > a || 57 < a) ? !1 : !0 };
    </script>

</asp:Content>
