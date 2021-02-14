<%@ Page Title="Home Page Image" Language="C#" MasterPageFile="~/Design.Master" AutoEventWireup="true" CodeBehind="Manage_Slider_Product.aspx.cs" Inherits="CncAgro.Manage_Slider_Product" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        h3 { border-bottom: 1px solid #ddd; margin-bottom: 15px; color: #777; padding-bottom: 5px; }
        .slider_img { width: 100px; }
        .file { height: auto !important; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="container-fluid my-3">
                <div class="row">
                    <div class="col-md-6">
                        <div class="card card-body">
                            <h3>Slider</h3>
                            <div class="form-group">
                                <label>Slider Image</label>
                                <asp:FileUpload ID="Slider_FileUpload" CssClass="form-control file" runat="server" />
                            </div>
                            <div class="form-group">
                                <label>Caption</label>
                                <asp:TextBox ID="CaptionTextBox" CssClass="form-control" runat="server"></asp:TextBox>
                            </div>
                            <asp:Button ID="SubmitButton" runat="server" Text="Submit" CssClass="btn btn-primary" OnClick="SubmitButton_Click" />
                            <asp:SqlDataSource ID="SliderSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>"
                                DeleteCommand="DELETE FROM [Home_Slider] WHERE [SliderID] = @SliderID"
                                SelectCommand="SELECT * FROM [Home_Slider]"
                                UpdateCommand="UPDATE [Home_Slider] SET [Description] = @Description WHERE [SliderID] = @SliderID">
                                <DeleteParameters>
                                    <asp:Parameter Name="SliderID" Type="Int32" />
                                </DeleteParameters>
                                <UpdateParameters>
                                    <asp:Parameter Name="Description" Type="String" />
                                    <asp:Parameter Name="SliderID" Type="Int32" />
                                </UpdateParameters>
                            </asp:SqlDataSource>

                            <br />
                            <asp:GridView ID="SliderGridView" runat="server" AutoGenerateColumns="False" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="4" DataKeyNames="SliderID" DataSourceID="SliderSQL" ForeColor="Black" GridLines="Horizontal" Width="100%">
                                <Columns>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <img class="img-responsive slider_img" src='/Handler/HomePageSliderImage.ashx?id=<%#Eval("SliderID") %>' alt="" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Description" HeaderText="Caption" SortExpression="Description" />
                                    <asp:CommandField ShowDeleteButton="True">
                                        <ItemStyle Width="30px" />
                                    </asp:CommandField>
                                </Columns>
                                <FooterStyle BackColor="#CCCC99" ForeColor="Black" />
                                <HeaderStyle BackColor="#333333" Font-Bold="True" ForeColor="White" />
                                <PagerStyle BackColor="White" ForeColor="Black" HorizontalAlign="Right" />
                                <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />
                                <SortedAscendingCellStyle BackColor="#F7F7F7" />
                                <SortedAscendingHeaderStyle BackColor="#4B4B4B" />
                                <SortedDescendingCellStyle BackColor="#E5E5E5" />
                                <SortedDescendingHeaderStyle BackColor="#242121" />
                            </asp:GridView>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card card-body">
                            <h3>Product</h3>
                            <div class="form-group">
                                <label>Product Category</label>
                                <asp:DropDownList ID="CategoryDropDownList" CssClass="form-control" runat="server" DataSourceID="CategorySQL" DataTextField="Product_Category" DataValueField="Product_CategoryID" AppendDataBoundItems="True" AutoPostBack="True">
                                    <asp:ListItem Value="%">All Category</asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="CategorySQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM [Home_Product_Category]"></asp:SqlDataSource>
                            </div>
                            <div class="form-group">
                                <label>Product Image</label>
                                <asp:FileUpload ID="Product_FileUpload" CssClass="form-control file" runat="server" />
                            </div>
                            <div class="form-group">
                                <label>Product Title</label>
                                <asp:TextBox ID="Product_TitleTextBox" CssClass="form-control" runat="server"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <asp:Button ID="ProductButton" CssClass="btn btn-default" runat="server" Text="Add Product" OnClick="ProductButton_Click" />
                                <asp:SqlDataSource ID="ProductSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>"
                                    DeleteCommand="DELETE FROM [Home_Product] WHERE [ProductID] = @ProductID"
                                    InsertCommand="INSERT INTO Home_Product(Product_Title, Product_CategoryID) VALUES (@Product_Title, @Product_CategoryID)"
                                    SelectCommand="SELECT Home_Product.ProductID, Home_Product.Product_Title, Home_Product.Product_Price, Home_Product.Product_Details, Home_Product_Category.Product_Category, Home_Product.Product_Point FROM Home_Product INNER JOIN Home_Product_Category ON Home_Product.Product_CategoryID = Home_Product_Category.Product_CategoryID WHERE (Home_Product_Category.Product_Category LIKE @Product_Category)"
                                    UpdateCommand="UPDATE Home_Product SET Product_Title = @Product_Title WHERE (ProductID = @ProductID)">
                                    <DeleteParameters>
                                        <asp:Parameter Name="ProductID" Type="Int32" />
                                    </DeleteParameters>
                                    <InsertParameters>
                                        <asp:ControlParameter ControlID="CategoryDropDownList" Name="Product_CategoryID" PropertyName="SelectedValue" />
                                        <asp:ControlParameter ControlID="Product_TitleTextBox" Name="Product_Title" PropertyName="Text" Type="String" />
                                    </InsertParameters>
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="CategoryDropDownList" Name="Product_Category" PropertyName="SelectedItem.text" />
                                    </SelectParameters>
                                    <UpdateParameters>
                                        <asp:Parameter Name="Product_Title" />
                                        <asp:Parameter Name="ProductID" />
                                    </UpdateParameters>
                                </asp:SqlDataSource>
                            </div>
                            <br />
                            <asp:GridView ID="ProductGridView" runat="server" AutoGenerateColumns="False" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="4" DataKeyNames="ProductID" DataSourceID="ProductSQL" ForeColor="Black" GridLines="Horizontal" Width="100%">
                                <Columns>
                                    <asp:BoundField DataField="Product_Category" HeaderText="Category" SortExpression="Product_Category" />
                                    <asp:BoundField DataField="Product_Title" HeaderText="Product Title" SortExpression="Product_Title" />
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <img src='/Handler/HomePageProductImage.ashx?id=<%#Eval("ProductID") %>' class="img-responsive  slider_img" alt="" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:CommandField ShowEditButton="True" />
                                    <asp:CommandField ShowDeleteButton="True" />
                                </Columns>
                                <FooterStyle BackColor="#CCCC99" ForeColor="Black" />
                                <HeaderStyle BackColor="#333333" Font-Bold="True" ForeColor="White" />
                                <PagerStyle BackColor="White" ForeColor="Black" HorizontalAlign="Right" />
                                <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />
                                <SortedAscendingCellStyle BackColor="#F7F7F7" />
                                <SortedAscendingHeaderStyle BackColor="#4B4B4B" />
                                <SortedDescendingCellStyle BackColor="#E5E5E5" />
                                <SortedDescendingHeaderStyle BackColor="#242121" />
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
