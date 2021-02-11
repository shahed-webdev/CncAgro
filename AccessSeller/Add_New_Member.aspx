<%@ Page Title="Add New Customer" Language="C#" MasterPageFile="~/Seller.Master" AutoEventWireup="true" CodeBehind="Add_New_Member.aspx.cs" Inherits="CncAgro.AccessSeller.Add_New_Member" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        #Is_Position, #Is_Referral, #Is_LeftRight { color: #ff6a00; display: inline; }
        #user-info { display: none; }
        #Product-info { display: none; }
        .ItemDelete { color: red; cursor: pointer; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Applicant Info</h3>
    <div class="well">
        <div class="row">
            <div class="form-group col-md-3">
                <label>Name*<asp:RequiredFieldValidator ID="Required1" runat="server" ControlToValidate="NameTextBox" CssClass="EroorStar" ValidationGroup="1">*</asp:RequiredFieldValidator></label>
                <asp:TextBox ID="NameTextBox" placeholder="Input Name" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="form-group col-md-3">
                <label>Father's Name</label>
                <asp:TextBox ID="FatherNameTextBox" placeholder="Input Father's Name" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="form-group col-md-3">
                <label>Mother's Name</label>
                <asp:TextBox ID="MotherNameTextBox" placeholder="Input Mother's Name" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="form-group col-md-3">
                <label>Gender</label>
                <asp:RadioButtonList ID="GenderRadioButtonList" runat="server" RepeatDirection="Horizontal" CssClass="form-control">
                    <asp:ListItem Selected="True">Male</asp:ListItem>
                    <asp:ListItem>Female</asp:ListItem>
                </asp:RadioButtonList>
            </div>
            <div class="form-group col-md-6">
                <label>Present Address</label>
                <asp:TextBox ID="Present_AddressTextBox" placeholder="Input Present Address" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="form-group col-md-3">
                <label>
                    Phone*
				<asp:RequiredFieldValidator ID="Required" runat="server" ControlToValidate="PhoneTextBox" CssClass="EroorStar" ForeColor="Red" ValidationGroup="1">*</asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="PhoneTextBox" CssClass="EroorStar" ErrorMessage="Invalid" ValidationExpression="(88)?((011)|(015)|(016)|(017)|(018)|(019))\d{8,8}" ValidationGroup="1"></asp:RegularExpressionValidator>
                </label>
                <asp:TextBox ID="PhoneTextBox" onkeypress="return isNumberKey(event)" runat="server" CssClass="form-control _phone_Check" placeholder="Input Phone number"></asp:TextBox>
            </div>
            <div class="form-group col-md-3">
                <label>
                    E-mail
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="Email" ErrorMessage="Email not valid" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ValidationGroup="1" CssClass="EroorStar"></asp:RegularExpressionValidator>
                </label>
                <asp:TextBox ID="Email" runat="server" CssClass="form-control mail_Check" placeholder="Write@mail.com"></asp:TextBox>
            </div>
            <div class="form-group col-md-3">
                <label>
                    Reference ID*
                     <asp:RegularExpressionValidator ID="Re1" runat="server" ControlToValidate="ReferralIDTextBox" ErrorMessage="*" CssClass="EroorStar" ValidationGroup="1" ValidationExpression="^[a-zA-Z0-9]{9,9}$" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ReferralIDTextBox" CssClass="EroorStar" ForeColor="Red" ValidationGroup="1">*</asp:RequiredFieldValidator>
                    <asp:Label ID="ReferralIDLabel" runat="server" ForeColor="#FF3300"></asp:Label>
                    <label id="Is_Referral"></label>
                </label>
                <asp:TextBox ID="ReferralIDTextBox" autocomplete="off" placeholder="Referral ID" runat="server" CssClass="form-control"></asp:TextBox>

                <div id="R_info" class="alert  alert-info" style="display: none;">
                    <i class="fa fa-user-circle" aria-hidden="true"></i>
                    <label id="R_Name_Label"></label>
                    <i class="fa fa-phone-square" aria-hidden="true"></i>
                    <label id="R_Phone_Label"></label>
                </div>
            </div>
            <div class="form-group col-md-3">
                <label>
                    Placement ID*
				<asp:RequiredFieldValidator ID="Required3" runat="server" ControlToValidate="PositionMemberUserNameTextBox" CssClass="EroorStar" ForeColor="Red" ValidationGroup="1">*</asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="Re2" runat="server" ControlToValidate="PositionMemberUserNameTextBox" ErrorMessage="*" CssClass="EroorStar" ValidationGroup="1" ValidationExpression="^[a-zA-Z0-9]{9,9}$" />
                    <asp:Label ID="PositionLabel" runat="server" ForeColor="#FF3300"></asp:Label>
                    <label id="Is_Position"></label>
                </label>
                <asp:TextBox ID="PositionMemberUserNameTextBox" autocomplete="off" placeholder="Placement ID" runat="server" CssClass="form-control"></asp:TextBox>

                <div id="P_info" class="alert alert-info" style="display: none;">
                    <i class="fa fa-user-circle"></i>
                    <label id="P_Name_Label"></label>
                    <i class="fa fa-phone-square"></i>
                    <label id="P_Phone_Label"></label>
                    <input id="MemberIDhf" type="hidden" />
                </div>
            </div>
            <div class="form-group col-md-3">
                <label>
                    Position Type*<label id="Is_LeftRight"></label>
                    <asp:RequiredFieldValidator ID="Required4" runat="server" ControlToValidate="PositionTypeDropDownList" CssClass="EroorStar" ForeColor="Red" InitialValue="0" ValidationGroup="1">*</asp:RequiredFieldValidator>
                    <asp:Label ID="PositionTypeLabel" runat="server" ForeColor="#FF3300"></asp:Label>
                </label>

                <asp:DropDownList ID="PositionTypeDropDownList" runat="server" CssClass="form-control _pMember_Check">
                    <asp:ListItem Value="0">[ SELECT ]</asp:ListItem>
                    <asp:ListItem Value="Left">Team A</asp:ListItem>
                    <asp:ListItem Value="Right">Team B</asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>
    </div>

    <div class="well">
        <div class="form-group">
            <label>
                Product Code
                </label>
            <asp:TextBox ID="ProductCodeTextBox" placeholder="Product Code" autocomplete="off" runat="server" CssClass="form-control"></asp:TextBox>
        </div>

        <div id="Product-info" class="alert alert-success">
            <div class="userid">
                <i class="fa fa-shopping-bag" aria-hidden="true"></i>
                <label id="ProductNameLabel"></label>

                <i class="fa fa-money" aria-hidden="true"></i>
                Price:
                <label id="ProductPriceLabel"></label>

                <i class="fa fa-star" aria-hidden="true"></i>
                Point:
                <label id="ProductPointLabel"></label>

                <i class="fa fa-chart-pie"></i>
                Current Stock:
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

        <div class="form-group">
            <input id="CartButton" type="button" value="Add To Cart" onclick="addToCart()" class="btn btn-danger" />
        </div>

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
    </div>

    <asp:SqlDataSource ID="RegistrationSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO Registration(InstitutionID, UserName, Validation, Category, Name, FatherName, MotherName, Gender, Present_Address, Phone, Email) VALUES (@InstitutionID, @UserName, 'Valid', N'Member', @Name, @FatherName, @MotherName, @Gender, @Present_Address, @Phone, @Email)" SelectCommand="SELECT * FROM [Registration]" UpdateCommand="UPDATE Institution SET Member_SN =Member_SN +1">
        <InsertParameters>
            <asp:SessionParameter Name="InstitutionID" SessionField="InstitutionID" />
            <asp:Parameter Name="UserName" />
            <asp:ControlParameter ControlID="NameTextBox" Name="Name" PropertyName="Text" />
            <asp:ControlParameter ControlID="FatherNameTextBox" Name="FatherName" PropertyName="Text" />
            <asp:ControlParameter ControlID="MotherNameTextBox" Name="MotherName" PropertyName="Text" />
            <asp:ControlParameter ControlID="GenderRadioButtonList" Name="Gender" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="Present_AddressTextBox" Name="Present_Address" PropertyName="Text" />
            <asp:ControlParameter ControlID="PhoneTextBox" Name="Phone" PropertyName="Text" />
            <asp:ControlParameter ControlID="Email" Name="Email" PropertyName="Text" />
        </InsertParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="MemberSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO Member(MemberRegistrationID, InstitutionID, Referral_MemberID, PositionMemberID, PositionType, Is_Identified, Identified_Date) VALUES ((SELECT  IDENT_CURRENT('Registration')), @InstitutionID,  @Referral_MemberID, @PositionMemberID, @PositionType, 1, GETDATE())" SelectCommand="SELECT * FROM [Member]" UpdateCommand="Add_Update_CarryMember" UpdateCommandType="StoredProcedure">
        <InsertParameters>
            <asp:SessionParameter Name="InstitutionID" SessionField="InstitutionID" Type="Int32" />
            <asp:ControlParameter ControlID="PositionTypeDropDownList" Name="PositionType" PropertyName="SelectedValue" Type="String" />
            <asp:Parameter Name="Referral_MemberID" Type="Int32" />
            <asp:Parameter Name="PositionMemberID" Type="Int32" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="MemberID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="UserLoginSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO [User_Login_Info] ([UserName], [Password], [Email]) VALUES (@UserName, @Password, @Email)" SelectCommand="SELECT * FROM [User_Login_Info]">
        <InsertParameters>
            <asp:Parameter Name="UserName" Type="String" />
            <asp:Parameter Name="Password" Type="String" />
            <asp:ControlParameter ControlID="Email" Name="Email" PropertyName="Text" Type="String" />
        </InsertParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SMS_OtherInfoSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO SMS_OtherInfo(SMS_Send_ID, MemberID, RegistrationID) VALUES (@SMS_Send_ID, @MemberID, @RegistrationID)" SelectCommand="SELECT * FROM [SMS_OtherInfo]">
        <InsertParameters>
            <asp:SessionParameter Name="RegistrationID" SessionField="RegistrationID" Type="Int32" />
            <asp:Parameter DbType="Guid" Name="SMS_Send_ID" />
            <asp:Parameter Name="MemberID" Type="Int32" />
        </InsertParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="A_PointSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="Add_Point" InsertCommandType="StoredProcedure" SelectCommand="SELECT * FROM Member " UpdateCommand="Add_Referral_Bonus" UpdateCommandType="StoredProcedure">
        <InsertParameters>
            <asp:Parameter Name="Point"/>
            <asp:Parameter Name="MemberID" Type="Int32" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="MemberID" Type="Int32" />
            <asp:Parameter Name="Point"/>
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="AutoPlan_SQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="IF EXISTS(SELECT MemberID, Auto_Member_SN FROM  Member  Where MemberID = @MemberID  AND Own_Point &gt;= 500 AND  Auto_Member_SN IS NULL)
BEGIN
	  INSERT INTO Member_AutoPlan (MemberID,AutoPlan_No) Values (@MemberID,1)
END"
        SelectCommand="SELECT * FROM [Member_AutoPlan]" UpdateCommand="Add_Designation_Loop" UpdateCommandType="StoredProcedure">
        <InsertParameters>
            <asp:Parameter Name="MemberID" />
        </InsertParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="ShoppingSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO [Shopping] ([SellerID], [MemberID], [ShoppingAmount],ShoppingPoint) VALUES ((SELECT  SellerID FROM Seller WHERE (SellerRegistrationID = @SellerRegistrationID)), @MemberID, @ShoppingAmount,@ShoppingPoint)
SELECT @ShoppingID = Scope_identity()"
        OnInserted="ShoppingSQL_Inserted" SelectCommand="SELECT * FROM [Shopping]">
        <InsertParameters>
            <asp:SessionParameter Name="SellerRegistrationID" SessionField="RegistrationID" />
            <asp:ControlParameter ControlID="GTpriceHF" Name="ShoppingAmount" PropertyName="Value" />
            <asp:ControlParameter ControlID="GTpointHF" Name="ShoppingPoint" PropertyName="Value" />
            <asp:Parameter Name="MemberID" Type="Int32" />
            <asp:Parameter Direction="Output" Name="ShoppingID" Size="50" />
        </InsertParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SellerUpdateSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM [Seller]" UpdateCommand="UPDATE Seller SET SellingPoint = SellingPoint + @SellingPoint, Selling_Amount = Selling_Amount +@Selling_Amount WHERE (SellerRegistrationID = @SellerRegistrationID)">
        <UpdateParameters>
            <asp:SessionParameter Name="SellerRegistrationID" SessionField="RegistrationID" />
            <asp:ControlParameter ControlID="GTpointHF" Name="SellingPoint" PropertyName="Value" />
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
    <asp:SqlDataSource ID="GenerationSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="Add_Generation_Retail" InsertCommandType="StoredProcedure" SelectCommand="SELECT Generation_UniLevel_ID FROM Generation_Uni_Level" UpdateCommand="Add_Generation_UniLevel" UpdateCommandType="StoredProcedure">
        <InsertParameters>
            <asp:Parameter Name="MemberID" Type="Int32" />
            <asp:Parameter Name="Point"/>
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="MemberID" Type="Int32" />
            <asp:Parameter Name="Point"/>
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="Package_UpdateSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Member_PackageID FROM Member_Package" UpdateCommand="Add_Package_Update" UpdateCommandType="StoredProcedure">
        <UpdateParameters>
            <asp:Parameter Name="MemberID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="Product_Selling_RecordsSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO Product_Selling_Records(ProductID, ShoppingID, SellingQuantity, SellingUnitPrice, SellingUnitPoint) VALUES (@ProductID,@ShoppingID, @SellingQuantity, @SellingUnitPrice, @SellingUnitPoint)" SelectCommand="SELECT * FROM [Product_Selling_Records]">
        <InsertParameters>
            <asp:Parameter Name="ProductID" Type="Int32" />
            <asp:Parameter Name="ShoppingID" />
            <asp:Parameter Name="SellingQuantity" Type="Int32" />
            <asp:Parameter Name="SellingUnitPrice" Type="Double" />
            <asp:Parameter Name="SellingUnitPoint" Type="Double" />
        </InsertParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="Seller_ComissionSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="Add_Seller_Commission" InsertCommandType="StoredProcedure" SelectCommand="SELECT * FROM [Seller]">
        <InsertParameters>
            <asp:SessionParameter Name="SellerID" SessionField="SellerID" Type="Int32" />
            <asp:ControlParameter ControlID="GTpointHF" Name="Point" PropertyName="Value"/>
            <asp:Parameter Name="ShoppingID" Type="Int32" />
        </InsertParameters>
    </asp:SqlDataSource>

    <div id="AddCustomer" class="form-inline" style="visibility: hidden;">
        <div class="form-group">
            <asp:RadioButtonList ID="Generation_Type_RadioB" runat="server" CssClass="form-control" RepeatDirection="Horizontal" RepeatLayout="Flow">
                <asp:ListItem Selected="True" Value="G">Generation Commission</asp:ListItem>
                <asp:ListItem Value="R">Retail Profit  Commission</asp:ListItem>
            </asp:RadioButtonList>
        </div>
        <div class="form-group">
            <asp:Button ID="Add_Customer_Button" runat="server" CssClass="btn btn-primary" Text="Submit" ValidationGroup="1" OnClick="Add_Customer_Button_Click" />
            <asp:Label ID="ErrorLabel" runat="server" CssClass="EroorStar"></asp:Label>
        </div>
        <asp:HiddenField ID="JsonData" runat="server" />
    </div>


    <script>
        var cart = [];
        $(function () {
            $("[id*=Add_Customer_Button]").click(function () {
                if (localStorage.cart) {
                    $("[id*=JsonData]").val(JSON.stringify(cart));
                }
            });

            if (localStorage.cart) {
                cart = JSON.parse(localStorage.cart);
                showCart();
            }
        });

        function addToCart() {
            var ProductID = $("#ProductID_HF").val();
            var Code = $("[id*=ProductCodeTextBox]").val();
            var Name = $("#ProductNameLabel").text();
            var Quantity = $("[id*=QuantityTextBox]").val().trim();
            var Unit_Price = $("#ProductPriceLabel").text();
            var Unit_Point = $("#ProductPointLabel").text();

           
            // create JavaScript Object
            if (Code != '' && Quantity != '' && ProductID != '') {
                // if Code is already present
                for (var i in cart) {
                    if (cart[i].ProductID == ProductID) { alert("This Product already added"); return; }
                }

                var item = { Code: Code, ProductID: ProductID, Name: Name, Quantity: Quantity, Unit_Price: Unit_Price, Unit_Point: Unit_Point };
                cart.push(item);
                saveCart();
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

        function saveCart() {
            if (window.localStorage) {
                localStorage.cart = JSON.stringify(cart);
            }
        }

        //Delete
        $(document).on("click", ".ItemDelete", function () {
            var index = $(this).closest("tr").index();

            cart.splice(index, 1);
            showCart();
            saveCart();

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
            if (cart.length == 0) {
                $(".cart").css("visibility", "hidden");
                $("#AddCustomer").css("visibility", "hidden");
                return;
            }

            $(".cart").css("visibility", "visible");
            $("#AddCustomer").css("visibility", "visible");
            var cartTable = $("#cartBody");
            cartTable.empty();

            $.each(cart, function () {
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
                  '<td class="text-center" style="width:20px;"><b class="ItemDelete">Delete</b></td>' +
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
            localStorage.removeItem("cart");
        }
        /**End Cart*/

        $(function () {
            //Link Active
            $("#Add_Customer").addClass('L_Active');

            //Get Referral Member
            $('[id*=ReferralIDTextBox]').typeahead({
                minLength: 4,
                source: function (request, result) {
                    $.ajax({
                        url: "Add_New_Member.aspx/Get_UserInfo_ID",
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

                            if (label == "") {
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

            //Get Position Member
            $('[id*=PositionMemberUserNameTextBox]').typeahead({
                minLength: 4,
                source: function (request, result) {
                    $.ajax({
                        url: "Add_New_Member.aspx/Get_UserInfo_ID",
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

                            $("#MemberIDhf").val("");
                            if (label == "") {
                                $("[id*=Add_Customer_Button]").prop("disabled", true);
                                $("[id*=PositionTypeDropDownList]").prop("disabled", true);
                                $("[id*=PositionTypeDropDownList]")[0].selectedIndex = 0;
                                $("#Is_Position").text("Placement ID is not valid");
                            }
                            else {
                                $("#Is_Position").text("");
                                $("[id*=PositionTypeDropDownList]").prop("disabled", false);
                            }
                        }
                    });
                },
                updater: function (item) {
                    $("#P_info").css("display", "block");
                    $("#P_Name_Label").text(map[item].Name);
                    $("#P_Phone_Label").text(map[item].Phone);
                    $("#MemberIDhf").val(map[item].MemberID);
                    $("[id*=PositionTypeDropDownList]")[0].selectedIndex = 0;
                    $("#Is_LeftRight").text('');
                    return item;
                }
            });


            //Check Left right
            $("[id*=PositionTypeDropDownList]").prop("disabled", true);

            $("[id*=PositionTypeDropDownList]").on('change', function () {
                var Position_MemberID = $("#MemberIDhf").val();
                var PositionType = $(this).find('option:selected').text();

                if (Position_MemberID != "" && $("[id*=PositionTypeDropDownList] option:selected").val() != "0") {
                    $.ajax({
                        type: "POST",
                        url: "Add_New_Member.aspx/Check_Left_Right",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify({ 'Position_MemberID': Position_MemberID, 'PositionType': PositionType }),
                        dataType: "json",
                        success: function (response) {
                            $("#Is_LeftRight").text(response.d);

                            if (response.d != "") {
                                $("[id*=Add_Customer_Button]").prop("disabled", true);
                            }
                            else {
                                if ($("#Is_Position").text() == "" && $("#Is_Referral").text() == "" && $("#Is_LeftRight").text() == "") {
                                    $("[id*=Add_Customer_Button]").prop("disabled", false);
                                }
                            }
                        }
                    });
                }

                if (Position_MemberID == "") {
                    $("[id*=PositionMemberUserNameTextBox]").val("");
                }
            });


            //*********Add Product********
            if (parseFloat($("[id*=GTpointHF]").val()) >= 125) {
                $("[id*=Generation_Type_RadioB]").hide();
                $("[id*=Generation_Type_RadioB]").find("input[value='G']").attr("checked", "checked");
            }

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

        function isNumberKey(a) { a = a.which ? a.which : event.keyCode; return 46 != a && 31 < a && (48 > a || 57 < a) ? !1 : !0 };
    </script>
</asp:Content>
