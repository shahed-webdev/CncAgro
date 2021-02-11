<%@ Page Title="Receive Balance" Language="C#" MasterPageFile="~/Seller.Master" AutoEventWireup="true" CodeBehind="Received_Balance.aspx.cs" Inherits="CncAgro.AccessSeller.Received_Balance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Received Balance</h3>

    <asp:GridView ID="ConfirmGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="ConfirmSQL">
        <Columns>
            <asp:BoundField DataField="UserName" HeaderText="Sender User id" SortExpression="UserName" />
            <asp:BoundField DataField="Name" HeaderText="Sender Name" SortExpression="Name" />
            <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" />
            <asp:BoundField DataField="TransitionDate" HeaderText="Transition Date" SortExpression="TransitionDate" DataFormatString="{0:d MMM yyyy}" />
        </Columns>
        <EmptyDataTemplate>
            No Record
        </EmptyDataTemplate>
    </asp:GridView>
    <asp:SqlDataSource ID="ConfirmSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.UserName, Registration.Name, Fund_Transition.Amount, Fund_Transition.TransitionDate FROM Fund_Transition_Code INNER JOIN Fund_Transition ON Fund_Transition_Code.Transition_CodeID = Fund_Transition.Transition_CodeID INNER JOIN Registration ON Fund_Transition_Code.Sent_RegistrationID = Registration.RegistrationID WHERE (Fund_Transition_Code.Received_RegistrationID = @Received_RegistrationID)">
        <SelectParameters>
            <asp:SessionParameter Name="Received_RegistrationID" SessionField="RegistrationID" />
        </SelectParameters>
    </asp:SqlDataSource>

        <script>
        $(function () {
            $("#Received").addClass('L_Active');
        });
    </script>
</asp:Content>
