<%@ Page Title="Customer Registration" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Add_Member.aspx.cs" Inherits="CncAgro.AccessAdmin.Member.Add_Member" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">

    <div class="container">
        <h3>Applicant Info</h3>

        <div class="card card-body">
            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label>Name*<asp:RequiredFieldValidator ErrorMessage="Enter Name" ID="Required1" runat="server" ControlToValidate="NameTextBox" CssClass="EroorStar" ValidationGroup="1">*</asp:RequiredFieldValidator></label>
                        <asp:TextBox ID="NameTextBox" runat="server" CssClass="form-control"></asp:TextBox>
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
                        <label>
                            Phone*
                            <asp:RequiredFieldValidator ErrorMessage="Enter Mobile No." ID="Required" runat="server" ControlToValidate="PhoneTextBox" CssClass="EroorStar" ForeColor="Red" ValidationGroup="1">*</asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="PhoneTextBox" CssClass="EroorStar" ErrorMessage="Invalid Mobile No. " ValidationExpression="(88)?((011)|(015)|(016)|(017)|(013)|(014)|(018)|(019))\d{8,8}" ValidationGroup="1"></asp:RegularExpressionValidator>
                        </label>
                        <asp:TextBox ID="PhoneTextBox" onkeypress="return isNumberKey(event)" runat="server" CssClass="form-control"></asp:TextBox>
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
                        <label>
                            E-mail
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="Email" ErrorMessage="Email not valid" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ValidationGroup="1" CssClass="EroorStar"></asp:RegularExpressionValidator>
                        </label>
                        <asp:TextBox ID="Email" runat="server" CssClass="form-control mail_Check"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label>Applicant Photo</label>
                        <div class="custom-file">
                            <input type="file" class="custom-file-input" id="applicant-photo" accept="image/*">
                            <label class="custom-file-label" for="applicant-photo">Choose file</label>
                        </div>
                        <asp:HiddenField ID="ApplicantPhotoHF" runat="server" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label>
                            Reference Id*
                            <asp:RegularExpressionValidator ID="Re1" runat="server" ControlToValidate="ReferralIDTextBox" ErrorMessage="*" CssClass="EroorStar" ValidationGroup="1" ValidationExpression="^[a-zA-Z0-9]{9,9}$" />
                            <asp:RequiredFieldValidator ErrorMessage="Enter Reference ID" ID="RequiredFieldValidator1" runat="server" ControlToValidate="ReferralIDTextBox" CssClass="EroorStar" ForeColor="Red" ValidationGroup="1">*</asp:RequiredFieldValidator>
                            <asp:Label ID="ReferralIDLabel" runat="server" ForeColor="#FF3300"></asp:Label>
                        </label>
                        <asp:TextBox ID="ReferralIDTextBox" autocomplete="off" runat="server" CssClass="form-control"></asp:TextBox>
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
                        <th class="text-center"><strong>Delete</strong></th>
                    </tr>
                </thead>
                <tbody id="tBody"></tbody>
            </table>

            <asp:HiddenField ID="GTpriceHF" runat="server" />
            <asp:HiddenField ID="GTpointHF" runat="server" />
        </div>

        <div id="addCustomer" class="mt-3">
            <asp:Button ID="Add_Customer_Button" runat="server" CssClass="btn btn-primary btn-lg" Text="Submit" ValidationGroup="1" OnClick="Add_Customer_Button_Click" />
            <asp:Label ID="ErrorLabel" runat="server" CssClass="EroorStar"></asp:Label>
            <asp:ValidationSummary CssClass="EroorSummer" ID="ValidationSummary1" runat="server" ValidationGroup="1" DisplayMode="List" />
            <asp:HiddenField ID="JsonData" runat="server" />
        </div>
    </div>



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
            <asp:ControlParameter ControlID="ApplicantPhotoHF" Name="Image" PropertyName="Value" />
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
            <asp:ControlParameter ControlID="GTpriceHF" Name="ShoppingAmount" PropertyName="Value" />
            <asp:ControlParameter ControlID="GTpointHF" Name="ShoppingPoint" PropertyName="Value" />
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


    <script>
        (function () {
            //**** REFERENCE INFO ****
            resetReferenceInfo();

            const inputReferenceId = document.getElementById("body_ReferralIDTextBox");

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
                resetReferenceInfo();
            });

            //append find user info
            function appendReferenceInfo(item) {
                const memberId = document.getElementById("body_HiddenReferralMemberId");
                memberId.value = item.MemberID;

                const infoContainer = document.getElementById("show-reference-info");
                infoContainer.innerHTML = `<span class="badge badge-dark mr-2">${item.Name}</span><span class="badge badge-dark">${item.Phone}</span>`
            }

            //reset reference info 
            function resetReferenceInfo() {
                document.getElementById("body_HiddenReferralMemberId").value = "";
                document.getElementById("show-reference-info").innerHTML = "";
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

                //convert file to base64
                fileToBase64(e.target.files[0]);
            });

            //Convert File to base64
            function fileToBase64(file) {
                const reader = new FileReader();
                reader.onload = (function (theFile) {
                    return function (e) {
                        document.getElementById('body_ApplicantPhotoHF').value = window.btoa(e.target.result);
                    };
                })(file);
                reader.readAsBinaryString(file);
            }


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
                tr.setAttribute("data-id", item.ProductID);
                tr.innerHTML = `
                    <td><strong>${item.Name}</strong></td>
                    <td>৳${item.Price}</td>
                    <td><input id="${item.ProductID}" data-stock="${item.Stock}" data-price="${item.Price}" type="number" value="${item.Quantity}" class="form-control inputQuantity"></td>
                    <td>৳<span class="total-price">${item.TotalPrice}</span></td>
                    <td class="text-center"><i data-id="${item.ProductID}" class="remove fas fa-trash"></i></td>`
                return tr;
            }

            //append product info
            function rebuildProductTable() {
                tBody.innerHTML = "";
                const store = localStorage.getItem("added-product");
                if (!store) return;

                cart = JSON.parse(store);

                cart.forEach(item => {
                    tBody.appendChild(createRow(item));
                })
            }

            //on update quantity
            tBody.addEventListener("input", function (evt) {
                const element = evt.target;

                const onQuantity = element.classList.contains("inputQuantity");
                const onRemove = element.classList.contains("remove");

                const id = element.parentElement.parentElement.getAttribute("data-id");

                if (onQuantity) {
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
                        if (item.ProductId === id) {
                            cart[i].Quantity = inputQuantity;
                            cart[i].TotalPrice = totalPrice;
                        }
                    });

                    setTotalPrice.textContent = totalPrice;
                    saveCart();
                }

                if (onRemove) { }
            });

            //call function
            rebuildProductTable();
        })();
    </script>
</asp:Content>
