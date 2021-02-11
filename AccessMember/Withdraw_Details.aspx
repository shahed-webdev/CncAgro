<%@ Page Title="Withdraw Details" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Withdraw_Details.aspx.cs" Inherits="CncAgro.AccessMember.Withdraw_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Withdraw Details</h3>

    <ul class="nav nav-tabs" id="myTab" role="tablist">
        <li class="nav-item">
            <a class="nav-link active" id="home-tab" data-toggle="tab" href="#Pending" role="tab" aria-controls="Pending"
                aria-selected="true">Pending Withdraw</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="profile-tab" data-toggle="tab" href="#Confirm" role="tab" aria-controls="profile"
                aria-selected="false">Completed Withdraw</a>
        </li>
    </ul>
    <div class="tab-content">
        <div id="Pending" class="tab-pane fade show active" role="tabpanel">
            <asp:GridView ID="WithdrawGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataKeyNames="Withdraw_CodeID" DataSourceID="Withdraw_ListSQL">
                <Columns>
                    <asp:BoundField DataField="UserName" HeaderText="User Id" SortExpression="UserName" />
                    <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                    <asp:BoundField DataField="Phone" HeaderText="Phone" SortExpression="Phone" />
                    <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" />
                    <asp:BoundField DataField="Insert_Date" DataFormatString="{0:d MMM yyyy}" HeaderText="Requested Date" SortExpression="Insert_Date" />
                </Columns>
                <EmptyDataTemplate>
                    No Record
                </EmptyDataTemplate>
            </asp:GridView>
            <asp:SqlDataSource ID="Withdraw_ListSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Fund_Withdraw_Code.Withdraw_CodeID, Registration.UserName, Registration.Name, Registration.Phone, Fund_Withdraw_Code.Amount, Fund_Withdraw_Code.IS_Used, Fund_Withdraw_Code.Insert_Date FROM Fund_Withdraw_Code INNER JOIN Registration ON Fund_Withdraw_Code.Withdraw_RegistrationID = Registration.RegistrationID WHERE (Fund_Withdraw_Code.IS_Used = 0) AND (Fund_Withdraw_Code.Withdraw_RegistrationID = @Withdraw_RegistrationID)">
                <SelectParameters>
                    <asp:SessionParameter Name="Withdraw_RegistrationID" SessionField="RegistrationID" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>

        <div id="Confirm" class="tab-pane fade" role="tabpanel">
            <asp:GridView ID="ConfirmGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="ConfirmSQL">
                <Columns>
                    <asp:BoundField DataField="UserName" HeaderText="User id" SortExpression="UserName" />
                    <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                    <asp:BoundField DataField="Phone" HeaderText="Phone" SortExpression="Phone" />
                    <asp:BoundField DataField="Withdraw_Amount" HeaderText="Amount" SortExpression="Withdraw_Amount" DataFormatString="{0:N}" />
                    <asp:BoundField DataField="Withdraw_Date" DataFormatString="{0:d MMM yyyy}" HeaderText="Withdraw Date" SortExpression="Withdraw_Date" />
                </Columns>
                <EmptyDataTemplate>
                    No Record
                </EmptyDataTemplate>
            </asp:GridView>
            <asp:SqlDataSource ID="ConfirmSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.UserName, Registration.Name, Registration.Phone, Fund_Withdraw.Withdraw_Date, Fund_Withdraw.Withdraw_Amount FROM Fund_Withdraw_Code INNER JOIN Registration ON Fund_Withdraw_Code.Withdraw_RegistrationID = Registration.RegistrationID INNER JOIN Fund_Withdraw ON Fund_Withdraw_Code.Withdraw_CodeID = Fund_Withdraw.Withdraw_CodeID WHERE (Fund_Withdraw_Code.IS_Used = 1) AND (Fund_Withdraw_Code.Withdraw_RegistrationID = @Withdraw_RegistrationID)">
                <SelectParameters>
                    <asp:SessionParameter Name="Withdraw_RegistrationID" SessionField="RegistrationID" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
    </div>



    <script>
        $(function () {
            $("#Requested_Withdraw").addClass('L_Active');
        });
    </script>
</asp:Content>
