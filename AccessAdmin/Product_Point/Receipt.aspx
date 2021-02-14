<%@ Page Title="" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Receipt.aspx.cs" Inherits="CncAgro.AccessAdmin.Product_Point.Receipt" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../CSS/Receipt.css?v=1" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="contain">
        <asp:FormView ID="MemberFormView" runat="server" DataSourceID="MemberInfoSQL" Width="100%">
            <ItemTemplate>
                <div class="row mb-3">
                    <div class="col-6">
                        <ul>
                            <li>Invoice: <strong>#<%# Eval("Shopping_SN") %></strong></li>
                            <li>Date: <strong><%# Eval("ShoppingDate","{0:d MMM yyyy}") %></strong></li>
                        </ul>
                    </div>

                    <div class="col-6 text-right">
                        <ul>
                            <li>
                                <strong><i class="fa fa-user"></i>
                                    <%# Eval("Name") %></strong>
                            </li>
                            <li>
                                <strong><i class="fa fa-id-badge"></i>
                                    <%# Eval("UserName") %></strong>
                            </li>
                        </ul>
                    </div>
                </div>

                <asp:GridView ID="ReceiptGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="ReceiptSQL" ShowFooter="True">
                    <Columns>
                        <asp:BoundField DataField="Product_Code" HeaderText="Code" SortExpression="Product_Code" />
                        <asp:BoundField DataField="Product_Name" HeaderText="P.Name" SortExpression="Product_Name" />
                        <asp:BoundField DataField="SellingQuantity" HeaderText="Quantity" SortExpression="SellingQuantity">
                            <ItemStyle Width="100px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="SellingUnitPrice" HeaderText="Unit Price" SortExpression="SellingUnitPrice">
                            <ItemStyle Width="100px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="SellingUnitPoint" HeaderText="Unit Point" SortExpression="SellingUnitPoint">
                            <ItemStyle Width="100px" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Total Price" SortExpression="ProductPrice">
                            <FooterTemplate>
                                <label id="Amount_GrandTotal"></label>
                                Tk
                            </FooterTemplate>
                            <ItemTemplate>
                                <asp:Label ID="TotalPriceLabel" runat="server" Text='<%# Bind("ProductPrice") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle Width="130px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Total Point" SortExpression="TotalPoint">
                            <FooterTemplate>
                                <label id="Point_GrandTotal"></label>
                            </FooterTemplate>
                            <ItemTemplate>
                                <asp:Label ID="TotalPointLabel" runat="server" Text='<%# Bind("TotalPoint") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle Width="130px" />
                        </asp:TemplateField>
                    </Columns>
                    <FooterStyle CssClass="GridFooter" />
                </asp:GridView>
                <asp:SqlDataSource ID="ReceiptSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_Point_Code.Product_Code, Product_Point_Code.Product_Name, Product_Selling_Records.SellingQuantity, Product_Selling_Records.SellingUnitPrice, Product_Selling_Records.SellingUnitPoint, Product_Selling_Records.ProductPrice, Product_Selling_Records.TotalPoint FROM Product_Selling_Records INNER JOIN Product_Point_Code ON Product_Selling_Records.ProductID = Product_Point_Code.Product_PointID WHERE (Product_Selling_Records.ShoppingID = @ShoppingID)">
                    <SelectParameters>
                        <asp:QueryStringParameter Name="ShoppingID" QueryStringField="ShoppingID" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>

                <div class="Paid_Stamp">
                    <p>Served By: <%# Eval("Seller_Name") %></p>
                </div>
            </ItemTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="MemberInfoSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Shopping.ShoppingAmount, Shopping.ShoppingPoint, Shopping.ShoppingDate, Registration.Name, Registration.UserName, Registration.Phone, Registration_1.Name AS Seller_Name, Shopping.Shopping_SN FROM Shopping INNER JOIN Member ON Shopping.MemberID = Member.MemberID INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID INNER JOIN Registration AS Registration_1 ON Shopping.Seller_RegistrationID = Registration_1.RegistrationID WHERE (Shopping.ShoppingID = @ShoppingID)">
            <SelectParameters>
                <asp:QueryStringParameter Name="ShoppingID" QueryStringField="ShoppingID" />
            </SelectParameters>
        </asp:SqlDataSource>
        <a class="btn btn-primary hidden-print" href="Sell_Product.aspx"><i class="fa fa-caret-left mr-1"></i>Sell Again</a>
        <button type="button" class="btn btn-primary hidden-print" onclick="window.print();"><span class="glyphicon glyphicon-print"></span>Print</button>
    </div>

    <script>
        $(function () {
            var amountTotal = 0;
            $("[id*=TotalPriceLabel]").each(function () { amountTotal = amountTotal + parseFloat($(this).text()) });
            $("#Amount_GrandTotal").text(`Total: ${amountTotal.toFixed(2)}`);


            var pointTotal = 0;
            $("[id*=TotalPointLabel]").each(function () { pointTotal = pointTotal + parseFloat($(this).text()) });
            $("#Point_GrandTotal").text(`Total: ${pointTotal}`);
        });
    </script>
</asp:Content>
