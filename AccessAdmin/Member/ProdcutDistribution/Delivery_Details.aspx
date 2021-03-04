<%@ Page Title="Product Details" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Delivery_Details.aspx.cs" Inherits="CncAgro.AccessAdmin.Member.ProductDistribution.Delivery_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Product Details</h3>
    <asp:FormView ID="InfoFormView" runat="server" DataSourceID="SellerInfoSQL" Width="100%" DataKeyNames="SellerID">
        <ItemTemplate>
            <div class="well">
                <h4 style="margin-top: 0; margin-bottom: 2px;"><%# Eval("Name") %></h4>
                <small>
                    <i class="fas fa-user-circle"></i>
                    <%# Eval("UserName") %>
                    <i class="fas fa-phone"></i>
                    Mobile: <%# Eval("Phone") %>
                    <i class="fas fa-list-ul"></i>
                    Receipt No. <%# Eval("Distribution_SN") %>
                </small>
            </div>
        </ItemTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="SellerInfoSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_Distribution.Distribution_SN, Registration.UserName, Registration.Name, Registration.Phone, Product_Distribution.SellerID FROM Product_Distribution INNER JOIN Seller ON Product_Distribution.SellerID = Seller.SellerID INNER JOIN Registration ON Seller.SellerRegistrationID = Registration.RegistrationID WHERE (Product_Distribution.Product_DistributionID = @Product_DistributionID)">
        <SelectParameters>
            <asp:QueryStringParameter Name="Product_DistributionID" QueryStringField="DistributionID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <a href="Product_Delivery.aspx"><i class="fas fa-hand-point-left"></i> Back</a>
    <asp:GridView ID="ProductGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="ProductSQL" AllowSorting="True" DataKeyNames="ProductID,SellingQuantity">
        <Columns>
            <asp:BoundField DataField="Product_Code" HeaderText="Code" SortExpression="Product_Code" />
            <asp:BoundField DataField="Product_Name" HeaderText="Product Name" SortExpression="Product_Name" />
             <asp:BoundField DataField="SellingQuantity" HeaderText="Quantity" SortExpression="SellingQuantity" />
            <asp:BoundField DataField="SellingUnitPrice" DataFormatString="{0:N}" HeaderText="Unit Price" SortExpression="SellingUnitPrice" />
            <asp:BoundField DataField="SellingUnitPoint" DataFormatString="{0:N}" HeaderText="Unit Point" SortExpression="SellingUnitPoint" />
            <asp:BoundField DataField="SellingUnit_Commission" DataFormatString="{0:N}" HeaderText="Unit Comm." SortExpression="SellingUnit_Commission" />        
            <asp:BoundField DataField="ProductPrice" DataFormatString="{0:N}" HeaderText="Total Price" ReadOnly="True" SortExpression="ProductPrice" />
            <asp:BoundField DataField="TotalPoint" DataFormatString="{0:N}" HeaderText="Total Point" ReadOnly="True" SortExpression="TotalPoint" />
            <asp:BoundField DataField="Total_Commission" DataFormatString="{0:N}" HeaderText="Total Comm." ReadOnly="True" SortExpression="Total_Commission" />
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="ProductSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_Distribution_Records.SellingQuantity, Product_Distribution_Records.SellingUnitPrice, Product_Distribution_Records.SellingUnitPoint, Product_Distribution_Records.ProductPrice, Product_Distribution_Records.TotalPoint, Product_Distribution_Records.Total_Commission, Product_Distribution_Records.SellingUnit_Commission, Product_Point_Code.Product_Name, Product_Point_Code.Product_Code, Product_Distribution_Records.ProductID FROM Product_Distribution_Records INNER JOIN Product_Point_Code ON Product_Distribution_Records.ProductID = Product_Point_Code.Product_PointID WHERE (Product_Distribution_Records.Product_DistributionID = @Product_DistributionID)" UpdateCommand="UPDATE Product_Distribution SET Is_Delivered = 1, Delivery_Date = GETDATE(), Delivered_RegistrationID = @Delivered_RegistrationID WHERE (Product_DistributionID = @Product_DistributionID)">
        <SelectParameters>
            <asp:QueryStringParameter Name="Product_DistributionID" QueryStringField="DistributionID" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:SessionParameter Name="Delivered_RegistrationID" SessionField="RegistrationID" />
            <asp:QueryStringParameter Name="Product_DistributionID" QueryStringField="DistributionID" />
        </UpdateParameters>
    </asp:SqlDataSource>

        <asp:SqlDataSource ID="Seller_Product_insert_UpdateSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM [Seller]" InsertCommand="IF NOT EXISTS (SELECT * FROM  Seller_Product WHERE (SellerID = @SellerID) AND (Product_PointID = @Product_PointID))
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
    <asp:Button ID="Delivery_Button" CssClass="btn btn-primary" runat="server" Text="Delivery" OnClick="Delivery_Button_Click" />
</asp:Content>
