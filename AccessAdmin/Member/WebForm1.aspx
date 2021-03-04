<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="CncAgro.AccessAdmin.Member.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
<script>
        var cart = [];

        function addToCart() {
            const productId = $("#ProductID_HF").val();
            const Code = $("[id*=ProductCodeTextBox]").val();
            const Name = $("#ProductNameLabel").text();
            const Quantity = $("[id*=QuantityTextBox]").val().trim();
            const unitPrice = $("#ProductPriceLabel").text();
            const unitPoint = $("#ProductPointLabel").text();


            // create JavaScript Object
            if (Code !== '' && Quantity !== '' && productId !== '') {
                // if Code is already present
                for (let i in cart) {
                    if (cart[i].ProductID === productId) { alert("This Product already added"); return; }
                }

                const item = { Code: Code, ProductID: productId, Name: Name, Quantity: Quantity, Unit_Price: unitPrice, Unit_Point: unitPoint };
                cart.push(item);

                showCart();

                $("[id*=ProductCodeTextBox]").val("");
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


        //Delete
        $(document).on("click", ".ItemDelete", function () {
            const index = $(this).closest("tr").index();

            cart.splice(index, 1);

            showCart();
            getTotalPrice();
            getTotalPoint();
        });

        function getTotalPrice() {
            var total = 0;
            $.each(cart, function () {
                total += this.Quantity * this.Unit_Price;
            });
            $("#GrandTotal").text(total);
            $("[id*=GTpriceHF]").val(total);
        }

        function getTotalPoint() {
            var total = 0;
            $.each(cart, function () {
                total += this.Quantity * this.Unit_Point;
            });
            $("#PointGrandTotal").text(total);
            $("[id*=GTpointHF]").val(total);
        }

        function showCart() {
            if (!cart.length) {
                $(".cart").css("display", "none");
                $("#addCustomer").css("display", "none");
                return;
            }

            $(".cart").css("display", "table");
            $("#addCustomer").css("display", "block");

            var cartTable = $("#cartBody");
            cartTable.empty();

            $.each(cart, function () {
                const tPrice = this.Quantity * this.Unit_Price;
                const tPoint = this.Quantity * this.Unit_Point;
                cartTable.append(
                    `<tr><td>${this.Name}</td><td>${this.Quantity}</td><td>৳${this.Unit_Price}</td><td>${this.Unit_Point}</td><td>৳${tPrice.toFixed(2)}</td><td>${tPoint.toFixed(2)}</td><td class="text-center" style="width:20px;"><b class="ItemDelete">Delete</b></td></tr>`
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
        /**End Cart*/

        $(function () {
            $("[id*=Add_Customer_Button]").click(function () {
                $("[id*=JsonData]").val(JSON.stringify(cart));
            });

            //Link Active
            $("#Add_Customer").addClass('L_Active');

            //Get Referral Member
            $('[id*=ReferralIDTextBox]').typeahead({
                minLength: 4,
                source: function (request, result) {
                    $.ajax({
                        url: "Add_Member.aspx/Get_UserInfo_ID",
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

                            if (label === "") {
                                $("[id*=Add_Customer_Button]").prop("disabled", true);
                                $("#Is_Referral").text("Referral ID is not valid");
                            }
                            else {
                                $("#Is_Referral").text("");
                            }
                        }
                    });
                },
                updater: function (item) {
                    $("#R_info").css("display", "block");
                    $("#R_Name_Label").text(map[item].Name);
                    $("#R_Phone_Label").text(map[item].Phone);
                    return item;
                }
            });


            //*********Add Product********
            //Get Product info
            $('[id*=ProductCodeTextBox]').typeahead({
                minLength: 1,
                source: function (request, result) {
                    $.ajax({
                        url: "Add_Member.aspx/GetProduct",
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

            //Product reset
            $("[id*=ProductCodeTextBox]").on('keyup', function () {
                $("#ProductNameLabel").text("");
                $("#ProductPriceLabel").text("");
                $("#ProductPointLabel").text("");
                $("#Current_Stook_Label").text("");

                $("[id*=QuantityTextBox]").val("");
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

        function isNumberKey(a) { a = a.which ? a.which : event.keyCode; return 46 !== a && 31 < a && (48 > a || 57 < a) ? false : true };
</script>
</body>
</html>
