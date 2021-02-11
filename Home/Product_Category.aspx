<%@ Page Title="" Language="C#" MasterPageFile="~/Design.Master" AutoEventWireup="true" CodeBehind="Product_Category.aspx.cs" Inherits="CncAgro.Home.Product_Category" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="container">
        <asp:FormView ID="CategoryFormView" runat="server" DataKeyNames="Product_CategoryID" DataSourceID="CategorySQL" Width="100%">
            <ItemTemplate>
                <h4 id="product-title" class="font-weight-bold my-3"><%# Eval("Product_Category") %></h4>
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
                    <div class="col-lg-3 col-md-4 col-6 mb-4">
                        <div class="card">
                            <div class="view overlay">
                                <img src='/Handler/HomePageProductImage.ashx?id=<%#Eval("ProductID") %>' class="card-img-top" alt="<%#Eval("Product_Title") %>" />
                                <a href="#!">
                                    <div class="mask rgba-white-slight"></div>
                                </a>
                            </div>

                            <div class="card-body text-center">
                                <hr/>
                                <strong class="dark-grey-text"><%#Eval("Product_Title") %></strong>
                            </div>
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
            $(document).attr("title", $("#product-title").text());
        });
    </script>
</asp:Content>
