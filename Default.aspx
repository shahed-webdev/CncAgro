<%@ Page Title="" Language="C#" MasterPageFile="~/Design.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="CncAgro.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/CSS/home.css?v=1" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">

    <div class="container mt-4">
        <div class="row">
            <div class="col-lg-3 col-md-4">
                <div class="category-container h-100 z-depth-1 p-3">
                    <h3>Category</h3>

                    <div class="list-group list-group-flush">
                        <asp:Repeater ID="Repeater1" runat="server" DataSourceID="Product_CategorySQL">
                            <ItemTemplate>
                                <li class="list-group-item">
                                    <a target="_blank" href="Home/Product_Category.aspx?cid=<%#Eval("Product_CategoryID") %>">
                                        <%#Eval("Product_Category") %>
                                    </a>
                                </li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>

            <div class="col-lg-9 col-md-8">
                <div id="slider-image" class="carousel slide carousel-fade" data-ride="carousel">
                    <div class="carousel-inner z-depth-1">
                        <asp:Repeater ID="Slider_Repeater" runat="server" DataSourceID="Home_SliderSQL">
                            <ItemTemplate>
                                <div class="carousel-item">
                                    <img src="/Handler/HomePageSliderImage.ashx?id=<%#Eval("SliderID") %>" alt="<%# Eval("Description") %>" class="d-block w-100" />
                                    <div class="carousel-caption">
                                        <h2><%# Eval("Description") %></h2>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                    <a class="carousel-control-prev" href="#slider-image" role="button" data-slide="prev">
                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                        <span class="sr-only">Previous</span>
                    </a>
                    <a class="carousel-control-next" href="#slider-image" role="button" data-slide="next">
                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                        <span class="sr-only">Next</span>
                    </a>
                </div>
            </div>
            <asp:SqlDataSource ID="Home_SliderSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT SliderID, Image, Description FROM Home_Slider"></asp:SqlDataSource>
        </div>
    </div>

    <div class="container mt-5">
        <asp:Repeater ID="Category_Repeater" runat="server" DataSourceID="Product_CategorySQL">
            <ItemTemplate>
                <asp:HiddenField ID="CategoryIDHF" Value='<%#Bind("Product_CategoryID") %>' runat="server" />
                <div class="product-category d-flex justify-content-between align-items-center mb-3">
                    <h4><%#Eval("Product_Category") %></h4>
                    <a target="_blank" href="Home/Product_Category.aspx?cid=<%#Eval("Product_CategoryID") %>">
                        <i class="far fa-eye mr-1"></i>View more
                    </a>
                </div>

                <div class="row mb-5">
                    <asp:Repeater ID="Product_Repeater" runat="server" DataSourceID="ProductSQL">
                        <ItemTemplate>
                            <div class="col-lg-3 col-md-4 col-6">
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
                    <asp:SqlDataSource ID="ProductSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>"
                        SelectCommand="SELECT top(4) Product_Title,ProductID FROM Home_Product WHERE (Product_CategoryID = @Product_CategoryID)">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="CategoryIDHF" Name="Product_CategoryID" PropertyName="Value" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>
            </ItemTemplate>
        </asp:Repeater>
        <asp:SqlDataSource ID="Product_CategorySQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM Home_Product_Category ORDER BY Ascending"></asp:SqlDataSource>
    </div>


    <script>
        $(function () {
            $('#slider-image').find('.carousel-item').first().addClass('active');
        });
    </script>
</asp:Content>
