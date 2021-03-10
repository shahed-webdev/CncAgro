<%@ Page Title="Order Details" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Order_Details.aspx.cs" Inherits="CncAgro.AccessAdmin.Member.ProductDistribution.Order_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        #Product-info { display: none; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <a href="Order_Confirmation.aspx"><i class="far fa-hand-point-left mr-1"></i>Back to order list</a>

    <asp:FormView ID="InfoFormView" runat="server" DataSourceID="MemberInfoSQL" Width="100%" DataKeyNames="MemberID,Available_Balance">
        <ItemTemplate>
            <input id="MemberidHF" type="hidden" value='<%#Eval("MemberID") %>' />
            <h4 style="margin-top: 0; margin-bottom: 2px;"><%# Eval("Name") %> <small style="color: #ff6a00">Balance: <%#Eval("Available_Balance","{0:N}")%> Tk</small></h4>
            <small>
                <i class="fas fa-user-circle"></i>
                <%# Eval("UserName") %>

                <i class="fas fa-phone ml-2"></i>
                <%# Eval("Phone") %>

                <i class="fas fa-list-ul ml-2"></i>
                Receipt No. <%# Eval("Distribution_SN") %>
            </small>
        </ItemTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="MemberInfoSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_Distribution.Distribution_SN, Registration.UserName, Registration.Name, Registration.Phone, Product_Distribution.MemberID, Member.Available_Balance FROM Product_Distribution INNER JOIN Member ON Product_Distribution.MemberID = Member.MemberID INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE (Product_Distribution.Product_DistributionID = @Product_DistributionID)">
        <SelectParameters>
            <asp:QueryStringParameter Name="Product_DistributionID" QueryStringField="DistributionID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <div class="card card-body mt-3">
        <h5 class="font-weight-bold mb-3">Add More Product</h5>

        <div class="row">
            <div class="col-sm-5">
                <div class="form-group">
                    <label>
                        Product Code
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="ProductCodeTextBox" CssClass="EroorStar" ErrorMessage="Required" ValidationGroup="1"></asp:RequiredFieldValidator>
                    </label>
                    <asp:TextBox ID="ProductCodeTextBox" placeholder="Product Code" runat="server" CssClass="form-control" autocomplete="off"></asp:TextBox>
                </div>

                <div id="Product-info">
                    <div class="mb-3">
                        <strong>
                            <i class="fa fa-shopping-bag"></i>
                            <span id="ProductNameLabel"></span>
                        </strong>

                        <strong class="mx-2">
                            <i class="fas fa-money-bill-alt"></i>
                            <span id="ProductPriceLabel"></span>
                        </strong>

                        <strong>
                            <i class="fa fa-shopping-basket"></i>
                            <span id="Current_Stock_Label"></span>
                        </strong>
                    </div>
                    <asp:HiddenField ID="ProductID_HF" runat="server" />
                    <asp:HiddenField ID="ProductName_HF" runat="server" />
                    <asp:HiddenField ID="UPHF" runat="server" />
                    <asp:HiddenField ID="Current_StookHF" runat="server" />
                </div>
            </div>
            <div class="col-sm-4">
                <div class="form-group">
                    <label>
                        Quantity
                <asp:Label ID="StookErLabel" runat="server" ForeColor="#009933"></asp:Label>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="QuantityTextBox" CssClass="EroorStar" ErrorMessage="Required" ValidationGroup="1"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="Rex" runat="server" ControlToValidate="QuantityTextBox" ErrorMessage="0 Not Allowed" ValidationExpression="^(?=.*[1-9])(?:[1-9]\d*\.?|0?\.)\d*$" ValidationGroup="1" CssClass="EroorStar" />
                    </label>
                    <asp:TextBox ID="QuantityTextBox" placeholder="Quantity" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" runat="server" CssClass="form-control"></asp:TextBox>
                    <label class="P_Tag" id="Tota_Price_Label"></label>
                </div>
            </div>
            <div class="col-sm-3">
                <div class="form-group pt-4">
                    <asp:Button ID="AddToCartButton" runat="server" CssClass="btn btn-primary" Text="Add To Cart" OnClick="AddToCartButton_Click" ValidationGroup="1" />
                </div>
            </div>
        </div>
    </div>

    <div class="card card-body mt-4">
        <div class="table-responsive">
            <asp:GridView ID="ChargeGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" ShowFooter="True">
                <Columns>
                    <asp:TemplateField Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="PIDLabel" runat="server" Text='<%# Bind("ProductID") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Product Name">
                        <ItemTemplate>
                            <asp:Label ID="ProductNameLabel" runat="server" Text='<%# Bind("Product_Name") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Code">
                        <ItemTemplate>
                           <%# Eval("Product_Code") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Quantity">
                        <ItemTemplate>
                            <asp:Label ID="QntLabel" runat="server" Text='<%# Bind("SellingQuantity") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Unit Price">
                        <ItemTemplate>
                            <asp:Label ID="Selling_UPLabel" runat="server" Text='<%# Bind("SellingUnitPrice") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Line Total">
                        <ItemTemplate>
                            <asp:Label ID="TotalPriceLabel" runat="server" Text='<%# Bind("ProductPrice") %>'></asp:Label>
                        </ItemTemplate>
                        <FooterTemplate>
                            <strong id="Amount_GrandTotal"></strong>
                        </FooterTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Delete">
                        <ItemTemplate>
                            <asp:Button runat="server" CausesValidation="False" class="btn" Text="delete" CommandName="Delete" OnClick="RowDelete"/>
                        </ItemTemplate>
                        <ItemStyle Width="40px" />
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <asp:SqlDataSource ID="Product_DistributionSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>"
        SelectCommand="SELECT * FROM [Product_Distribution]" UpdateCommand="UPDATE Product_Distribution SET Product_Total_Point = @Product_Total_Point, Is_Confirmed = 1, Confirm_Date = GETDATE(), Confirmed_RegistrationID = @RegistrationID, Product_Total_Amount = @Product_Total_Amount WHERE (Product_DistributionID = @Product_DistributionID)">
        <UpdateParameters>
            <asp:ControlParameter ControlID="Total_Point_HF" Name="Product_Total_Point" PropertyName="Value" />
            <asp:SessionParameter Name="RegistrationID" SessionField="RegistrationID" />
            <asp:ControlParameter ControlID="Total_Price_HF" Name="Product_Total_Amount" PropertyName="Value" />
            <asp:QueryStringParameter Name="Product_DistributionID" QueryStringField="DistributionID" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="Product_Distribution_RecordsSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO Product_Distribution_Records(Product_DistributionID, ProductID, SellingQuantity, SellingUnitPrice, SellingUnitPoint) VALUES (@Product_DistributionID, @ProductID, @SellingQuantity, @SellingUnitPrice, @SellingUnitPoint)" SelectCommand="SELECT * FROM [Product_Distribution_Records]" DeleteCommand="DELETE FROM Product_Distribution_Records WHERE (Product_DistributionID = @Product_DistributionID)">
        <DeleteParameters>
            <asp:QueryStringParameter Name="Product_DistributionID" QueryStringField="DistributionID" />
        </DeleteParameters>
        <InsertParameters>
            <asp:QueryStringParameter Name="Product_DistributionID" QueryStringField="DistributionID" Type="Int32" />
            <asp:Parameter Name="ProductID" Type="Int32" />
            <asp:Parameter Name="SellingQuantity" Type="Int32" />
            <asp:Parameter Name="SellingUnitPrice" Type="Double" />
            <asp:Parameter Name="SellingUnitPoint" Type="Double" />
        </InsertParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="Cancel_SQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" DeleteCommand="DELETE FROM Product_Distribution_Records WHERE (Product_DistributionID = @Product_DistributionID)
