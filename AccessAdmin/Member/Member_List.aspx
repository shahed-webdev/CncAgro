<%@ Page Title="Customer List" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Member_List.aspx.cs" Inherits="CncAgro.AccessAdmin.Member.Member_List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Customer List</h3>

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
        <asp:GridView ID="MemberListGridView" runat="server" AutoGenerateColumns="False" DataSourceID="MemberSQL" CssClass="mGrid" DataKeyNames="MemberID" AllowSorting="True" AllowPaging="True" PageSize="30">
            <Columns>
                <asp:HyperLinkField SortExpression="UserName" DataTextField="UserName" DataNavigateUrlFields="MemberID" DataNavigateUrlFormatString="Member_Details.aspx?member={0}" HeaderText="User ID" />
                <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                <asp:BoundField DataField="Phone" HeaderText="Phone" SortExpression="Phone" />
                <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" />
                <asp:BoundField DataField="SignUpDate" HeaderText="SignUp Date" SortExpression="SignUpDate" DataFormatString="{0:d MMM yyyy}" />
            </Columns>
            <EmptyDataTemplate>
                No Customer
            </EmptyDataTemplate>
            <PagerStyle CssClass="pgr" />
        </asp:GridView>
        <asp:SqlDataSource ID="MemberSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>"
            SelectCommand="SELECT Registration.Name, Registration.Phone, Registration.Email, Registration.UserName, Member.Is_Identified, Member.SignUpDate, Member.MemberID FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE (Registration.Category = N'Member') AND (Member.Is_Identified = 1) AND (Member.Default_MemberStatus = 0)"
            FilterExpression="Name LIKE '{0}%' or Phone LIKE '{0}%' or UserName LIKE '{0}%'" CancelSelectOnNullParameter="False">
            <FilterParameters>
                <asp:ControlParameter ControlID="FindTextBox" Name="Find" PropertyName="Text" />
            </FilterParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>
