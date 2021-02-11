<%@ Page Title="" Language="C#" MasterPageFile="~/Seller.Master" AutoEventWireup="true" CodeBehind="Receipt_Distributor.aspx.cs" Inherits="CncAgro.AccessSeller.Receipt_Distributor" %>

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
                            <li>
                                <h4><%# Eval("Shop_Name") %></h4>
                            </li>
                            <li>Invoice: <strong>#<%# Eval("DistributorShopping_SN") %></strong></li>
                            <li>Date: <strong><%# Eval("ShoppingDate","{0:d MMM yyyy}") %></strong></li>
                        </ul>
                    </div>

                    <div class="pull-right Customer_Info">
                        <ul>
                            <li><strong><i class="fa fa-user"></i>
                                <%# Eval("Buyer_Name") %></strong></li>
                            <li><strong><i class="fa fa-id-badge"></i>
                                <%# Eval("UserName") %></strong></li>
                            <li><strong><i class="fa fa-phone-square"></i>
                                <%# Eval("Phone") %></strong></li>
                        </ul>
                    </div>
                </div>

                <asp:GridView ID="ReceiptGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="ReceiptSQL" ShowFooter="True">
                    <Columns>
                        <asp:BoundField DataField="Product_Code" HeaderText="Code" />
                        <asp:BoundField DataField="Product_Name" HeaderText="P.Name" />
                        <asp:BoundField DataField="SellingQuantity" HeaderText="Quantity" />
                        <asp:BoundField DataField="SellingUnitPrice" HeaderText="Unit Price" />
                        <asp:BoundField DataField="SellingUnitPoint" HeaderText="Unit Point" />
                        <asp:BoundField DataField="SellingUnit_Commission" HeaderText="Unit Comm." />
                        <asp:TemplateField HeaderText="Total Price" SortExpression="ProductPrice">
                            <FooterTemplate>
                                <label id="Amount_GrandTotal"></label>
                            </FooterTemplate>
                            <ItemTemplate>
                                <asp:Label ID="TotalPriceLabel" runat="server" Text='<%# Bind("ProductPrice") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Total Point" SortExpression="TotalPoint">
                            <FooterTemplate>
                                <label id="Point_GrandTotal"></label>
                            </FooterTemplate>
                            <ItemTemplate>
                                <asp:Label ID="TotalPointLabel" runat="server" Text='<%# Bind("TotalPoint") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Total Comm.">
                            <FooterTemplate>
                                <label id="Comm_GrandTotal"></label>
                            </FooterTemplate>
                            <ItemTemplate>
                                <asp:Label ID="TotalCommisLabel" runat="server" Text='<%# Bind("Total_Commission") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <FooterStyle CssClass="GridFooter" />
                </asp:GridView>
                <asp:SqlDataSource ID="ReceiptSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_Point_Code.Product_Code, Product_Point_Code.Product_Name, Shopping_Distributor_Record.SellingQuantity, Shopping_Distributor_Record.SellingUnitPrice, Shopping_Distributor_Record.SellingUnitPoint, Shopping_Distributor_Record.ProductPrice, Shopping_Distributor_Record.TotalPoint, Shopping_Distributor_Record.SellingUnit_Commission, Shopping_Distributor_Record.Total_Commission FROM Shopping_Distributor_Record INNER JOIN Product_Point_Code ON Shopping_Distributor_Record.ProductID = Product_Point_Code.Product_PointID WHERE (Shopping_Distributor_Record.DistributorShoppingID = @DistributorShoppingID)">
                    <SelectParameters>
                        <asp:QueryStringParameter Name="DistributorShoppingID" QueryStringField="DistributorShoppingID" />
                    </SelectParameters>
                </asp:SqlDataSource>

                <div class="Paid_Stamp">
                    <img src="../CSS/Image/Paid_Sill.jpg" />
                    <p>Served By: <%# Eval("Seller_Name") %></p>
                </div>
            </ItemTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="MemberInfoSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Shopping_Distributor.DistributorShoppingID, Shopping_Distributor.DistributorShopping_SN, Seller_R.Name AS Seller_Name, Seller.Shop_Name, Buyer_R.Name AS Buyer_Name, Buyer_R.UserName, Buyer_R.Phone,Shopping_Distributor.ShoppingDate FROM Shopping_Distributor INNER JOIN Seller ON Shopping_Distributor.SellerID = Seller.SellerID INNER JOIN Registration AS Seller_R ON Seller.SellerRegistrationID = Seller_R.RegistrationID INNER JOIN Seller AS Buyer ON Shopping_Distributor.BuyingSellerID = Buyer.SellerID INNER JOIN Registration AS Buyer_R ON Buyer.SellerRegistrationID = Buyer_R.RegistrationID WHERE (Shopping_Distributor.DistributorShoppingID = @DistributorShoppingID)">
            <SelectParameters>
                <asp:QueryStringParameter Name="DistributorShoppingID" QueryStringField="DistributorShoppingID" />
            </SelectParameters>
        </asp:SqlDataSource>
        <a class="btn btn-primary hidden-print" href="Sell_Product_Distributor.aspx"><i class="fa fa-caret-left"></i> Sell Again</a>
        <button type="button" class="btn btn-primary hidden-print" onclick="window.print();"><span class="glyphicon glyphicon-print"></span>Print</button>
    </div>

    <script>
        $(document).ready(function () {
            var Amount_Total = 0;
            $("[id*=TotalPriceLabel]").each(function () { Amount_Total = Amount_Total + parseFloat($(this).text())});
            $("#Amount_GrandTotal").text("Total: " + Amount_Total.toFixed(2)+" Tk");


            var Point_Total = 0;
            $("[id*=TotalPointLabel]").each(function () { Point_Total = Point_Total + parseFloat($(this).text())});
            $("#Point_GrandTotal").text("Total: " + Point_Total);

            var Comm_Total = 0;
            $("[id*=TotalCommisLabel]").each(function () { Comm_Total = Comm_Total + parseFloat($(this).text()) });
            $("#Comm_GrandTotal").text("Total: " + Comm_Total.toFixed(2) + " Tk");
        });
    </script>
</asp:Content>
