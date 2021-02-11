<%@ Page Title="Create Role" Language="C#" MasterPageFile="~/Design.Master" AutoEventWireup="true" CodeBehind="Create_Delete_Role.aspx.cs" Inherits="CncAgro.Access_Authority.Create_Delete_Role" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="container">
        <h3>Manage Roles</h3>

        <div class="form-inline">
            <div class="form-group">
                <asp:TextBox ID="RoleName" placeholder="Enter Role Name" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RoleNameReqField" runat="server" ControlToValidate="RoleName" ErrorMessage="*" CssClass="Rf-Error" ValidationGroup="A" />
            </div>
            <div class="form-group">
                <asp:Button ID="CreateRoleButton" runat="server" Text="Create Role" OnClick="CreateRoleButton_Click" CssClass="btn btn-primary" ValidationGroup="A" />
            </div>
        </div>


        <div class="table-responsive">
            <asp:GridView ID="RoleList" runat="server" AutoGenerateColumns="False" OnRowDeleting="RoleList_RowDeleting" CssClass="mGrid">
                <Columns>
                    <asp:TemplateField HeaderText="Role">
                        <ItemTemplate>
                            <asp:Label runat="server" ID="RoleNameLabel" Text='<%# Container.DataItem %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Delete Role" ShowHeader="False">
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButton1" runat="server" OnClientClick="return confirm('Are you sure you want to delete?')" CausesValidation="False" CommandName="Delete" Text="Delete"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