DELETE FROM Product_Distribution WHERE (Product_DistributionID = @Product_DistributionID)"
        SelectCommand="SELECT Product_DistributionID FROM Product_Distribution">
        <DeleteParameters>
            <asp:QueryStringParameter Name="Product_DistributionID" QueryStringField="DistributionID" />
        </DeleteParameters>
    </asp:SqlDataSource>


    <div class="mt-3">
        <asp:HiddenField ID="Total_Price_HF" runat="server" />
        <asp:HiddenField ID="Total_Point_HF" runat="server" />

        <asp:Button ID="Confirm_Button" runat="server" CssClass="btn btn-primary" OnClick="Confirm_Button_Click" Text="Confirm Order" />
        <asp:Button ID="CancelButton" OnClientClick="return confirm('This order will delete permanently and balance will be return.\n Are you sure want to delete?')" runat="server" CssClass="btn btn-danger" Text="Cancel Order" OnClick="CancelButton_Click" />
    </div>


    <script>
        $(function () {
            var amountTotal = 0;
            $("[id*=TotalPriceLabel]").each(function () { amountTotal = amountTotal + parseFloat($(this).text()) });
            $("#Amount_GrandTotal").text(`Total: ৳${amountTotal.toFixed(2)}`);
            $("[id*=Total_Price_HF]").val(amountTotal);


            //Get Product info
            $('[id*=ProductCodeTextBox]').typeahead({
                minLength: 2,
                source: function (request, result) {
                    $.ajax({
                        url: "Order_Details.aspx/GetProduct",
                        data: JSON.stringify({ 'prefix': request}),
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
                    $("#ProductPriceLabel").text(`Price: ${map[item].Price}`);
                    $("#Current_Stock_Label").text(`Current Stock: ${map[item].Stock}`);


                    $("[id$=ProductID_HF]").val(map[item].ProductID);
                    $("[id$=ProductName_HF]").val(map[item].Name);
                    $("[id$=UPHF]").val(map[item].Price);
                    $("[id$=Current_StookHF]").val(map[item].Stock);

                    return item;
                }
            });

            //Product reset
            $("[id*=ProductCodeTextBox]").on('keyup', function () {
                $("#ProductNameLabel").text("");
                $("#ProductPriceLabel").text("");
                $("#ProductPointLabel").text("");
                $("[id*=QuantityTextBox]").val("");

                $("[id$=ProductID_HF]").val("");
                $("[id$=ProductName_HF]").val("");
                $("[id$=UPHF]").val("");
                $("[id$=Commission_HF").val("");
                $("#Product-info").css("display", "none");
            });

            //Quantity TextBox
            $("[id*=QuantityTextBox]").on('keyup', function () {
                const Price = parseFloat($("[id$=UPHF]").val());
                let quantity = parseFloat($("[id*=QuantityTextBox]").val());
                const stockQuantity = parseFloat($("[id$=Current_StookHF]").val());

                const total = parseFloat(Price * quantity);

                if (!isNaN(total)) {
                    $("#Tota_Price_Label").text(`Total Price: ${total.toFixed(2)} Tk`);

                    "" === ($("[id*=QuantityTextBox]").val()) && (quantity = 0);
                    stockQuantity >= quantity ? ($("[id*=AddToCartButton]").prop("disabled", false), $("[id*=StookErLabel]").text(`Remaining Stock ${stockQuantity - quantity}`)) : ($("[id*=AddToCartButton]").prop("disabled", true), $("[id*=StookErLabel]").text(`Quantity more than stock: ${stockQuantity}`));
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
