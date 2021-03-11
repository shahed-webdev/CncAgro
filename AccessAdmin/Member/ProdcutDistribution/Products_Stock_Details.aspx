<%@ Page Title="Stock Details" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Products_Stock_Details.aspx.cs" Inherits="CncAgro.AccessAdmin.Member.ProductDistribution.Products_Stock_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <asp:FormView ID="MemberFormView" runat="server" DataSourceID="MemberSQL" Width="100%">
        <ItemTemplate>
            <h3 class="mb-0">Stock Details</h3>
            <p><%# Eval("Name") %>, Id: <%# Eval("UserName") %></p>
        </ItemTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="MemberSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.Name, Registration.UserName FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE (Member.MemberID = @MemberID)">
        <SelectParameters>
            <asp:QueryStringParameter Name="MemberID" QueryStringField="d" />
        </SelectParameters>
    </asp:SqlDataSource>

    <div class="card card-body">
        <asp:FormView ID="Stock_FormView" runat="server" DataSourceID="StockSQL" Width="100%">
            <ItemTemplate>
                <h5 class="font-weight-bold">Stock: <%# Eval("Total_Stock") %></h5>
                <p>Total Price: ৳<%# Eval("Total_Price") %></p>
            </ItemTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="StockSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT SUM(MemberProduct.ProductStock) AS Total_Stock, SUM(MemberProduct.ProductStock * Product_Point_Code.Product_Point) AS Total_Point, SUM(MemberProduct.ProductStock * Product_Point_Code.Product_Price) AS Total_Price FROM MemberProduct INNER JOIN Product_Point_Code ON MemberProduct.Product_PointID = Product_Point_Code.Product_PointID WHERE (MemberProduct.MemberID = @MemberID)">
            <SelectParameters>
                <asp:QueryStringParameter Name="MemberID" QueryStringField="d" />
            </SelectParameters>
        </asp:SqlDataSource>

        <asp:GridView ID="ProductGridView" runat="server" AllowSorting="True" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="MemberProductSQL">
            <Columns>
                <asp:BoundField DataField="Product_Code" HeaderText="P.Code" SortExpression="Product_Code" />
                <asp:BoundField DataField="Product_Name" HeaderText="P.Name" SortExpression="Product_Name" />
                <asp:BoundField DataField="Product_Price" HeaderText="Price" SortExpression="Product_Price" />
                <asp:BoundField DataField="Product_Point" HeaderText="Point" SortExpression="Product_Point" />
                <asp:BoundField DataField="ProductStock" HeaderText="Stock" SortExpression="ProductStock" />
            </Columns>
            <EmptyDataTemplate>
                no record
            </EmptyDataTemplate>
        </asp:GridView>
        <asp:SqlDataSource ID="MemberProductSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_Point_Code.Product_Code, Product_Point_Code.Product_Name, Product_Point_Code.Product_Price, Product_Point_Code.Product_Point, MemberProduct.ProductStock FROM MemberProduct INNER JOIN Product_Point_Code ON MemberProduct.Product_PointID = Product_Point_Code.Product_PointID WHERE (MemberProduct.MemberID = @MemberID) AND (MemberProduct.ProductStock &lt;&gt; 0) ORDER BY MemberProduct.ProductStock DESC">
            <SelectParameters>
                <asp:QueryStringParameter Name="MemberID" QueryStringField="d" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>
