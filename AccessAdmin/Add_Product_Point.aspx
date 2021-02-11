<%@ Page Title="Add Product" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Add_Product_Point.aspx.cs" Inherits="CncAgro.AccessAdmin.Add_Product_Point" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        #Product-info { display: none; }

        .userid { font-size: 14px; padding: 13px 5px; margin-bottom: 7px; }
            .userid .fa { padding-left: 10px; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Add Product</h3>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="well">
                <div class="form-group">
                    <label>
                        Product Name
                         <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="Product_NameTextBox" CssClass="EroorStar" ErrorMessage="*" ValidationGroup="A"></asp:RequiredFieldValidator>
                    </label>
                    <asp:TextBox ID="Product_NameTextBox" placeholder="Product Name" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>
                        Product Code
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="Product_CodeTextBox" CssClass="EroorStar" ErrorMessage="*" ValidationGroup="A"></asp:RequiredFieldValidator>
                    </label>
                    <asp:TextBox ID="Product_CodeTextBox" placeholder="Product Code" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Point<asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="Product_PointTextBox" CssClass="EroorStar" ErrorMessage="*" ValidationGroup="A"></asp:RequiredFieldValidator></label>
                    <asp:TextBox ID="Product_PointTextBox" placeholder="Product Point" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Price<asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="Product_PriceTextBox" CssClass="EroorStar" ErrorMessage="*" ValidationGroup="A"></asp:RequiredFieldValidator></label>
                    <asp:TextBox ID="Product_PriceTextBox" placeholder="Price" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>
                        Stock Quantity
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="QuantityTextBox" CssClass="EroorStar" ErrorMessage="*" ValidationGroup="A"></asp:RequiredFieldValidator></label>
                    <asp:TextBox ID="QuantityTextBox" placeholder="Stock Quantity" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="form-group">
                    <asp:Button ID="Add_Product_Button" runat="server" CssClass="btn btn-primary" Text="Add New Product" OnClick="Add_Product_Button_Click" ValidationGroup="A" />
                    <button type="button" class="btn btn-danger" data-toggle="modal" data-target="#myModal">Update Product Stock</button>
                </div>
            </div>

            <div class="table-responsive">
                <div class="form-inline">
                    <div class="form-group">
                        <asp:TextBox ID="FindTextBox" placeholder="Code, Name" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <asp:Button ID="FindButton" runat="server" Text="Find" CssClass="btn btn-primary" />
                    </div>
                </div>

                <asp:GridView ID="ProductGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid table-hover" DataKeyNames="Product_PointID" DataSourceID="Product_PointSQL" AllowSorting="True">
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:CheckBox ID="SelectCheckBox" AutoPostBack="true" Checked='<%#Eval("IsActive") %>' runat="server" Text=" " OnCheckedChanged="SelectCheckBox_CheckedChanged" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Product Name" SortExpression="Product_Name">
                            <EditItemTemplate>
                                <asp:TextBox ID="U_ProductTextBox" TextMode="MultiLine" CssClass="form-control" runat="server" Text='<%# Bind("Product_Name") %>'></asp:TextBox>
                                <asp:RequiredFieldValidator ID="Rvalidator1" runat="server" ControlToValidate="U_ProductTextBox" CssClass="Error" ErrorMessage="*" SetFocusOnError="True" ValidationGroup="U"></asp:RequiredFieldValidator>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <%# Eval("Product_Name") %>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Code" SortExpression="Product_Code">
                            <EditItemTemplate>
                                <asp:TextBox ID="U_CodeTextBox" CssClass="form-control" runat="server" Text='<%# Bind("Product_Code") %>'></asp:TextBox>
                                <asp:RequiredFieldValidator ID="Rv2" runat="server" ControlToValidate="U_CodeTextBox" CssClass="Error" ErrorMessage="*" SetFocusOnError="True" ValidationGroup="U"></asp:RequiredFieldValidator>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# Bind("Product_Code") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Point" SortExpression="Product_Point">
                            <EditItemTemplate>
                                <asp:TextBox ID="TextBox2" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" runat="server" CssClass="form-control" Text='<%# Bind("Product_Point") %>'></asp:TextBox>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="Label4" runat="server" Text='<%# Bind("Product_Point") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Price" SortExpression="Product_Price">
                            <EditItemTemplate>
                                <asp:TextBox ID="TextBox3" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" runat="server" CssClass="form-control" runat="server" Text='<%# Bind("Product_Price") %>'></asp:TextBox>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="Label5" runat="server" Text='<%# Bind("Product_Price") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Quantity" SortExpression="Stock_Quantity">
                            <EditItemTemplate>
                                <asp:TextBox ID="TextBox1" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" runat="server" CssClass="form-control" Text='<%# Bind("Stock_Quantity") %>'></asp:TextBox>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="Label3" runat="server" Text='<%# Bind("Stock_Quantity") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ShowHeader="False" HeaderText="Edit">
                            <EditItemTemplate>
                                <asp:LinkButton ID="UpdateButton" ValidationGroup="U" runat="server" CausesValidation="True" CommandName="Update" Text="Update"></asp:LinkButton>
                                <asp:LinkButton ID="CancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit"></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ShowHeader="False" HeaderText="Delete">
                            <ItemTemplate>
                                <asp:LinkButton ID="DeleteButton" OnClientClick="return confirm('Are you sure want to delete?')" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete"></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        No Added Product
                    </EmptyDataTemplate>
                </asp:GridView>
                <asp:SqlDataSource ID="Product_PointSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" DeleteCommand="IF NOT EXISTS (SELECT * FROM  Seller_Product WHERE (Product_PointID = @Product_PointID))
DELETE FROM [Product_Point_Code] WHERE [Product_PointID] = @Product_PointID"
                    InsertCommand="IF NOT EXISTS (SELECT * FROM  Product_Point_Code WHERE  (Product_Code = @Product_Code))
BEGIN
INSERT INTO Product_Point_Code(Product_Name, Product_Code, Product_Point, Product_Price,Stock_Quantity) VALUES (@Product_Name, @Product_Code, @Product_Point, @Product_Price,@Stock_Quantity)
END"
                    SelectCommand="SELECT * FROM [Product_Point_Code]" UpdateCommand="IF NOT EXISTS (SELECT * FROM  Product_Point_Code WHERE  (Product_Code = @Product_Code) and  [Product_PointID] &lt;&gt; @Product_PointID)
BEGIN
UPDATE [Product_Point_Code] SET [Product_Name] = @Product_Name, [Product_Code] = @Product_Code, Product_Point = @Product_Point, Product_Price = @Product_Price, Stock_Quantity = @Stock_Quantity WHERE [Product_PointID] = @Product_PointID
END"
                    FilterExpression="Product_Code like '{0}%' OR Product_Name like '{0}%'">
                    <DeleteParameters>
                        <asp:Parameter Name="Product_PointID" Type="Int32" />
                    </DeleteParameters>
                    <FilterParameters>
                        <asp:ControlParameter ControlID="FindTextBox" Name="Find" PropertyName="Text" />
                    </FilterParameters>
                    <InsertParameters>
                        <asp:ControlParameter ControlID="Product_CodeTextBox" Name="Product_Code" PropertyName="Text" Type="String" />
                        <asp:ControlParameter ControlID="Product_NameTextBox" Name="Product_Name" PropertyName="Text" Type="String" />
                        <asp:ControlParameter ControlID="Product_PointTextBox" Name="Product_Point" PropertyName="Text" Type="Double" />
                        <asp:ControlParameter ControlID="Product_PriceTextBox" Name="Product_Price" PropertyName="Text" />
                        <asp:ControlParameter ControlID="QuantityTextBox" Name="Stock_Quantity" PropertyName="Text" />
                    </InsertParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="Product_Code" Type="String" />
                        <asp:Parameter Name="Product_PointID" Type="Int32" />
                        <asp:Parameter Name="Product_Name" Type="String" />
                        <asp:Parameter Name="Product_Point" />
                        <asp:Parameter Name="Product_Price" />
                        <asp:Parameter Name="Stock_Quantity" />
                    </UpdateParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="ShortListSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM [Product_Point_Code]" UpdateCommand="UPDATE [Product_Point_Code] SET [IsActive] = @IsActive WHERE [Product_PointID] = @Product_PointID">
                    <UpdateParameters>
                        <asp:Parameter Name="IsActive" Type="Boolean" />
                        <asp:Parameter Name="Product_PointID" Type="Int32" />
                    </UpdateParameters>
                </asp:SqlDataSource>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <!-- Modal -->
    <div id="myModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Update Stock Quantity</h4>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                        <ContentTemplate>
                            <div class="form-group">
                                <label>
                                    Product Code<asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="ProductCodeTextBox" CssClass="EroorStar" ErrorMessage="Required" ValidationGroup="ch"></asp:RequiredFieldValidator>
                                </label>
                                <asp:TextBox ID="ProductCodeTextBox" placeholder="Product Code" runat="server" CssClass="form-control" autocomplete="off"></asp:TextBox>
                            </div>

                            <div id="Product-info" class="alert-success">
                                <div class="userid">
                                    <i class="fa fa-shopping-bag" aria-hidden="true"></i>
                                    <label id="ProductCodeLabel"></label>

                                    <i class="fa fa-money" aria-hidden="true"></i>
                                    <label id="ProductPriceLabel"></label>

                                    <i class="fa fa-star" aria-hidden="true"></i>
                                    <label id="ProductPointLabel"></label>
                                </div>
                                <asp:HiddenField ID="ProductID_HF" runat="server" />
                                <asp:HiddenField ID="ProductCode_HF" runat="server" />
                            </div>

                            <div class="form-group">
                                <label>
                                    Quantity<asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="Update_Quantity_TextBox" CssClass="EroorStar" ErrorMessage="Required" ValidationGroup="ch"></asp:RequiredFieldValidator>
                                </label>
                                <asp:TextBox ID="Update_Quantity_TextBox" placeholder="Quantity" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <asp:Button ID="AddToCartButton" runat="server" CssClass="btn btn-default" Text="Add To Cart" OnClick="AddToCartButton_Click" ValidationGroup="ch" />
                            </div>

                            <div class="table-responsive">
                                <asp:GridView ID="ChargeGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid">
                                    <Columns>
                                        <asp:TemplateField Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="PIDLabel" runat="server" Text='<%# Bind("PID") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Product Code">
                                            <ItemTemplate>
                                                <asp:Label ID="ProductNameLabel" runat="server" Text='<%# Bind("ProductCode") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Quantity">
                                            <ItemTemplate>
                                                <asp:Label ID="QntLabel" runat="server" Text='<%# Bind("Quantity") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <asp:Button ID="DeleteImageButton" runat="server" CausesValidation="False" CommandName="Delete" CssClass="btn btn-default" Text="Delete" OnClick="RowDelete"></asp:Button>
                                            </ItemTemplate>
                                            <ItemStyle Width="40px" />
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                            <br />
                            <% if (ChargeGridView.Rows.Count > 0)
                                {%>
                            <asp:Button ID="Add_Stock_Button" runat="server" Text="Add Stock" CssClass="btn btn-primary" OnClick="Add_Stock_Button_Click" />
                            <asp:SqlDataSource ID="Product_Stock_RecordSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO [Product_Stock_Record] ([Admin_RegistrationID], [Product_PointID], [Added_Quantity]) VALUES (@Admin_RegistrationID, @Product_PointID, @Added_Quantity)" SelectCommand="SELECT * FROM [Product_Stock_Record]" UpdateCommand="UPDATE Product_Point_Code SET Stock_Quantity += @Stock_Quantity WHERE  (Product_PointID = @Product_PointID)">
                                <InsertParameters>
                                    <asp:SessionParameter Name="Admin_RegistrationID" SessionField="RegistrationID" Type="Int32" />
                                    <asp:Parameter Name="Product_PointID" Type="Int32" />
                                    <asp:Parameter Name="Added_Quantity" Type="Int32" />
                                </InsertParameters>
                                <UpdateParameters>
                                    <asp:Parameter Name="Stock_Quantity" />
                                    <asp:Parameter Name="Product_PointID" />
                                </UpdateParameters>
                            </asp:SqlDataSource>
                            <%} %>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>

    <asp:UpdateProgress ID="UpdateProgress" runat="server">
        <ProgressTemplate>
            <div id="progress_BG"></div>
            <div id="progress">
                <img src="/CSS/Image/loading.gif" alt="Loading..." />
                <br />
                <b>Loading...</b>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>

    <script>
        function isNumberKey(a) { a = a.which ? a.which : event.keyCode; return 46 != a && 31 < a && (48 > a || 57 < a) ? !1 : !0 };

        $(function () {
            //Get Product info
            $('[id*=ProductCodeTextBox]').typeahead({
                minLength: 1,
                source: function (request, result) {
                    $.ajax({
                        url: "Add_Product_Point.aspx/GetProduct",
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
                    $("#ProductCodeLabel").text(map[item].Code);
                    $("#ProductPriceLabel").text("Price: " + map[item].Price);
                    $("#ProductPointLabel").text("Point: " + map[item].Point);

                    $("[id$=ProductID_HF]").val(map[item].ProductID);
                    $("[id$=ProductCode_HF]").val(map[item].Code);
                    return item;
                }
            });

            $('input[type=checkbox]').each(function () {
                $(this).is(":checked") ? ($("td", $(this).closest("tr")).addClass("selected")) : ($("td", $(this).closest("tr")).removeClass("selected"));
            });
        });

        //Update panel
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (a, b) {
            //Get Product info
            $('[id*=ProductCodeTextBox]').typeahead({
                minLength: 1,
                source: function (request, result) {
                    $.ajax({
                        url: "Add_Product_Point.aspx/GetProduct",
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
                    $("#ProductCodeLabel").text(map[item].Code);
                    $("#ProductPriceLabel").text("Price: " + map[item].Price);
                    $("#ProductPointLabel").text("Point: " + map[item].Point);

                    $("[id$=ProductID_HF]").val(map[item].ProductID);
                    $("[id$=ProductCode_HF]").val(map[item].Code);
                    return item;
                }
            });

            $('input[type=checkbox]').each(function () {
                $(this).is(":checked") ? ($("td", $(this).closest("tr")).addClass("selected")) : ($("td", $(this).closest("tr")).removeClass("selected"));
            });
        });
    </script>
</asp:Content>
