<%@ Page Title="Customer Registration" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Add_Member.aspx.cs" Inherits="CncAgro.AccessAdmin.Member.Add_Member" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .remove { cursor: pointer; color: #ff0000 }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="container">
        <h3>Applicant Info</h3>

        <div class="card card-body">
            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label>Name*</label>
                        <asp:TextBox ID="NameTextBox" runat="server" CssClass="form-control" required=""></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label>Father's Name</label>
                        <asp:TextBox ID="FatherNameTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label>Mobile Number*</label>
                        <asp:TextBox ID="PhoneTextBox" minlength="11" MaxLength="11" pattern="(88)?((011)|(015)|(016)|(017)|(013)|(014)|(018)|(019))\d{8,8}" onkeypress="return isNumberKey(event)" runat="server" CssClass="form-control" required=""></asp:TextBox>
                    </div>
                </div>
            </div>

            <div class="row my-3">
                <div class="col-md-5">
                    <div class="form-group">
                        <label>Present Address</label>
                        <asp:TextBox ID="Present_AddressTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label>Date of Birth</label>
                        <asp:TextBox ID="DateofBirthTextBox" runat="server" CssClass="form-control datepicker"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label>Gender</label>
                        <asp:RadioButtonList ID="GenderRadioButtonList" runat="server" RepeatDirection="Horizontal" CssClass="form-control">
                            <asp:ListItem Selected="True">Male</asp:ListItem>
                            <asp:ListItem>Female</asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label>E-mail</label>
                        <asp:TextBox ID="Email" type="email" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label>Applicant Photo</label>
                        <div class="custom-file">
                            <asp:FileUpload class="custom-file-input" ID="UserPhotoFileUpload" runat="server" accept="image/*" />
                            <label class="custom-file-label" for="body_UserPhotoFileUpload">Choose file</label>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label id="errorReference">Reference Id*</label>
                        <asp:TextBox ID="ReferralIDTextBox" minlength="9" MaxLength="9" onkeypress="return isNumberKey(event)" autocomplete="off" runat="server" CssClass="form-control" required=""></asp:TextBox>
                        <asp:HiddenField ID="HiddenReferralMemberId" runat="server" />

                        <div id="show-reference-info" class="mt-2"></div>
                    </div>
                </div>
            </div>
        </div>

        <h3 class="mt-4">Add Product</h3>
        <div class="card card-body">
            <div class="row">
                <div class="col-md-6 mx-auto">
                    <div class="form-group">
                        <h6 class="font-weight-bold text-center">Add Product by Code</h6>
                        <input id="inputProductCode" type="text" autocomplete="off" placeholder="find Product" class="form-control" />
                    </div>
                </div>
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

            <div class="text-right">
                <h5 id="grandTotal" class="font-weight-bold"></h5>
            </div>
        </div>

        <div id="postCustomer" class="mt-3">
            <asp:Button ID="Add_Customer_Button" runat="server" CssClass="btn btn-primary btn-lg" Text="Submit" ValidationGroup="1" OnClientClick="return formValidation();" OnClick="Add_Customer_Button_Click" />
            <asp:Label ID="ErrorLabel" runat="server" CssClass="EroorStar"></asp:Label>

            <!--pass total amount/point-->
            <asp:HiddenField ID="HiddenGrandTotalAmount" runat="server" />
            <!--pass array as text-->
            <asp:HiddenField ID="JsonData" runat="server" />
        </div>
    </div>


    <div>
        <asp:SqlDataSource ID="RegistrationSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO Registration(InstitutionID, UserName, Validation, Category, Name, FatherName, Gender, Present_Address, Phone, Email, Image) VALUES (@InstitutionID, @UserName, 'Valid', N'Member', @Name, @FatherName, @Gender, @Present_Address, @Phone, @Email, @Image)" SelectCommand="SELECT * FROM [Registration]" UpdateCommand="UPDATE Institution SET Member_SN =Member_SN +1">
            <InsertParameters>
                <asp:Parameter Name="UserName" />
                <asp:SessionParameter Name="InstitutionID" SessionField="InstitutionID" />
                <asp:ControlParameter ControlID="NameTextBox" Name="Name" PropertyName="Text" />
                <asp:ControlParameter ControlID="FatherNameTextBox" Name="FatherName" PropertyName="Text" />
                <asp:ControlParameter ControlID="GenderRadioButtonList" Name="Gender" PropertyName="SelectedValue" />
                <asp:ControlParameter ControlID="Present_AddressTextBox" Name="Present_Address" PropertyName="Text" />
                <asp:ControlParameter ControlID="PhoneTextBox" Name="Phone" PropertyName="Text" />
                <asp:ControlParameter ControlID="Email" Name="Email" PropertyName="Text" />
                <asp:ControlParameter ControlID="UserPhotoFileUpload" Name="Image" PropertyName="FileBytes" />
            </InsertParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="MemberSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO Member(MemberRegistrationID, InstitutionID, Referral_MemberID,   Is_Identified, Identified_Date) VALUES ((SELECT  IDENT_CURRENT('Registration')), @InstitutionID,  @Referral_MemberID, 1, GETDATE())" SelectCommand="SELECT * FROM [Member]" UpdateCommand="Add_Update_CarryMember" UpdateCommandType="StoredProcedure">
            <InsertParameters>
                <asp:SessionParameter Name="InstitutionID" SessionField="InstitutionID" Type="Int32" />
                <asp:Parameter Name="Referral_MemberID" Type="Int32" />
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
                <asp:Parameter Name="Point" />
                <asp:Parameter Name="MemberID" Type="Int32" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="MemberID" Type="Int32" />
                <asp:Parameter Name="Point" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="ShoppingSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO Shopping(Seller_RegistrationID, MemberID, ShoppingAmount, ShoppingPoint) VALUES (@SellerRegistrationID, @MemberID, @ShoppingAmount, @ShoppingPoint)
