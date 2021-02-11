<%@ Page Title="Authority Profile" Language="C#" MasterPageFile="~/Design.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="CncAgro.Access_Authority.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="container">
        <h3>Authority Profile</h3>
        <div class="row">
            <div class="col-md-3">
                <div class="list-group">
                    <a class="list-group-item" href="SignUp_Institution.aspx">Signup admin</a>
                    <a class="list-group-item" href="Create_Delete_Role.aspx">Create Role</a>
                    <a class="list-group-item" href="Manage_Roles.aspx">Manage Roles</a>
                    <a class="list-group-item" href="Change_Password.aspx">Change Password</a>
                    <a class="list-group-item" href="Link/Category.aspx">Page Link</a>
                </div>
            </div>

            <div class="col-md-9">
                <div class="table-responsive">
                    <asp:GridView ID="UserAccounts" runat="server" AllowPaging="true"
                        AutoGenerateColumns="False" OnRowDataBound="UserAccounts_RowDataBound" CssClass="mGrid">
                        <Columns>
                            <asp:HyperLinkField DataNavigateUrlFields="UserName" DataNavigateUrlFormatString="Approve_Unlock_User.aspx?user={0}" Text="Manage" />
                            <asp:BoundField DataField="UserName" HeaderText="User Name" />
                            <asp:BoundField DataField="Email" HeaderText="Email" />
                            <asp:CheckBoxField DataField="IsApproved" Text=" " HeaderText="Approved?" />
                            <asp:CheckBoxField DataField="IsLockedOut" Text=" " HeaderText="Locked Out?" />
                            <asp:CheckBoxField DataField="IsOnline" Text=" " HeaderText="Online?" />
                            <asp:BoundField DataField="Comment" HeaderText="Comment" />
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:LinkButton ID="DeleteLinkButton" OnClientClick="return confirm('Are you sure you want to delete?')" runat="server" CommandArgument='<%#Eval("UserName") %>' OnCommand="DeleteLinkButton_Command">Delete</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            No Record(s) Found!
                        </EmptyDataTemplate>
                        <PagerStyle CssClass="pgr" />
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
