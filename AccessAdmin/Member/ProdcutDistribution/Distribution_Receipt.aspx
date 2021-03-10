<%@ Page Title="Invoice" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Distribution_Receipt.aspx.cs" Inherits="CncAgro.AccessAdmin.Member.ProductDistribution.Distribution_Receipt" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .B_Info { width: 100%;}
        .B_Info td { font-size: 16px; color: #000; font-weight: bold; }
        h5 { font-size:16px;}
        #Net { border-top: 1px solid #333; font-weight: bold; padding-top: 5px; }

        @page { margin: 5mm 8mm; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <a class="Sub_Link hidden-print" href="Product_Distribution.aspx"><< Back</a>
<h3>Invoice</h3>

    <asp:FormView ID="MemberFormView" runat="server" DataSourceID="SellerInfoSQL" Width="100%">
        <ItemTemplate>
          <table class="B_Info">
                <tr>
                    <td>Distributor ID: <%# Eval("Seller_Username") %></td>
                    <td class="text-right">Phone: <%# Eval("Seller_Phone") %></td>
                </tr>
                <tr>
                    <td>Receipts# <%#Eval("Distribution_SN") %></td>
                    <td class="text-right">Date: <%#Eval("Product_Distribution_Date","{0:d MMM yyyy}") %></td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td></td>
                </tr>
            </table>

            <asp:GridView ID="ReceiptGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="ReceiptSQL">
                <Columns>
                    <asp:BoundField DataField="Product_Code" HeaderText="Code" SortExpression="Product_Code" />
                    <asp:BoundField DataField="Product_Name" HeaderText="P.Name" SortExpression="Product_Name">
                        <ItemStyle HorizontalAlign="Left" />
                    </asp:BoundField>
                    <asp:BoundField DataField="SellingQuantity" HeaderText="Quantity" SortExpression="SellingQuantity" />
                    <asp:BoundField DataField="SellingUnitPrice" HeaderText="Unit Price" SortExpression="SellingUnitPrice" />
                    <asp:BoundField DataField="SellingUnitPoint" HeaderText="Unit Point" SortExpression="SellingUnitPoint" />
                    <asp:BoundField DataField="SellingUnit_Commission" HeaderText="Unit Comm." SortExpression="SellingUnit_Commission" />
                    <asp:TemplateField HeaderText="Total Price" SortExpression="ProductPrice">
                        <ItemTemplate>
                            <asp:Label ID="TotalPriceLabel" runat="server" Text='<%# Bind("ProductPrice","{0:N}") %>'></asp:Label>
                            <input class="TotalPrice" type="hidden" value="<%# Eval("ProductPrice") %>" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Total Point" SortExpression="TotalPoint">
                        <ItemTemplate>
                            <asp:Label ID="TotalPointLabel" runat="server" Text='<%# Bind("TotalPoint") %>'></asp:Label>
                            <input class="TotalPoint" type="hidden" value="<%# Eval("TotalPoint") %>" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Total Comm." SortExpression="Total_Commission">
                        <ItemTemplate>
                            <asp:Label ID="Total_CommissionLabel" runat="server" Text='<%# Bind("Total_Commission","{0:N}") %>'></asp:Label>
                            <input class="Total_Commission" type="hidden" value="<%# Eval("Total_Commission") %>" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <FooterStyle CssClass="GridFooter" />
            </asp:GridView>
            <asp:SqlDataSource ID="ReceiptSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>"
                SelectCommand="SELECT Product_Point_Code.Product_Code, Product_Point_Code.Product_Name, Product_Distribution_Records.SellingQuantity, Product_Distribution_Records.SellingUnitPrice, Product_Distribution_Records.SellingUnitPoint,Product_Distribution_Records.SellingUnit_Commission, Product_Distribution_Records.ProductPrice, Product_Distribution_Records.TotalPoint, Product_Distribution_Records.Total_Commission FROM Product_Point_Code INNER JOIN Product_Distribution_Records ON Product_Point_Code.Product_PointID = Product_Distribution_Records.ProductID WHERE (Product_Distribution_Records.Product_DistributionID = @Product_DistributionID)">
                <SelectParameters>
                    <asp:QueryStringParameter Name="Product_DistributionID" QueryStringField="Distribution" />
                </SelectParameters>
            </asp:SqlDataSource>

            <table style="width: 100%">
                <tr>
                    <td class="text-right">
                        <h5 id="Point_GrandTotal"></h5>
                        <h5 id="Amount_GrandTotal"></h5>
                        <h5 id="Commission_GrandTotal"></h5>
                        <h5 id="Net"></h5>
                    </td>
                </tr>
                <tr>
                    <td>Served By:
                  <asp:Label ID="Admin_Name_NameLabel" runat="server" Text='<%# Bind("Admin_Name") %>' />
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
            </table>
        </ItemTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="SellerInfoSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.Name AS Admin_Name, Registration.UserName AS Admin_Username, Seller_Registration.UserName AS Seller_Username, Seller_Registration.Phone AS Seller_Phone, Product_Distribution.Product_Distribution_Date, Product_Distribution.Product_DistributionID, Product_Distribution.Distribution_SN FROM Registration AS Seller_Registration INNER JOIN Seller ON Seller_Registration.RegistrationID = Seller.SellerRegistrationID INNER JOIN Product_Distribution ON Seller.SellerID = Product_Distribution.SellerID LEFT OUTER JOIN Registration ON Product_Distribution.Admin_RegistrationID = Registration.RegistrationID WHERE (Product_Distribution.Product_DistributionID = @Product_DistributionID)">
        <SelectParameters>
            <asp:QueryStringParameter Name="Product_DistributionID" QueryStringField="Distribution" />
        </SelectParameters>
    </asp:SqlDataSource>

    <button type="button" class="btn btn-primary hidden-print" onclick="window.print();"><span class="glyphicon glyphicon-print"></span> Print</button>

    <script>
        $(document).ready(function () {
            var Amount_Total = 0;
            $(".TotalPrice").each(function () { Amount_Total = Amount_Total + parseFloat($(this).val()) });
            $("#Amount_GrandTotal").text("Total Amount: " + Amount_Total.toFixed(2) + " Tk");

            var Point_Total = 0;
            $(".TotalPoint").each(function () { Point_Total = Point_Total + parseFloat($(this).val()) });
            $("#Point_GrandTotal").text("Total Point: " + Point_Total);

            var Commission_Total = 0;
            $(".Total_Commission").each(function () { Commission_Total = Commission_Total + parseFloat($(this).val()) });
            $("#Commission_GrandTotal").text("Total Commission: " + Commission_Total.toFixed(2) + " Tk");

            $("#Net").text("Net Amount: " + (Amount_Total - Commission_Total).toFixed(2) + " Tk");
        });
    </script>
</asp:Content>
