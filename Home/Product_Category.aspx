<%@ Page Title="" Language="C#" MasterPageFile="~/Design.Master" AutoEventWireup="true" CodeBehind="Product_Category.aspx.cs" Inherits="CncAgro.Home.Product_Category" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Product_Category.css?v=2" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="container">
        <asp:FormView ID="CategoryFormView" runat="server" DataKeyNames="Product_CategoryID" DataSourceID="CategorySQL" Width="100%">
            <ItemTemplate>
                <div class="Product-heading">
                    <span id="CN"><%# Eval("Product_Category") %></span>
                </div>
            </ItemTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="CategorySQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM [Home_Product_Category] WHERE ([Product_CategoryID] = @Product_CategoryID)">
            <SelectParameters>
                <asp:QueryStringParameter Name="Product_CategoryID" QueryStringField="cid" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>

        <div class="row">
            <asp:Repeater ID="Product_Repeater" runat="server" DataSourceID="ProductSQL">
                <ItemTemplate>
                    <div class="col-lg-3 col-sm-4 col-xs-6">
                        <div class="Card">
                            <div class="card-img">
                                <img src='/Handler/HomePageProductImage.ashx?id=<%#Eval("ProductID") %>' class="img-responsive" alt="" />
                            </div>
                            <h4><%#Eval("Product_Title") %></h4>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <asp:SqlDataSource ID="ProductSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>"
            SelectCommand="SELECT * FROM Home_Product WHERE (Product_CategoryID = @Product_CategoryID)">
            <SelectParameters>
                <asp:QueryStringParameter Name="Product_CategoryID" QueryStringField="cid" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>

    <script>
        $(function () {
            $(document).attr("title", $("#CN").text());
        });
    </script>
</asp:Content>
