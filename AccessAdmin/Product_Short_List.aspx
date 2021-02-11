<%@ Page Title="Product Short List" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Product_Short_List.aspx.cs" Inherits="CncAgro.AccessAdmin.Product_Short_List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .stockOut { background-color: #f68787; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Product Short List</h3>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="form-inline">
                <div class="form-group">
                    <asp:TextBox ID="FindTextBox" placeholder="Code, Name" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="form-group">
                    <asp:Button ID="FindButton" runat="server" Text="Find" CssClass="btn btn-primary" />
                </div>
            </div>

            <div class="table-responsive">
                <asp:GridView ID="ProductGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataKeyNames="Product_PointID" DataSourceID="Product_PointSQL" AllowSorting="True">
                    <Columns>
                        <asp:TemplateField HeaderText="Product Name" SortExpression="Product_Name">
                            <EditItemTemplate>
                                <asp:TextBox ID="U_ProductTextBox" TextMode="MultiLine" CssClass="form-control" runat="server" Text='<%# Bind("Product_Name") %>'></asp:TextBox>
                                <asp:RequiredFieldValidator ID="Rvalidator1" runat="server" ControlToValidate="U_ProductTextBox" CssClass="Error" ErrorMessage="*" SetFocusOnError="True" ValidationGroup="U"></asp:RequiredFieldValidator>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <%# Eval("Product_Name") %>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Code" SortExpression="Product_Code">
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# Bind("Product_Code") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Point" SortExpression="Product_Point">
                            <ItemTemplate>
                                <asp:Label ID="Label4" runat="server" Text='<%# Bind("Product_Point") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Price" SortExpression="Product_Price">
                            <ItemTemplate>
                                <asp:Label ID="Label5" runat="server" Text='<%# Bind("Product_Price") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Quantity" SortExpression="Stock_Quantity">
                            <EditItemTemplate>
                                <asp:TextBox ID="TextBox1" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" runat="server" CssClass="form-control" Text='<%# Bind("Stock_Quantity") %>'></asp:TextBox>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <span class="Quntity"><%#Eval("Stock_Quantity") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <asp:TemplateField ShowHeader="False" HeaderText="Edit">
                            <EditItemTemplate>
                                <asp:LinkButton ID="UpdateButton" ValidationGroup="U" runat="server" CausesValidation="True" CommandName="Update" Text="Update"></asp:LinkButton>
                                <asp:LinkButton ID="CancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit"></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        No Added Product
                    </EmptyDataTemplate>
                </asp:GridView>
                <asp:SqlDataSource ID="Product_PointSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>"
                    SelectCommand="SELECT Product_PointID, Product_Name, Product_Code, Product_Point, Product_Price, Stock_Quantity, Seller_Commission, Order_Quantity, Net_Quantity, IsActive FROM Product_Point_Code WHERE (IsActive = 1)" UpdateCommand="IF NOT EXISTS (SELECT * FROM  Product_Point_Code WHERE  (Product_Code = @Product_Code) and  [Product_PointID] &lt;&gt; @Product_PointID)
BEGIN
UPDATE [Product_Point_Code] SET [Product_Name] = @Product_Name, [Product_Code] = @Product_Code, Product_Point = @Product_Point, Product_Price = @Product_Price, Stock_Quantity = @Stock_Quantity, Seller_Commission = @Seller_Commission WHERE [Product_PointID] = @Product_PointID
END"
                    FilterExpression="Product_Code like '{0}%' OR Product_Name like '{0}%'">
                    <FilterParameters>
                        <asp:ControlParameter ControlID="FindTextBox" Name="Find" PropertyName="Text" />
                    </FilterParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="Product_Code" Type="String" />
                        <asp:Parameter Name="Product_PointID" Type="Int32" />
                        <asp:Parameter Name="Product_Name" Type="String" />
                        <asp:Parameter Name="Product_Point" />
                        <asp:Parameter Name="Product_Price" />
                        <asp:Parameter Name="Stock_Quantity" />
                        <asp:Parameter Name="Seller_Commission" />
                    </UpdateParameters>
                </asp:SqlDataSource>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <asp:UpdateProgress ID="UpdateProgress" runat="server">
        <ProgressTemplate>
            <div id="progress_BG"></div>
            <div id="progress">
                <img src="/CSS/Image/loading.gif" alt="Loading..." />
                <br />
                <b>Loading...</b>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>

    <script>
        $(function () {
            $('.mGrid .Quntity').each(function () {
                var val = $(this).html();
                if (val == "0") {
                    $(this).closest("tr").addClass("stockOut");
                }
            });
        })
    </script>
</asp:Content>
