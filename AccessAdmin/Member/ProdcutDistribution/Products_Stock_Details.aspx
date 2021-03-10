<%@ Page Title="Stock Details" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Products_Stock_Details.aspx.cs" Inherits="CncAgro.AccessAdmin.Member.ProductDistribution.Products_Stock_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .Box { color: #fff; padding: 15px; font-size: 15px; margin-bottom: 15px; }
            .Box h5 { font-size: 20px; }

        .Total_Stock { background-color: #2F4254; }
        .Total_Price { background-color: #6F196E; }
        .Total_Point { background-color: #F39C12; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <asp:FormView ID="MemberFormView" runat="server" DataSourceID="MemberSQL" Width="100%">
        <ItemTemplate>
            <h3>Stock Details For:
         <asp:Label ID="NameLabel" runat="server" Text='<%# Bind("Name") %>' />
            </h3>
        </ItemTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="MemberSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.Name + '(' + Registration.UserName + ')' AS Name FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE (Member.MemberID = @MemberID)">
        <SelectParameters>
            <asp:QueryStringParameter Name="MemberID" QueryStringField="d" />
        </SelectParameters>
    </asp:SqlDataSource>


    <asp:FormView ID="Stock_FormView" runat="server" DataSourceID="StockSQL" Width="100%">
        <ItemTemplate>
            <div class="row text-center">
                <div class="col-sm-4">
                    <div class="Total_Stock Box">
                        <h5><%# Eval("Total_Stock") %></h5>
                        <small>STOCK QUANTITY</small>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="Total_Price Box">
                        <h5><%# Eval("Total_Price") %> Tk</h5>
                        <small>TOTAL PRICE</small>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="Total_Point Box">
                        <h5><%# Eval("Total_Point") %></h5>
                        <small>TOTAL POINT</small>
                    </div>
                </div>
            </div>
        </ItemTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="StockSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT SUM(MemberProduct.ProductStock) AS Total_Stock, SUM(MemberProduct.ProductStock * Product_Point_Code.Product_Point) AS Total_Point, SUM(MemberProduct.ProductStock * Product_Point_Code.Product_Price) AS Total_Price FROM MemberProduct INNER JOIN Product_Point_Code ON MemberProduct.Product_PointID = Product_Point_Code.Product_PointID WHERE (MemberProduct.MemberID = @MemberID)">
        <SelectParameters>
            <asp:QueryStringParameter Name="MemberID" QueryStringField="d" />
        </SelectParameters>
    </asp:SqlDataSource>

    <a href="OrderedMemberList.aspx" class="btn btn-success" style="margin-bottom:10px;"><< Back</a>
    <asp:GridView ID="ProductGridView" runat="server" AllowSorting="True" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="MemberProductSQL">
        <Columns>
            <asp:BoundField DataField="Product_Code" HeaderText="P.Code" SortExpression="Product_Code" />
            <asp:BoundField DataField="Product_Name" HeaderText="P.Name" SortExpression="Product_Name" />
            <asp:BoundField DataField="Product_Price" HeaderText="Price" SortExpression="Product_Price" />
            <asp:BoundField DataField="Product_Point" HeaderText="Point" SortExpression="Product_Point" />
            <asp:BoundField DataField="ProductStock" HeaderText="Stock" SortExpression="ProductStock" />
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="MemberProductSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_Point_Code.Product_Code, Product_Point_Code.Product_Name, Product_Point_Code.Product_Price, Product_Point_Code.Product_Point, MemberProduct.ProductStock FROM MemberProduct INNER JOIN Product_Point_Code ON MemberProduct.Product_PointID = Product_Point_Code.Product_PointID WHERE (MemberProduct.MemberID = @MemberID) AND (MemberProduct.ProductStock &lt;&gt; 0) ORDER BY MemberProduct.ProductStock DESC">
        <SelectParameters>
            <asp:QueryStringParameter Name="MemberID" QueryStringField="d" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
