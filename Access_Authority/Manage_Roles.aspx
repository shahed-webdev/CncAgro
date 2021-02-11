<%@ Page Title="Manage Roles" Language="C#" MasterPageFile="~/Design.Master" AutoEventWireup="true" CodeBehind="Manage_Roles.aspx.cs" Inherits="CncAgro.Access_Authority.Manage_Roles" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
 </asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="container">
        <asp:Label ID="ActionStatus" runat="server" ForeColor="#CE5300"></asp:Label>
        <h3>Manage Roles By User</h3>
        <div class="well">
            <div class="form-group">
                <label>Select a User</label>
                <asp:DropDownList ID="UserList" runat="server" AutoPostBack="True" DataTextField="UserName" DataValueField="UserName" OnSelectedIndexChanged="UserList_SelectedIndexChanged" CssClass="form-control" />
            </div>

            <div class="form-group">
                <label>Select Role(s)</label><br />
                <asp:Repeater ID="UsersRoleList" runat="server">
                    <ItemTemplate>
                        <asp:CheckBox runat="server" ID="RoleCheckBox" AutoPostBack="true" Text='<%# Container.DataItem %>' OnCheckedChanged="RoleCheckBox_CheckChanged" />
                        <br />
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
        <h3>Manage Users By Role</h3>
        <div class="well">
            <div class="form-group">
                <label>Select a Role</label>
                <asp:DropDownList ID="RoleList" runat="server" AutoPostBack="true" OnSelectedIndexChanged="RoleList_SelectedIndexChanged" CssClass="form-control"></asp:DropDownList>
            </div>

            <div class="table-responsive">
                <asp:GridView ID="RolesUserList" runat="server" AutoGenerateColumns="False"
                    EmptyDataText="No users belong to this role."
                    OnRowDeleting="RolesUserList_RowDeleting" CssClass="mGrid">
                    <Columns>
                        <asp:TemplateField HeaderText="Users">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="UserNameLabel" Text='<%# Container.DataItem %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ShowHeader="False">
                            <ItemTemplate>
                                <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Delete" Text="Remove" OnClientClick="return confirm('Are you sure you want to remove?')"></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <br />
            <div class="form-inline">
                <div class="form-group">
                    <asp:TextBox ID="UserNameToAddToRole" placeholder="Username" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="UserNameToAddToRole" CssClass="EroorStar" ErrorMessage="*" ValidationGroup="U"></asp:RequiredFieldValidator>
                </div>
                <div class="form-group">
                    <asp:Button ID="AddUserToRoleButton" runat="server" Text="Add User to Role" OnClick="AddUserToRoleButton_Click" CssClass="btn btn-primary" ValidationGroup="U" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