SELECT @ShoppingID = Scope_identity()"
            OnInserted="ShoppingSQL_Inserted" SelectCommand="SELECT * FROM [Shopping]">
            <InsertParameters>
                <asp:SessionParameter Name="SellerRegistrationID" SessionField="RegistrationID" />
                <asp:Parameter Name="MemberID" Type="Int32" />
                <asp:ControlParameter ControlID="HiddenGrandTotalAmount" Name="ShoppingAmount" PropertyName="Value" />
                <asp:ControlParameter ControlID="HiddenGrandTotalAmount" Name="ShoppingPoint" PropertyName="Value" />
                <asp:Parameter Name="ShoppingID" Direction="Output" Size="50" />
            </InsertParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SellerProductSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_PointID FROM Product_Point_Code" UpdateCommand="UPDATE Product_Point_Code SET Stock_Quantity = Stock_Quantity - @Stock_Quantity WHERE (Product_PointID = @Product_PointID)">
            <UpdateParameters>
                <asp:Parameter Name="Stock_Quantity" />
                <asp:Parameter Name="Product_PointID" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="Retail_IncomeSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="Add_Retail_Income" InsertCommandType="StoredProcedure" SelectCommand="SELECT Generation_Retail_RecordsID FROM Member_Bouns_Records_Gen_Retails" UpdateCommand="Add_Generation_Income" UpdateCommandType="StoredProcedure">
            <InsertParameters>
                <asp:Parameter Name="MemberID" Type="Int32" />
                <asp:Parameter Name="Point" Type="Int32" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="MemberID" Type="Int32" />
                <asp:Parameter Name="Point" Type="Int32" />
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
    </div>

    <script>
        const addMember = (function () {
            //**** REFERENCE INFO ****
            const inputReferenceId = document.getElementById("body_ReferralIDTextBox");
            const referenceMemberId = document.getElementById("body_HiddenReferralMemberId");
            const referenceInfo = document.getElementById("show-reference-info");

            //autocomplete
            $(inputReferenceId).typeahead({
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
                        url: "Add_Member.aspx/GetUsers",
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
                    appendReferenceInfo(item);
                    return item;
                }
            })

            //on input reference id
            inputReferenceId.addEventListener("input", function () {
                referenceMemberId.value = "";
                referenceInfo.innerHTML = "";
            });

            //append find user info
            function appendReferenceInfo(item) {
                const memberId = document.getElementById("body_HiddenReferralMemberId");
                memberId.value = item.MemberID;

                const infoContainer = document.getElementById("show-reference-info");
                infoContainer.innerHTML = `<span class="badge badge-dark mr-2">${item.Name}</span><span class="badge badge-dark">${item.Phone}</span>`
            }

            //set image file
            $('input[type="file"]').change(function (e) {
                const pathInput = e.target.parentElement.parentElement;
                const size = e.target.files[0].size / 1024 / 1024;
                const allowSize = 1;
                const regex = new RegExp("(.*?)\.(jpeg|jpg|png|webp)$");


                if (!(regex.test(e.target.value.toLowerCase()))) {
                    e.target.value = "";
                    $(pathInput).notify("Please select correct file format", { position: "bottom left" });
                    return;
                }

                if (size > allowSize) {
                    e.target.value = "";
                    $(pathInput).notify(`image size must be less than ${allowSize}MB. your file size:${size.toFixed()} MB`, { position: "bottom left" });
                    return;
                }
            });


            //**** PRODUCT ****//
            let cart = [];
            const inputProductCode = document.getElementById("inputProductCode");
            const tBody = document.getElementById("tBody");

            //autocomplete
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
                        url: "Add_Member.aspx/GetProduct",
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
                localStorage.setItem('added-product', JSON.stringify(cart));

                grandTotalAmount();
            }

            //sum total amount
            const postJsonData = document.getElementById("body_JsonData");

            function grandTotalAmount() {
                const total = cart.reduce((acc, item) => acc + item.TotalPrice, 0);

                document.getElementById("body_HiddenGrandTotalAmount").value = total;
                document.getElementById("grandTotal").textContent = total ? `Grand Total: ৳${total}` : "";

                //set array for submit to database
                postJsonData.value = cart.length ? JSON.stringify(cart) : "";
            }

            //add new product to table
            function addProduct(product) {
                const isAdded = cart.some(item => item.ProductID === product.ProductID);
                if (isAdded) {
                    $(inputProductCode).notify("Product already added to list", { position: "bottom left" });
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
                    <td><strong>${item.Name}</strong></td>
                    <td>৳${item.Price}</td>
                    <td><input min="1" max="${item.Stock}" id="${item.ProductID}" data-stock="${item.Stock}" data-price="${item.Price}" type="number" value="${item.Quantity}" class="form-control inputQuantity" required></td>
                    <td>৳<span class="total-price">${item.TotalPrice}</span></td>
                    <td class="text-center"><i id="${item.ProductID}" class="remove fas fa-trash"></i></td>`
                return tr;
            }

            //append product info
            const rebuildProductTable = function () {
                tBody.innerHTML = "";
                const store = localStorage.getItem("added-product");
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
            const resetReferenceInfo = function () {
                if (inputReferenceId.value)
                    inputReferenceId.value = "";

                referenceMemberId.value = "";
                referenceInfo.innerHTML = "";
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
                if (!referenceMemberId.value && inputReferenceId.value !== "") {
                    $("#errorReference").notify("invalid reference user", { position: "top right" });
                    return false;
                }

                if (!postJsonData.value) {
                    $("#postCustomer").notify("No Product Added!", { position: "bottom left" });
                    return false;
                }

                return true;
            }

            //clear cart after submit
            const emptyCart = function () {
                cart = [];
                localStorage.removeItem('added-product');
            }

            //***public function***
            return {
                rebuildProductTable,
                resetReferenceInfo,
                formIsValid,
                emptyCart
            }
        })();


        //call function
        addMember.resetReferenceInfo();
        addMember.rebuildProductTable();

        //check form validation before submit
        function formValidation() {
            const isValid = addMember.formIsValid();

            if (isValid) addMember.emptyCart();

            return isValid;
        }

        //allow only number
        function isNumberKey(a) { a = a.which ? a.which : event.keyCode; return 46 !== a && 31 < a && (48 > a || 57 < a) ? false : true };
    </script>
</asp:Content>
