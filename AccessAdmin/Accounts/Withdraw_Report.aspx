<%@ Page Title="Withdraw Report" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Withdraw_Report.aspx.cs" Inherits="CncAgro.AccessAdmin.Accounts.Withdraw_Report" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Withdraw Report</h3>
    <div class="form-inline NoPrint">
        <div class="form-group">
            <asp:TextBox ID="From_TextBox" placeholder="From Date" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" runat="server" CssClass="datepicker form-control"></asp:TextBox>
        </div>
        <div class="form-group mx-2">
            <asp:TextBox ID="TO_TextBox" placeholder="To Date" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" runat="server" CssClass="datepicker form-control"></asp:TextBox>
        </div>
        <div class="form-group">
            <asp:Button ID="FindButton" runat="server" CssClass="btn btn-primary" Text="Find" />
        </div>
    </div>

    <asp:FormView ID="Total_FormView" runat="server" DataSourceID="TotalSQL" Width="100%">
        <ItemTemplate>
            <div class="alert alert-success">
                <span class="Date"></span>
                Total Withdraw: <%#Eval("Total") %> Tk.
            </div>
        </ItemTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="TotalSQL" runat="server" CancelSelectOnNullParameter="False" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT isnull(SUM(Withdraw_Amount),0) AS Total FROM Fund_Withdraw WHERE (CAST(Fund_Withdraw.Withdraw_Date AS DATE) BETWEEN ISNULL(@From_Date, '1-1-1000') AND ISNULL(@To_Date, '1-1-3000'))">
        <SelectParameters>
            <asp:ControlParameter ControlID="From_TextBox" Name="From_Date" PropertyName="Text" />
            <asp:ControlParameter ControlID="TO_TextBox" Name="To_Date" PropertyName="Text" />
        </SelectParameters>
    </asp:SqlDataSource>

    <div class="table-responsive">
        <asp:GridView ID="Withdraw_GridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="WithdrawSQL" AllowPaging="True" AllowSorting="True" PageSize="50">
            <Columns>
                <asp:BoundField DataField="UserName" HeaderText="Cust.Username" SortExpression="UserName" />
                <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                <asp:BoundField DataField="Phone" HeaderText="Phone" SortExpression="Phone" />
                <asp:BoundField DataField="Withdraw_Amount" HeaderText="Withdraw Amount" SortExpression="Withdraw_Amount" />
                <asp:BoundField DataField="Withdraw_Date" HeaderText="Withdraw Date" SortExpression="Withdraw_Date" DataFormatString="{0:d MMM yyyy}" />
                <asp:BoundField DataField="WithdrawBy" HeaderText="Withdraw By " SortExpression="WithdrawBy" />
            </Columns>
            <EmptyDataTemplate>
                No Records
            </EmptyDataTemplate>
            <PagerStyle CssClass="pgr" />
        </asp:GridView>
        <asp:SqlDataSource ID="WithdrawSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.UserName, Registration.Name, Registration.Phone, Fund_Withdraw.Withdraw_Amount, Fund_Withdraw.Withdraw_Date, [Admin Registration].UserName AS WithdrawBy FROM Fund_Withdraw INNER JOIN Registration ON Fund_Withdraw.Withdraw_RegistrationID = Registration.RegistrationID INNER JOIN Registration AS [Admin Registration] ON Fund_Withdraw.Admin_RegistrationID = [Admin Registration].RegistrationID WHERE (CAST(Fund_Withdraw.Withdraw_Date AS DATE) BETWEEN ISNULL(@From_Date, '1-1-1000') AND ISNULL(@To_Date, '1-1-3000'))" CancelSelectOnNullParameter="False">
            <SelectParameters>
                <asp:ControlParameter ControlID="From_TextBox" Name="From_Date" PropertyName="Text" />
                <asp:ControlParameter ControlID="TO_TextBox" Name="To_Date" PropertyName="Text" />
            </SelectParameters>
        </asp:SqlDataSource>

        <%if (Withdraw_GridView.Rows.Count > 0)
            { %>
        <br />
          <button type="button" class="btn btn-primary hidden-print" onclick="window.print();"><span class="glyphicon glyphicon-print"></span> Print</button>
        <%} %>
    </div>


    <script type="text/javascript">
        $(function () {
            $('.datepicker').datepicker({
                format: 'dd M yyyy',
                todayBtn: "linked",
                todayHighlight: true,
                autoclose: true
            });

            //get date in label
            var from = $("[id*=From_TextBox]").val();
            var To = $("[id*=TO_TextBox]").val();

            var tt;
            var Brases1 = "";
            var Brases2 = "";
            var A = "";
            var B = "";
            var TODate = "";

            if (To == "" || from == "" || To == "" && from == "") {
                tt = "";
                A = "";
                B = "";
            }
            else {
                tt = " To ";
                Brases1 = "(";
                Brases2 = ")";
            }

            if (To == "" && from == "") { Brases1 = ""; }

            if (To == from) {
                TODate = "";
                tt = "";
                var Brases1 = "";
                var Brases2 = "";
            }
            else { TODate = To; }

            if (from == "" && To != "") {
                B = " Before ";
            }

            if (To == "" && from != "") {
                A = " After ";
            }

            if (from != "" && To != "") {
                A = "";
                B = "";
            }

            $(".Date").text(Brases1 + B + A + from + tt + TODate + Brases2);
        });

        function isNumberKey(a) { a = a.which ? a.which : event.keyCode; return 46 != a && 31 < a && (48 > a || 57 < a) ? !1 : !0 };

    </script>
</asp:Content>
