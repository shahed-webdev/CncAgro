<%@ Page Title="Receipt" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Receipt.aspx.cs" Inherits="CncAgro.AccessMember.Selling.Receipt" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <asp:FormView ID="MemberFormView" runat="server" DataSourceID="MemberInfoSQL" Width="100%">
        <ItemTemplate>
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h5>Invoice: <strong>#<%# Eval("Shopping_SN") %></strong></h5>
                    <p>Date: <strong><%# Eval("ShoppingDate","{0:d MMM yyyy}") %></strong></p>
                </div>
                <div class="text-right">
                    <h5>
                        <strong><i class="fa fa-user"></i>
                            <%# Eval("Name") %></strong>
                    </h5>
                    <p>
                        <strong><i class="fa fa-id-badge"></i>
                            <%# Eval("UserName") %></strong>
                    </p>
                </div>
            </div>

            <asp:GridView ID="ReceiptGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="ReceiptSQL" ShowFooter="True">
                <Columns>
                    <asp:BoundField DataField="Product_Code" HeaderText="Code" SortExpression="Product_Code" />
                    <asp:BoundField DataField="Product_Name" HeaderText="P.Name" SortExpression="Product_Name" />
                    <asp:BoundField DataField="SellingQuantity" HeaderText="Quantity" SortExpression="SellingQuantity" />
                    <asp:BoundField DataField="SellingUnitPrice" HeaderText="Unit Price" SortExpression="SellingUnitPrice"></asp:BoundField>
                    <asp:TemplateField HeaderText="Total Price" SortExpression="ProductPrice">
                        <ItemTemplate>
                            <asp:Label ID="TotalPriceLabel" runat="server" Text='<%# Bind("ProductPrice") %>'></asp:Label>
                        </ItemTemplate>
                        <FooterTemplate>
                            <strong id="Amount_GrandTotal"></strong>
                        </FooterTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="ReceiptSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_Point_Code.Product_Code, Product_Point_Code.Product_Name, Product_Selling_Records.SellingQuantity, Product_Selling_Records.SellingUnitPrice, Product_Selling_Records.SellingUnitPoint, Product_Selling_Records.ProductPrice, Product_Selling_Records.TotalPoint FROM Product_Selling_Records INNER JOIN Product_Point_Code ON Product_Selling_Records.ProductID = Product_Point_Code.Product_PointID WHERE (Product_Selling_Records.ShoppingID = @ShoppingID)">
                <SelectParameters>
                    <asp:QueryStringParameter Name="ShoppingID" QueryStringField="ShoppingID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

            <p>Served By: <%# Eval("ServedBy") %></p>
        </ItemTemplate>
    </asp:FormView>

    <asp:SqlDataSource ID="MemberInfoSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Shopping.ShoppingAmount, Shopping.ShoppingPoint, Shopping.ShoppingDate, Registration.Name, Registration.UserName, Registration.Phone, Shopping.Shopping_SN, Shopping.Is_Delivered, Registration_1.Name AS ServedBy FROM Shopping INNER JOIN Member ON Shopping.MemberID = Member.MemberID INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID INNER JOIN Registration AS Registration_1 ON Shopping.Seller_RegistrationID = Registration_1.RegistrationID WHERE (Shopping.ShoppingID = @ShoppingID)">
        <SelectParameters>
            <asp:QueryStringParameter Name="ShoppingID" QueryStringField="ShoppingID" />
        </SelectParameters>
    </asp:SqlDataSource>

    <script>
        $(function () {
            var amountTotal = 0;
            $("[id*=TotalPriceLabel]").each(function () { amountTotal = amountTotal + parseFloat($(this).text()) });
            $("#Amount_GrandTotal").text(`Total: ${amountTotal.toFixed(2)}`);
        });
    </script>
</asp:Content>
