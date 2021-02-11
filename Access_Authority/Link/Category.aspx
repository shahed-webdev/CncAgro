<%@ Page Title="Category" Language="C#" MasterPageFile="~/Design.Master" AutoEventWireup="true" CodeBehind="Category.aspx.cs" Inherits="CncAgro.Access_Authority.Page_Link.Category" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="container">
        <h3>Page Link category</h3>

        <div class="form-inline">
            <div class="form-group">
                <asp:TextBox ID="AscendingTextBox" placeholder="Ascending" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="form-group">
                <asp:TextBox ID="CategoryTextBox" placeholder="Category Name" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*" ControlToValidate="CategoryTextBox" CssClass="Rf-Error" ValidationGroup="1"></asp:RequiredFieldValidator>
            </div>
            <div class="form-group">
                <asp:Button ID="SubmitButton" runat="server" Text="Submit" OnClick="SubmitButton_Click" CssClass="btn btn-primary" ValidationGroup="1" /></div>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="CategoryGridView" runat="server" AutoGenerateColumns="False" DataKeyNames="LinkCategoryID" DataSourceID="CategorySQL" CssClass="mGrid">
                <Columns>
                    <asp:CommandField ShowEditButton="True" />
                    <asp:BoundField DataField="Ascending" HeaderText="Ascending" SortExpression="Ascending" />
                    <asp:BoundField DataField="Category" HeaderText="Category" SortExpression="Category" />
                    <asp:HyperLinkField DataNavigateUrlFields="LinkCategoryID,Category" DataNavigateUrlFormatString="Sub_Category.aspx?Category={0}&CN={1}" DataTextField="Category" HeaderText="Select Category to Set URL" />
                    <asp:CommandField ShowDeleteButton="True" />
                </Columns>
                <EmptyDataTemplate>
                    No Data Added
                </EmptyDataTemplate>
            </asp:GridView>
            <asp:SqlDataSource ID="CategorySQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" DeleteCommand="DELETE FROM [Link_Category] WHERE [LinkCategoryID] = @LinkCategoryID" InsertCommand="INSERT INTO [Link_Category] ([Ascending], [Category]) VALUES (@Ascending, @Category)" SelectCommand="SELECT LinkCategoryID, Category, Ascending FROM Link_Category ORDER BY Ascending" UpdateCommand="UPDATE [Link_Category] SET [Ascending] = @Ascending, [Category] = @Category WHERE [LinkCategoryID] = @LinkCategoryID" ProviderName="<%$ ConnectionStrings:DBConnectionString.ProviderName %>">
                <DeleteParameters>
                    <asp:Parameter Name="LinkCategoryID" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:ControlParameter ControlID="AscendingTextBox" Name="Ascending" PropertyName="Text" Type="Int32" />
                    <asp:ControlParameter ControlID="CategoryTextBox" Name="Category" PropertyName="Text" Type="String" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="Ascending" Type="Int32" />
                    <asp:Parameter Name="Category" Type="String" />
                    <asp:Parameter Name="LinkCategoryID" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>
        </div>
    </div>
</asp:Content>
