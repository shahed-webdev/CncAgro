<%@ Page Title="Requested Withdrawal List" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Requested_Withdraw_List.aspx.cs" Inherits="CncAgro.AccessAdmin.Accounts.Requested_Withdraw_List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Requested Withdrawal List</h3>
    <div class="form-inline">
        <div class="form-group">
            <asp:TextBox ID="Find_TextBox" CssClass="form-control" placeholder="User Id, Name" runat="server"></asp:TextBox>
        </div>
        <div class="form-group">
            <asp:Button ID="Find_Button" CssClass="btn btn-primary" runat="server" Text="Find" />
        </div>
    </div>

    <div class="alert alert-success">
        <h4 id="Total" style="margin-bottom:0"></h4>
    </div>

    <div class="table-responsive">
        <asp:GridView ID="WithdrawGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataKeyNames="Withdraw_CodeID" DataSourceID="Withdraw_ListSQL" AllowSorting="True">
            <Columns>
                <asp:TemplateField HeaderText="Delete" ShowHeader="False">
                    <ItemTemplate>
                        <asp:Button ID="DeleteButton" runat="server" CausesValidation="False" CssClass="btn btn-danger" OnClientClick="return confirm('Are you sure want to delete?')" CommandName="Delete" Text="Delete"></asp:Button>
                    </ItemTemplate>
                     <ItemStyle Width="50px" />
                </asp:TemplateField>
                <asp:BoundField DataField="UserName" HeaderText="User Id" SortExpression="UserName" />
                <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                <asp:BoundField DataField="Phone" HeaderText="Phone" SortExpression="Phone" />
                <asp:TemplateField HeaderText="Amount" SortExpression="Amount">
                    <ItemTemplate>
                        <asp:Label ID="Amount_Label" runat="server" Text='<%# Bind("Amount") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Insert_Date" DataFormatString="{0:d MMM yyyy}" HeaderText="Requested Date" SortExpression="Insert_Date" />
                <asp:TemplateField HeaderText="Pay">
                    <ItemTemplate>
                        <asp:Button ID="PayButton" CssClass="btn btn-success" PostBackUrl="Withdraw_Receipt.aspx" runat="server" Text="Pay" />
                    </ItemTemplate>
                    <ItemStyle Width="50px" />
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                No Records
            </EmptyDataTemplate>
        </asp:GridView>
        <asp:SqlDataSource ID="Withdraw_ListSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Fund_Withdraw_Code.Withdraw_CodeID, Registration.UserName, Registration.Name, Registration.Phone, Fund_Withdraw_Code.Amount, Fund_Withdraw_Code.Insert_Date,Fund_Withdraw_Code.IS_Used FROM Fund_Withdraw_Code INNER JOIN Registration ON Fund_Withdraw_Code.Withdraw_RegistrationID = Registration.RegistrationID WHERE (Fund_Withdraw_Code.IS_Used = 0)"
            FilterExpression="UserName like '%{0}%' OR Name like '%{0}%'" DeleteCommand="DELETE FROM Fund_Withdraw_Code WHERE (Withdraw_CodeID = @Withdraw_CodeID)">
            <DeleteParameters>
                <asp:Parameter Name="Withdraw_CodeID" />
            </DeleteParameters>
            <FilterParameters>
                <asp:ControlParameter ControlID="Find_TextBox" Name="find" PropertyName="Text" />
            </FilterParameters>
        </asp:SqlDataSource>
    </div>

    <script>
        $(function () {
            var grandTotal = 0;
            $("[id*=Amount_Label]").each(function () {
                grandTotal = grandTotal + parseFloat($(this).html());
            });
            $("#Total").html("Total: "+grandTotal.toString() +" Tk");
        });
    </script>
</asp:Content>
