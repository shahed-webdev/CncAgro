<%@ Page Title="Receipt" Language="C#" MasterPageFile="~/Seller.Master" AutoEventWireup="true" CodeBehind="Receipt.aspx.cs" Inherits="CncAgro.AccessSeller.Receipt" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Receipt.css?v=2" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="Contain">
        <asp:FormView ID="MemberFormView" runat="server" DataSourceID="MemberInfoSQL" Width="100%">
            <ItemTemplate>
                <div class="clearfix">
                    <div class="pull-left MReceipt">
                        <ul>
                            <li><h4><%# Eval("Shop_Name") %></h4></li>
                            <li>Invoice: <strong>#<%# Eval("Shopping_SN") %></strong></li>
                            <li>Date: <strong><%# Eval("ShoppingDate","{0:d MMM yyyy}") %></strong></li>
                        </ul>
                    </div>

                    <div class="pull-right Customer_Info">
                        <ul>
                            <li><strong><i class="fa fa-user"></i>
                                <%# Eval("Name") %></strong></li>
                            <li><strong><i class="fa fa-id-badge"></i>
                                <%# Eval("UserName") %></strong></li>
                            <li><strong><i class="fa fa-phone-square"></i>
                                <%# Eval("Phone") %></strong></li>
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
                    <img src="../CSS/Image/Paid_Sill.jpg" />
                    <p>Served By: <%# Eval("Seller_Name") %></p>
                </div>
            </ItemTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="MemberInfoSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Shopping.ShoppingAmount, Shopping.ShoppingPoint, Shopping.ShoppingDate, Registration.Name, Registration.UserName, Registration.Phone, Registration_1.Name AS Seller_Name, Shopping.Shopping_SN, Seller.Shop_Name FROM Shopping INNER JOIN Member ON Shopping.MemberID = Member.MemberID INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID INNER JOIN Seller ON Shopping.SellerID = Seller.SellerID INNER JOIN Registration AS Registration_1 ON Seller.SellerRegistrationID = Registration_1.RegistrationID WHERE (Shopping.ShoppingID = @ShoppingID)">
            <SelectParameters>
                <asp:QueryStringParameter Name="ShoppingID" QueryStringField="ShoppingID" />
            </SelectParameters>
        </asp:SqlDataSource>
        <a class="btn btn-primary hidden-print" href="Sell_Product.aspx"><i class="fa fa-caret-left"></i> Sell Again</a>
        <button type="button" class="btn btn-primary hidden-print" onclick="window.print();"><span class="glyphicon glyphicon-print"></span> Print</button>
    </div>

    <script>
        $(document).ready(function () {
            var Amount_Total = 0;
            $("[id*=TotalPriceLabel]").each(function () { Amount_Total = Amount_Total + parseFloat($(this).text()) });
            $("#Amount_GrandTotal").text("Total: " + Amount_Total.toFixed(2));


            var Point_Total = 0;
            $("[id*=TotalPointLabel]").each(function () { Point_Total = Point_Total + parseFloat($(this).text()) });
            $("#Point_GrandTotal").text("Total: " + Point_Total);

        });
    </script>
</asp:Content>
