<%@ Page Title="Withdraw Balance" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Withdraw_Balance.aspx.cs" Inherits="CncAgro.AccessAdmin.Accounts.Withdraw_Balance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .img { width: 90px; height: 90px; border: 1px solid #f5f5f5; }
        .userinfo ul { margin: 13px 0 0; padding: 0; }
        .userinfo ul li { border-bottom: 1px solid #ddd; font-size: 16px; list-style: outside none none; padding: 10px 0; text-align: center; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Withdraw Balance</h3>

    <div class="row">
        <div class="col-md-6 col-sm-6">
            <div class="well">
                <div class="form-group">
                    <label>
                        User ID
                       <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="UserIDTextBox" CssClass="EroorStar" ErrorMessage="Required" ValidationGroup="1"></asp:RequiredFieldValidator>
                    </label>

                    <div class="form-inline">
                        <div class="form-group">
                            <asp:TextBox ID="UserIDTextBox" placeholder="User id" autocomplete="off" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:Button ID="FIndButton" runat="server" CssClass="btn btn-primary" Text="Find User" OnClick="FIndButton_Click" />
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label>
                        Withdraw Amount
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="WithdrawAmountTextBox" CssClass="Error" ErrorMessage="Required" ValidationGroup="1"></asp:RequiredFieldValidator>
                    </label>

                    <asp:TextBox ID="WithdrawAmountTextBox" placeholder="Withdraw Amount" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" runat="server" CssClass="form-control"></asp:TextBox>
                </div>

                <div class="alert alert-info">Customer Will get a text message with verification code.</div>
                <div class="form-group">
                    <%if (M_detailsFormView.DataItemCount > 0)
                        { %>
                    <asp:Button ID="SendCode_Button" runat="server" CssClass="btn btn-primary" OnClick="SendCode_Button_Click" Text="Send Code" ValidationGroup="1" />
                    <asp:Label ID="ErorLabel" runat="server" CssClass="EroorStar"></asp:Label>
                    <asp:SqlDataSource ID="W_Code_SQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO Fund_Withdraw_Code(Admin_RegistrationID, Withdraw_RegistrationID, Transition_Code, Amount) VALUES (@Admin_RegistrationID, @Withdraw_RegistrationID, @Transition_Code, @Amount)" SelectCommand="SELECT * FROM Fund_Withdraw_Code">
                        <InsertParameters>
                            <asp:SessionParameter Name="Admin_RegistrationID" SessionField="RegistrationID" />
                            <asp:ControlParameter ControlID="WithdrawAmountTextBox" Name="Amount" PropertyName="Text" />
                            <asp:Parameter Name="Withdraw_RegistrationID" />
                            <asp:Parameter Name="Transition_Code" />
                        </InsertParameters>
                    </asp:SqlDataSource>
                    <asp:SqlDataSource ID="SMS_OtherInfoSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO SMS_OtherInfo(SMS_Send_ID, RegistrationID, SMS_NumberID) VALUES (@SMS_Send_ID, @RegistrationID, @SMS_NumberID)" SelectCommand="SELECT * FROM [SMS_OtherInfo]">
                        <InsertParameters>
                            <asp:SessionParameter Name="RegistrationID" SessionField="RegistrationID" Type="Int32" />
                            <asp:SessionParameter Name="MemberID" SessionField="MemberID" Type="Int32" />
                            <asp:Parameter Name="SMS_Send_ID" />
                            <asp:Parameter Name="SMS_NumberID" />
                        </InsertParameters>
                    </asp:SqlDataSource>
                    <%} %>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-sm-6">
            <asp:FormView ID="M_detailsFormView" DataKeyNames="RegistrationID,Category,Is_Identified,Available_Balance,Phone" runat="server" DataSourceID="MemberDetailsSQL" Width="100%" OnDataBound="M_detailsFormView_DataBound">
                <ItemTemplate>
                    <div class="well userinfo">
                        <img alt="" src="/Handler/UserPhoto.ashx?id=<%# Eval("RegistrationID") %>" class="img-responsive img-circle img" />
                        <ul>
                            <li>
                                <i class="fa fa-id-card" aria-hidden="true"></i>
                                Userid: <%#Eval("UserName") %>
                            </li>
                            <li>
                                <i class="fa fa-user-circle" aria-hidden="true"></i>
                                <%#Eval("Name") %>
                                (<%#Eval("Category") %>)
                            </li>
                            <li>
                                <i class="fa fa-phone" aria-hidden="true"></i>
                                <%#Eval("Phone") %>
                            </li>
                            <li>
                                <strong>
                                    <i class="fa fa-money" aria-hidden="true"></i>
                                    Available Balance:
                                    <asp:Label ID="Available_BalanceLabel" runat="server" Text='<%#Eval("Available_Balance") %>'></asp:Label>
                                    TK
                                </strong>
                            </li>
                        </ul>
                    </div>
                </ItemTemplate>
            </asp:FormView>
            <asp:SqlDataSource ID="MemberDetailsSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="Add_Account_Details" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="UserIDTextBox" Name="UserName" PropertyName="Text" Type="String" />
                    <asp:SessionParameter Name="RegistrationID" SessionField="RegistrationID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
    </div>

    <div class="table-responsive">
        <div class="alert alert-success">
            Withdraw Record
        </div>

        <asp:GridView ID="Withdraw_GridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="WithdrawSQL" AllowPaging="True" AllowSorting="True" PageSize="50">
            <Columns>
                <asp:BoundField DataField="UserName" HeaderText="Username" SortExpression="UserName" />
                <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                <asp:BoundField DataField="Phone" HeaderText="Phone" SortExpression="Phone" />
                <asp:BoundField DataField="Withdraw_Amount" HeaderText="Withdraw Amount" SortExpression="Withdraw_Amount" />
                <asp:BoundField DataField="Withdraw_Date" HeaderText="Withdraw Date" SortExpression="Withdraw_Date" DataFormatString="{0:d MMM yyyy}" />
            </Columns>
            <EmptyDataTemplate>
                Empty
            </EmptyDataTemplate>
            <PagerStyle CssClass="pgr" />
        </asp:GridView>
        <asp:SqlDataSource ID="WithdrawSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.UserName, Registration.Name, Registration.Phone, Fund_Withdraw.Withdraw_Amount, Fund_Withdraw.Withdraw_Date FROM Fund_Withdraw INNER JOIN Registration ON Fund_Withdraw.Withdraw_RegistrationID = Registration.RegistrationID WHERE (Fund_Withdraw.Admin_RegistrationID = @Admin_RegistrationID) ORDER BY Fund_Withdraw.Withdraw_Date DESC">
            <SelectParameters>
                <asp:SessionParameter Name="Admin_RegistrationID" SessionField="RegistrationID" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>

    <script>
        //Autocomplete
        $(function () {
            $('[id*=UserIDTextBox]').typeahead({
                minLength: 2,
                source: function (request, result) {
                    $.ajax({
                        url: "Withdraw_Balance.aspx/Get_User",
                        data: JSON.stringify({ 'prefix': request }),
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (response) {
                            result($.map(JSON.parse(response.d), function (item) {
                                return item;
                            }));
                        }
                    });
                }
            });

            //Withdraw Amount TextBox
            $("[id*=WithdrawAmountTextBox]").on('keyup', function () {
                const Available = parseFloat($("[id*=Available_BalanceLabel]").text());
                const Send = parseFloat($("[id*=WithdrawAmountTextBox]").val());

                if ($("[id*=WithdrawAmountTextBox]").val() !== "") {
                    Available >= Send ? ($("[id*=WithDrawButton]").prop("disabled", false).addClass("btn btn-primary"), $("[id*=ErorLabel]").text("")) : ($("[id*=WithDrawButton]").prop("disabled", true).removeClass("btn btn-primary"), $("[id*=ErorLabel]").text("Withdraw Amount greater than available balance"));
                }
            });
        });

        function isNumberKey(a) { a = a.which ? a.which : event.keyCode; return 46 != a && 31 < a && (48 > a || 57 < a) ? !1 : !0 };
    </script>
</asp:Content>
