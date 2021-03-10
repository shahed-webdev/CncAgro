<%@ Page Title="Order Details" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Order_Details.aspx.cs" Inherits="CncAgro.AccessMember.Selling.Order_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Order Details</h3>
    <a href="Order_Record.aspx"><i class="far fa-hand-point-left mr-1"></i>Back To Record</a>

    <div class="table-responsive">
        <asp:GridView ID="DetailsGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="DetailsSQL">
            <Columns>
                <asp:BoundField DataField="Product_Code" HeaderText="Code" SortExpression="Product_Code" />
                <asp:BoundField DataField="Product_Name" HeaderText="Product Name" SortExpression="Product_Name" />
                <asp:BoundField DataField="SellingQuantity" HeaderText="Quantity" SortExpression="SellingQuantity" />
                <asp:BoundField DataField="SellingUnitPrice" HeaderText="Unit Price" SortExpression="SellingUnitPrice" />
                <asp:BoundField DataField="ProductPrice" HeaderText="Total Price" ReadOnly="True" SortExpression="ProductPrice" />
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="DetailsSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_Point_Code.Product_Code, Product_Point_Code.Product_Name, Product_Distribution_Records.SellingQuantity, Product_Distribution_Records.SellingUnitPrice, Product_Distribution_Records.SellingUnitPoint, Product_Distribution_Records.ProductPrice, Product_Distribution_Records.TotalPoint FROM Product_Distribution_Records INNER JOIN Product_Point_Code ON Product_Distribution_Records.ProductID = Product_Point_Code.Product_PointID WHERE (Product_Distribution_Records.Product_DistributionID = @Product_DistributionID)">
            <SelectParameters>
                <asp:QueryStringParameter Name="Product_DistributionID" QueryStringField="DistributionID" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>
