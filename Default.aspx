<%@ Page Title="" Language="C#" MasterPageFile="~/Design.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="CncAgro.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/CSS/Home.css?v=2" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="container">
        <div class="col-md-3 col-sm-4">
            <div class="box-heading">
                <h3>Category</h3>
            </div>
            <div class="list-group">
                <asp:Repeater ID="Repeater1" runat="server" DataSourceID="Product_CategorySQL">
                    <ItemTemplate>
                        <a target="_blank" href="Home/Product_Category.aspx?cid=<%#Eval("Product_CategoryID") %>" class="list-group-item"><%#Eval("Product_Category") %> <i class="fa fa-angle-right link-right" aria-hidden="true"></i></a>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>

        <div class="col-md-9 col-sm-8">
            <div id="myCarousel" class="carousel slide" data-ride="carousel">
                <div class="carousel-inner" role="listbox">
                    <asp:Repeater ID="Slider_Repeater" runat="server" DataSourceID="Home_SliderSQL">
                        <ItemTemplate>
                            <div class="item">
                                <img src="/Handler/HomePageSliderImage.ashx?id=<%#Eval("SliderID") %>" alt="" />

                                <div class="carousel-caption">
                                    <h2><%# Eval("Description") %></h2>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <!-- Left and right controls -->
                <a class="left carousel-control" href="#myCarousel" role="button" data-slide="prev">
                    <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
                    <span class="sr-only">Previous</span>
                </a>
                <a class="right carousel-control" href="#myCarousel" role="button" data-slide="next">
                    <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
                    <span class="sr-only">Next</span>
                </a>
            </div>
        </div>
        <asp:SqlDataSource ID="Home_SliderSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT SliderID, Image, Description FROM Home_Slider"></asp:SqlDataSource>
    </div>

    <div class="container t-space">
        <asp:Repeater ID="Category_Repeater" runat="server" DataSourceID="Product_CategorySQL">
            <ItemTemplate>
                <asp:HiddenField ID="CategoryIDHF" Value='<%#Bind("Product_CategoryID") %>' runat="server" />
                <div class="Product-heading">
                    <span><%#Eval("Product_Category") %></span>
                </div>

                <div class="row">
                    <asp:Repeater ID="Product_Repeater" runat="server" DataSourceID="ProductSQL">
                        <ItemTemplate>
                            <div class="col-md-3 col-sm-4 col-xs-6">
                                <div class="panel">
                                    <div class="panel-body">
                                        <img src='/Handler/HomePageProductImage.ashx?id=<%#Eval("ProductID") %>' class="img-responsive pimg" alt="" />
                                    </div>

                                    <div class="panel-title">
                                        <%#Eval("Product_Title") %>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:SqlDataSource ID="ProductSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>"
                        SelectCommand="SELECT top(4) Product_Title,ProductID FROM Home_Product WHERE (Product_CategoryID = @Product_CategoryID)">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="CategoryIDHF" Name="Product_CategoryID" PropertyName="Value" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <div class="clearfix"></div>
                </div>

                <div class="btnwaper">
                    <a class="SeeMore" target="_blank" href="Home/Product_Category.aspx?cid=<%#Eval("Product_CategoryID") %>">See More</a>
                </div>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="Product_CategorySQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM Home_Product_Category ORDER BY Ascending"></asp:SqlDataSource>
    </div>


    <script src="/Home/js/Slider.js"></script>
    <script>
        $(document).ready(function () {
            $('#myCarousel').find('.item').first().addClass('active');
        });
    </script>
</asp:Content>
