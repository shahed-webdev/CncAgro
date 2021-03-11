<%@ Page Title="Invoice" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Distribution_Receipt.aspx.cs" Inherits="CncAgro.AccessAdmin.Member.ProductDistribution.Distribution_Receipt" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        #Net { border-top: 1px solid #333; font-weight: bold; padding-top: 5px; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <a class="Sub_Link hidden-print" href="Product_Distribution.aspx"><< Back</a>
    <h3>Invoice</h3>

    <asp:FormView ID="MemberFormView" runat="server" DataSourceID="MemberInfoSQL" Width="100%">
        <ItemTemplate>
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h4>Id: <%# Eval("Member_Username") %></h4>
                    <p><%# Eval("Member_Phone") %></p>
                </div>
                <div class="text-right">
                    <h4>Receipt# <%#Eval("Distribution_SN") %></h4>
                    <p>Date: <%#Eval("Confirm_Date","{0:d MMM yyyy}") %></p>
                </div>
            </div>

            <asp:GridView ID="ReceiptGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="ReceiptSQL">
                <Columns>
                    <asp:BoundField DataField="Product_Code" HeaderText="Code" SortExpression="Product_Code" />
                    <asp:BoundField DataField="Product_Name" HeaderText="P.Name" SortExpression="Product_Name">
                        <ItemStyle HorizontalAlign="Left" />
                    </asp:BoundField>
                    <asp:BoundField DataField="SellingQuantity" HeaderText="Quantity" SortExpression="SellingQuantity" />
                    <asp:BoundField DataField="SellingUnitPrice" HeaderText="Unit Price" SortExpression="SellingUnitPrice" />
                    <asp:TemplateField HeaderText="Total Price" SortExpression="ProductPrice">
                        <ItemTemplate>
                            <asp:Label ID="TotalPriceLabel" runat="server" Text='<%# Bind("ProductPrice","{0:N}") %>'></asp:Label>
                            <input class="TotalPrice" type="hidden" value="<%# Eval("ProductPrice") %>" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <FooterStyle CssClass="GridFooter" />
            </asp:GridView>
            <asp:SqlDataSource ID="ReceiptSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>"
                SelectCommand="SELECT Product_Point_Code.Product_Code, Product_Point_Code.Product_Name, Product_Distribution_Records.SellingQuantity, Product_Distribution_Records.SellingUnitPrice, Product_Distribution_Records.SellingUnitPoint, Product_Distribution_Records.ProductPrice, Product_Distribution_Records.TotalPoint FROM Product_Point_Code INNER JOIN Product_Distribution_Records ON Product_Point_Code.Product_PointID = Product_Distribution_Records.ProductID WHERE (Product_Distribution_Records.Product_DistributionID = @Product_DistributionID)">
                <SelectParameters>
                    <asp:QueryStringParameter Name="Product_DistributionID" QueryStringField="Distribution" />
                </SelectParameters>
            </asp:SqlDataSource>

            <div class="text-right">
                <h5 id="Amount_GrandTotal"></h5>
                <h5 id="Net"></h5>
                <small>Served By:<%# Eval("Admin_Name") %></small>
            </div>
        </ItemTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="MemberInfoSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.Name AS Admin_Name, Registration.UserName AS Admin_Username, Member_Registration.UserName AS Member_Username, Member_Registration.Phone AS Member_Phone, Product_Distribution.Product_DistributionID, Product_Distribution.Distribution_SN, Member_Registration.Name, Registration.RegistrationID, Product_Distribution.Product_Total_Amount, Product_Distribution.Is_Confirmed, Product_Distribution.Is_Delivered, Product_Distribution.Delivery_Date, Product_Distribution.Confirm_Date, Product_Distribution.InsertDate FROM Registration AS Member_Registration INNER JOIN Member ON Member_Registration.RegistrationID = Member.MemberRegistrationID INNER JOIN Product_Distribution ON Member.MemberID = Product_Distribution.MemberID LEFT OUTER JOIN Registration ON Product_Distribution.Confirmed_RegistrationID = Registration.RegistrationID WHERE (Product_Distribution.Product_DistributionID = @Product_DistributionID)">
        <SelectParameters>
            <asp:QueryStringParameter Name="Product_DistributionID" QueryStringField="Distribution" />
        </SelectParameters>
    </asp:SqlDataSource>

    <script>
        $(function () {
            var amountTotal = 0;
            $(".TotalPrice").each(function () { amountTotal = amountTotal + parseFloat($(this).val()) });
            $("#Amount_GrandTotal").text(`Total Amount: ${amountTotal.toFixed(2)} Tk`);

            $("#Net").text(`Net Amount: ${(amountTotal - Commission_Total).toFixed(2)} Tk`);
        });
    </script>
</asp:Content>
