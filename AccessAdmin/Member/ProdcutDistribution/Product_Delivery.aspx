<%@ Page Title="Order Delivery" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Product_Delivery.aspx.cs" Inherits="CncAgro.AccessAdmin.Member.ProductDistribution.Product_Delivery" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Order Delivery</h3>

    <div class="table-responsive">
        <asp:GridView ID="OrderGridView" runat="server" AllowSorting="True" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="DeliverySQL" DataKeyNames="Product_DistributionID,SellerID">
            <Columns>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:CheckBox ID="AllCheckBox" runat="server" Text="All" />
                    </HeaderTemplate>
                    <ItemTemplate>
                        <asp:CheckBox ID="ConfirmCheckBox" runat="server" Text=" " />
                    </ItemTemplate>
                    <ItemStyle Width="50px" />
                </asp:TemplateField>
                <asp:HyperLinkField SortExpression="Distribution_SN" DataTextField="Distribution_SN" DataNavigateUrlFields="Product_DistributionID" DataNavigateUrlFormatString="Delivery_Details.aspx?DistributionID={0}" HeaderText="Receipt No." />
                <asp:BoundField DataField="UserName" HeaderText="User Name" SortExpression="UserName" />
                <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                <asp:BoundField DataField="Product_Total_Amount" DataFormatString="{0:N}" HeaderText="Total Price" SortExpression="Product_Total_Amount" />
                <asp:BoundField DataField="Product_Total_Point" DataFormatString="{0:N}" HeaderText="Total Point" SortExpression="Product_Total_Point" />
                <asp:BoundField DataField="Commission_Amount" DataFormatString="{0:N}" HeaderText="Total Commi." SortExpression="Commission_Amount" />
                <asp:BoundField DataField="Net_Amount" DataFormatString="{0:N}" HeaderText="Net" ReadOnly="True" SortExpression="Net_Amount" />
                <asp:BoundField DataField="Product_Distribution_Date" DataFormatString="{0:d MMM yyyy}" HeaderText="Order Date" SortExpression="Product_Distribution_Date" />
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="DeliverySQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_Distribution.Product_Total_Point, Product_Distribution.Product_Distribution_Date, Product_Distribution.Distribution_SN, Product_Distribution.Commission_Amount, Product_Distribution.Net_Amount, Registration.UserName, Registration.Name, Product_Distribution.Product_Total_Amount, Product_Distribution.Product_DistributionID, Product_Distribution.SellerID FROM Product_Distribution INNER JOIN Seller ON Product_Distribution.SellerID = Seller.SellerID INNER JOIN Registration ON Seller.SellerRegistrationID = Registration.RegistrationID WHERE (Product_Distribution.Is_Confirmed = 1) AND (Product_Distribution.Is_Delivered = 0)" UpdateCommand="UPDATE Product_Distribution SET Is_Delivered = 1, Delivery_Date = GETDATE(), Delivered_RegistrationID = @Delivered_RegistrationID WHERE (Product_DistributionID = @Product_DistributionID)">
            <UpdateParameters>
                <asp:SessionParameter Name="Delivered_RegistrationID" SessionField="RegistrationID" />
                <asp:Parameter Name="Product_DistributionID" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="Seller_Product_insert_UpdateSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM [Seller]" InsertCommand=" IF NOT EXISTS (SELECT * FROM  Seller_Product WHERE (SellerID = @SellerID) AND (Product_PointID = @Product_PointID))
BEGIN
INSERT INTO Seller_Product (SellerID, Product_PointID, SellerProduct_Stock) VALUES(@SellerID, @Product_PointID, @SellerProduct_Stock)
END
ELSE
BEGIN
UPDATE Seller_Product SET SellerProduct_Stock =SellerProduct_Stock + @SellerProduct_Stock WHERE (SellerID = @SellerID) AND (Product_PointID = @Product_PointID)
END">
            <InsertParameters>
                <asp:Parameter Name="SellerID" />
                <asp:Parameter Name="Product_PointID" />
                <asp:Parameter Name="SellerProduct_Stock" />
            </InsertParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="Stock_UpdateSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM [Product_Point_Code]" UpdateCommand="UPDATE  Product_Point_Code SET Stock_Quantity -= @Stock_Quantity WHERE (Product_PointID = @Product_PointID)">
            <UpdateParameters>
                <asp:Parameter Name="Product_PointID" />
                <asp:Parameter Name="Stock_Quantity" />
            </UpdateParameters>
        </asp:SqlDataSource>

        <br />
    </div>

    <%if (OrderGridView.Rows.Count > 0)
        {%>
    <asp:Button ID="Delivery_Button" CssClass="btn btn-primary" runat="server" Text="Delivery" OnClick="Delivery_Button_Click" />
    <%} %>

    <script>
        $("[id*=AllCheckBox]").on("click", function () {
            var a = $(this), b = $(this).closest("table");
            $("input[type=checkbox]", b).each(function () {
                a.is(":checked") ? ($(this).attr("checked", "checked"), $("td", $(this).closest("tr")).addClass("selected")) : ($(this).removeAttr("checked"), $("td", $(this).closest("tr")).removeClass("selected"));
            });
        });

        //Add or Remove CheckBox Selected Color
        $("[id*=ConfirmCheckBox]").on("click", function () {
            $(this).is(":checked") ? ($("td", $(this).closest("tr")).addClass("selected")) : ($("td", $(this).closest("tr")).removeClass("selected"), $($(this).closest("tr")).removeClass("selected"));
        });
    </script>
</asp:Content>
