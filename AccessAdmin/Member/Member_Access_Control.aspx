<%@ Page Title="Customer Access Control" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Member_Access_Control.aspx.cs" Inherits="CncAgro.AccessAdmin.Member.Member_Access_Control" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Customer Access Control</h3>
    <div class="form-inline">
        <div class="form-group">
            <asp:TextBox ID="FindTextBox" runat="server" CssClass="form-control" placeholder="Find by Name, Username, Phone"></asp:TextBox>
        </div>
        <div class="form-group">
            <asp:Button ID="FindButton" runat="server" CssClass="btn btn-primary" Text="Find" OnClick="FindButton_Click" />
        </div>
    </div>

    <div class="alert alert-success">
        <asp:Label ID="Total_Label" runat="server" CssClass="Result_Msg"></asp:Label>
    </div>

    <div class="table-responsive">
        <asp:GridView ID="Member_GridView" AllowSorting="true" runat="server" AutoGenerateColumns="False" DataKeyNames="UserName" DataSourceID="MemberSQL" CssClass="mGrid" AllowPaging="True" PageSize="15">
            <Columns>
                <asp:HyperLinkField DataTextField="UserName" DataNavigateUrlFields="RegistrationID" DataNavigateUrlFormatString="../Change_User_Password.aspx?reg={0}" HeaderText="User ID" />
                <asp:BoundField DataField="Password" HeaderText="Password" SortExpression="Password" />
                <asp:BoundField DataField="Name" HeaderText="Name" ReadOnly="True" SortExpression="Name" />
                <asp:BoundField DataField="Phone" HeaderText="Phone" SortExpression="Phone" />
                <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" />
                <asp:TemplateField HeaderText="Approved?">
                    <ItemTemplate>
                        <asp:CheckBox ID="ApprovedCheckBox" runat="server" AutoPostBack="true" Checked='<%# Bind("IsApproved") %>' OnCheckedChanged="ApprovedCheckBox_CheckedChanged" Text=" " />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Locked Out?">
                    <ItemTemplate>
                        <asp:CheckBox ID="LockedOutCheckBox" runat="server" AutoPostBack="true" Checked='<%# Bind("IsLockedOut") %>' OnCheckedChanged="LockedOutCheckBox_CheckedChanged" Text=" " />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="CreateDate" HeaderText="Create Date" SortExpression="CreateDate" />
                <asp:BoundField DataField="LastLoginDate" HeaderText="Last Login" SortExpression="LastLoginDate" />
                <asp:BoundField DataField="LastPasswordChangedDate" HeaderText="Last Password Changed" SortExpression="LastPasswordChangedDate" />
            </Columns>
            <EmptyDataTemplate>
                No Record(s) Found!
            </EmptyDataTemplate>

            <PagerStyle CssClass="pgr" />

        </asp:GridView>
        <asp:SqlDataSource ID="MemberSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.Name, Registration.UserName, User_Login_Info.Password, aspnet_Membership.Email, Registration.Phone, aspnet_Membership.IsApproved, aspnet_Membership.IsLockedOut, aspnet_Membership.CreateDate, aspnet_Membership.LastLoginDate, aspnet_Membership.LastPasswordChangedDate, Registration.RegistrationID FROM aspnet_Users INNER JOIN aspnet_Membership ON aspnet_Users.UserId = aspnet_Membership.UserId INNER JOIN Registration ON aspnet_Users.UserName = Registration.UserName INNER JOIN User_Login_Info ON Registration.UserName = User_Login_Info.UserName WHERE (Registration.Category = N'Member')"
            FilterExpression="Name LIKE '{0}%' or Phone LIKE '{0}%' or UserName LIKE '{0}%'" CancelSelectOnNullParameter="False">
            <FilterParameters>
                <asp:ControlParameter ControlID="FindTextBox" Name="Find" PropertyName="Text" />
            </FilterParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>
