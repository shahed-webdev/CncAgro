<%@ Page Title="Deposit/Withdraw" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Deposit_Withdraw.aspx.cs" Inherits="CncAgro.AccessAdmin.Accounts.Deposit_Withdraw" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <asp:UpdatePanel ID="UpdatePanel3" runat="server">
        <ContentTemplate>
            <asp:FormView ID="ABFormView" runat="server" DataSourceID="ABSQL" Width="100%">
                <ItemTemplate>
                    <h3>
                        <asp:Label ID="AccountNameLabel" runat="server" Text='<%# Bind("AccountName") %>' />
                        (<asp:Label ID="AccountBalanceLabel" runat="server" Text='<%# Bind("AccountBalance") %>' />
                        Tk)</h3>
                </ItemTemplate>
            </asp:FormView>
            <asp:SqlDataSource ID="ABSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT [AccountName], [AccountBalance] FROM [Account] WHERE (([InstitutionID] = @InstitutionID) AND ([AccountID] = @AccountID))">
                <SelectParameters>
                    <asp:SessionParameter Name="InstitutionID" SessionField="InstitutionID" Type="Int32" />
                    <asp:QueryStringParameter Name="AccountID" QueryStringField="AccountID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            <a href="Add_Account.aspx"><< Back To Account</a>
        </ContentTemplate>
    </asp:UpdatePanel>

    <div class="modal-header">
        <ul class="nav panel-tabs">
            <li class="active"><a data-toggle="tab" href="#Deposit">Deposit</a></li>
            <li><a data-toggle="tab" href="#Withdraw">Withdraw</a></li>
        </ul>
    </div>

    <div class="tab-content">
        <div id="Deposit" class="card tab-pane active">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div class="form-inline">
                        <div class="form-group">
                            <asp:TextBox ID="AccountIN_AmountTextBox" placeholder="Enter Deposit Amount" runat="server" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="AccountIN_AmountTextBox" CssClass="EroorSummer" ErrorMessage="*" ValidationGroup="D"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="IN_DetailsTextBox" placeholder="Enter Details" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="IN_ChequeTextBox" placeholder="Cheque No." runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="IN_Date_TextBox" placeholder="Deposit Date" runat="server" CssClass="form-control Datetime"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="IN_Date_TextBox" CssClass="EroorSummer" ErrorMessage="*" ValidationGroup="D"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group">
                            <asp:Button ID="DepositButton" runat="server" Text="Deposit" CssClass="btn btn-primary" OnClick="DepositButton_Click" ValidationGroup="D" />
                            <asp:Label ID="DELabel" runat="server" CssClass="EroorSummer"></asp:Label>
                        </div>
                    </div>

                    <asp:GridView ID="DepositGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataKeyNames="AccountIN_ID" DataSourceID="DepositSQL">
                        <Columns>
                            <asp:BoundField DataField="AccountIN_Amount" HeaderText="Deposit Amount" SortExpression="AccountIN_Amount" />
                            <asp:BoundField DataField="IN_Details" HeaderText="Details" SortExpression="IN_Details" />
                            <asp:BoundField DataField="IN_Cheque_No" HeaderText="Cheque No." SortExpression="IN_Cheque_No" />
                            <asp:BoundField DataField="AccountIN_Date" HeaderText="Deposit Date" SortExpression="AccountIN_Date" DataFormatString="{0:d MMM yyyy}" />
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="DepositSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>"
                        InsertCommand="INSERT INTO AccountIN_Record(AccountID, InstitutionID, RegistrationID, AccountIN_Amount, IN_Details, IN_Cheque_No, AccountIN_Date) VALUES (@AccountID, @InstitutionID, @RegistrationID, @AccountIN_Amount, @IN_Details, @IN_Cheque_No, @AccountIN_Date)"
                        SelectCommand="SELECT * FROM AccountIN_Record WHERE (InstitutionID = @InstitutionID) AND (AccountID = @AccountID)">

                        <InsertParameters>
                            <asp:QueryStringParameter Name="AccountID" QueryStringField="AccountID" Type="Int32" />
                            <asp:SessionParameter Name="InstitutionID" SessionField="InstitutionID" Type="Int32" />
                            <asp:SessionParameter Name="RegistrationID" SessionField="RegistrationID" Type="Int32" />
                            <asp:ControlParameter ControlID="AccountIN_AmountTextBox" Name="AccountIN_Amount" PropertyName="Text" Type="Double" />
                            <asp:ControlParameter ControlID="IN_DetailsTextBox" Name="IN_Details" PropertyName="Text" Type="String" />
                            <asp:ControlParameter ControlID="IN_ChequeTextBox" Name="IN_Cheque_No" PropertyName="Text" />
                            <asp:ControlParameter ControlID="IN_Date_TextBox" Name="AccountIN_Date" PropertyName="Text" />
                        </InsertParameters>
                        <SelectParameters>
                            <asp:SessionParameter Name="InstitutionID" SessionField="InstitutionID" Type="Int32" />
                            <asp:QueryStringParameter Name="AccountID" QueryStringField="AccountID" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        <div id="Withdraw" class="card tab-pane">
            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                <ContentTemplate>
                    <div class="form-inline">
                        <div class="form-group">
                            <asp:TextBox ID="AccountOUT_AmountTextBox" placeholder="Enter Withdraw Amount" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" runat="server" CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="AccountOUT_AmountTextBox" CssClass="EroorSummer" ErrorMessage="*" ValidationGroup="W"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="Out_DetailsTextBox" placeholder="Details" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="OUT_Cheque_TextBox" placeholder="Cheque No." runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="OUT_Date_TextBox" placeholder="Deposit Date" runat="server" CssClass="form-control Datetime"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="OUT_Date_TextBox" CssClass="EroorSummer" ErrorMessage="*" ValidationGroup="W"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group">
                            <asp:Button ID="WithdrawButton" runat="server" Text="Withdraw" CssClass="btn btn-primary" OnClick="WithdrawButton_Click" ValidationGroup="W" />
                            <asp:Label ID="WELabel" runat="server" CssClass="EroorSummer"></asp:Label>
                        </div>
                    </div>

                    <asp:GridView ID="WithdrawGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataKeyNames="AccountOUT_ID" DataSourceID="WithdrawSQL">
                        <Columns>
                            <asp:BoundField DataField="AccountOUT_Amount" HeaderText="Withdraw Amount" SortExpression="AccountOUT_Amount" />
                            <asp:BoundField DataField="Out_Details" HeaderText="Details" SortExpression="Out_Details" />
                            <asp:BoundField DataField="OUT_Cheque_No" HeaderText="Cheque No." SortExpression="OUT_Cheque_No" />
                            <asp:BoundField DataField="AccountOUT_Date" HeaderText="Withdraw Date" SortExpression="AccountOUT_Date" DataFormatString="{0:d MMM yyyy}" />
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="WithdrawSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>"
                        InsertCommand="INSERT INTO AccountOUT_Record(AccountID, InstitutionID, RegistrationID, AccountOUT_Amount, Out_Details, OUT_Cheque_No, AccountOUT_Date) VALUES (@AccountID, @InstitutionID, @RegistrationID, @AccountOUT_Amount, @Out_Details, @OUT_Cheque_No, @AccountOUT_Date)"
                        SelectCommand="SELECT * FROM AccountOUT_Record WHERE (InstitutionID = @InstitutionID) AND (AccountID = @AccountID)">
                        <InsertParameters>
                            <asp:QueryStringParameter Name="AccountID" QueryStringField="AccountID" Type="Int32" />
                            <asp:SessionParameter Name="InstitutionID" SessionField="InstitutionID" Type="Int32" />
                            <asp:SessionParameter Name="RegistrationID" SessionField="RegistrationID" Type="Int32" />
                            <asp:ControlParameter ControlID="AccountOUT_AmountTextBox" Name="AccountOUT_Amount" PropertyName="Text" Type="Double" />
                            <asp:ControlParameter ControlID="Out_DetailsTextBox" Name="Out_Details" PropertyName="Text" Type="String" />
                            <asp:ControlParameter ControlID="OUT_Cheque_TextBox" Name="OUT_Cheque_No" PropertyName="Text" />
                            <asp:ControlParameter ControlID="OUT_Date_TextBox" Name="AccountOUT_Date" PropertyName="Text" />
                        </InsertParameters>
                        <SelectParameters>
                            <asp:SessionParameter Name="InstitutionID" SessionField="InstitutionID" Type="Int32" />
                            <asp:QueryStringParameter Name="AccountID" QueryStringField="AccountID" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>


    <asp:UpdateProgress ID="UpdateProgress" runat="server">
        <ProgressTemplate>
            <div id="progress_BG"></div>
            <div id="progress">
                <img src="../../CSS/Image/loading.gif" alt="Loading..." />
                <br />
                <b>Loading...</b>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>


    <script type="text/javascript">
        $(function () {
            $('.Datetime').datepicker({
                format: 'dd M yyyy',
                todayBtn: "linked",
                todayHighlight: true,
                autoclose: true
            });
        });

        //For Update Pannel
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (a, b) {
            $('.Datetime').datepicker({
                format: 'dd M yyyy',
                todayBtn: "linked",
                todayHighlight: true,
                autoclose: true
            });
        });

        function isNumberKey(a) { a = a.which ? a.which : event.keyCode; return 46 != a && 31 < a && (48 > a || 57 < a) ? !1 : !0 };
    </script>
</asp:Content>
