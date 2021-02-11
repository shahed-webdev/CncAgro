<%@ Page Title="Genealogy" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Member_List.aspx.cs" Inherits="CncAgro.AccessMember.Member_List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
   </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="Contain">
        <h3>Genealogy</h3>
        <div class="form-inline">
            <div class="form-group">
                <asp:TextBox ID="FindTextBox" runat="server" CssClass="form-control" placeholder="Find by Userid"></asp:TextBox>
            </div>
            <div class="form-group">
                <asp:Button ID="FindButton" runat="server" CssClass="btn btn-primary" Text="Find" OnClick="FindButton_Click" />
            </div>
        </div>

        <div class="table-responsive">
            <div class="alert alert-success">
                <asp:Label ID="Total_Label" runat="server" CssClass="Result_Msg"></asp:Label>
            </div>
            <asp:GridView ID="MembersGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="MembersSQL" AllowPaging="True" AllowSorting="True" PageSize="50">
                <Columns>
                    <asp:HyperLinkField SortExpression="UserName" DataTextField="UserName" DataNavigateUrlFields="MemberID" DataNavigateUrlFormatString="MyAlliance_Details.aspx?Member={0}" HeaderText="Details" />
                    <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                    <asp:BoundField DataField="Left_Carry_Point" HeaderText="L.P" SortExpression="Left_Carry_Point" />
                    <asp:BoundField DataField="Right_Carry_Point" HeaderText="R.P" SortExpression="Right_Carry_Point" />
                    <asp:BoundField DataField="TotalLeft_Member" HeaderText="L.M" SortExpression="TotalLeft_Member" />
                    <asp:BoundField DataField="TotalRight_Member" HeaderText="R.M" SortExpression="TotalRight_Member" />
                </Columns>
                <EmptyDataTemplate>
                    No Record
                </EmptyDataTemplate>
                <PagerStyle CssClass="pgr" />
            </asp:GridView>
            <asp:SqlDataSource ID="MembersSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Member.Right_Carry_Point, Member.TotalLeft_Member, Member.TotalRight_Member, Member.SignUpDate, Member.Left_Carry_Point, Member.Is_Identified, Registration.UserName, Member.MemberID, Registration.Name FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE (Member.Referral_MemberID = @Referral_MemberID) ORDER BY Member.SignUpDate DESC"
                FilterExpression="UserName LIKE '{0}%'" CancelSelectOnNullParameter="False">
                <FilterParameters>
                    <asp:ControlParameter ControlID="FindTextBox" Name="Find" PropertyName="Text" />
                </FilterParameters>
                <SelectParameters>
                    <asp:SessionParameter Name="Referral_MemberID" SessionField="MemberID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

        </div>
    </div>

    <script>
        $(document).ready(function () {
            $("#Member_List").addClass('L_Active');
        })
    </script>
</asp:Content>
