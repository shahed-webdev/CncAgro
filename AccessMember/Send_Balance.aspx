<%@ Page Title="Balance Transfer" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Send_Balance.aspx.cs" Inherits="CncAgro.AccessMember.Send_Balance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Send_Balance.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <asp:FormView ID="ABFormView" runat="server" DataSourceID="AvilAbleBalanceSQL" DataKeyNames="Available_Balance,Is_Identified,Phone" OnDataBound="ABFormView_DataBound" Width="100%">
        <ItemTemplate>
            <h3>
                <i class="fa fa-paper-plane-o" aria-hidden="true"></i>
                Balance Transfer<br />
                <small class="Available_amt">
                    <i class="fa fa-money" aria-hidden="true"></i>
                    Available  Balance:
                    <asp:Label ID="Available_BalanceLabel" runat="server" Text='<%#Eval("Available_Balance","{0:N}") %>' />
                    <asp:HiddenField ID="AvailableBlnc_HF" runat="server" Value='<%#Eval("Available_Balance") %>' />
                    Tk
                </small>
            </h3>
        </ItemTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="AvilAbleBalanceSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Member.Available_Balance, Member.Is_Identified, Registration.Phone FROM Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE (Member.MemberID = @MemberID)">
        <SelectParameters>
            <asp:SessionParameter Name="MemberID" SessionField="MemberID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <div class="col-md-6 card card-body mb-3">
        <div class="form-group">
            <label>
                Recipient ID
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="MemberUserNameTextBox" CssClass="EroorStar" ErrorMessage="Required" ValidationGroup="1"></asp:RequiredFieldValidator>
            </label>
            <asp:TextBox ID="MemberUserNameTextBox" placeholder="Customer id" autocomplete="off" runat="server" CssClass="form-control"></asp:TextBox>
        </div>

        <div id="user-info" class="alert-success">
            <div class="userid">
                <i class="fa fa-user-circle"></i>
                <label id="MemberNameLabel"></label>

                <i class="fa fa-user-circle"></i>
                <label id="UserCategory"></label>

                <i class="fa fa-phone-square"></i>
                <label id="MemberPhoneLabel"></label>

                <asp:HiddenField ID="Receiver_RegistrationID_HF" runat="server" />
                <asp:HiddenField ID="CategoryHF" runat="server" />
            </div>
        </div>

        <div class="form-group">
            <label>
                Transfer Amount
            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="Send_Amount_TextBox" CssClass="EroorStar" ErrorMessage="Required" ValidationGroup="1"></asp:RequiredFieldValidator>
            </label>
            <asp:TextBox ID="Send_Amount_TextBox" placeholder="Transfer Amount" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" runat="server" CssClass="form-control"></asp:TextBox>
        </div>
        <div class="alert alert-info">You'll get a text message with your verification code.</div>
        <div class="form-group">
            <asp:Button ID="Send_Button" runat="server" Text="Send" CssClass="btn btn-primary" ValidationGroup="1" OnClick="Send_Button_Click" />
            <a data-toggle="modal" data-target="#myModal">I have code</a>
            <asp:Label ID="ErorLabel" runat="server" CssClass="EroorStar"></asp:Label>

            <asp:SqlDataSource ID="Fund_TransitionSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO Fund_Transition(Sent_RegistrationID, Received_RegistrationID, Amount, Transition_CodeID) VALUES (@Sent_RegistrationID, @Received_RegistrationID, @Amount, @Transition_CodeID)" SelectCommand="SELECT Registration.UserName, Registration.Name, Registration.Phone, Fund_Transition.Amount, Fund_Transition.TransitionDate FROM Fund_Transition INNER JOIN Registration ON Fund_Transition.Received_RegistrationID = Registration.RegistrationID WHERE (Fund_Transition.Sent_RegistrationID = @Sent_RegistrationID) ORDER BY Fund_Transition.TransitionDate DESC" UpdateCommand="IF(@Category='Member')
UPDATE Member SET Received__Balance = Received__Balance + @Amount  WHERE (MemberRegistrationID = @Received_RegistrationID)
ELSE
UPDATE  Seller SET Received__Balance =Received__Balance + @Amount  WHERE (SellerRegistrationID = @Received_RegistrationID)

UPDATE Member SET Send_Balance = Send_Balance + @Amount  WHERE (MemberRegistrationID = @send_RegistrationID)
UPDATE  Fund_Transition_Code SET IS_Used = 1 WHERE (Transition_CodeID = @Transition_CodeID)">
                <InsertParameters>
                    <asp:SessionParameter Name="Sent_RegistrationID" SessionField="RegistrationID" Type="Int32" />
                    <asp:Parameter Name="Received_RegistrationID" Type="Int32" />
                    <asp:Parameter Name="Amount" Type="Double" />
                    <asp:Parameter Name="Transition_CodeID" />
                </InsertParameters>
                <SelectParameters>
                    <asp:SessionParameter Name="Sent_RegistrationID" SessionField="RegistrationID" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:SessionParameter Name="send_RegistrationID" SessionField="RegistrationID" Type="Int32" />
                    <asp:ControlParameter ControlID="CategoryHF" Name="Category" PropertyName="Value" />
                    <asp:Parameter Name="Received_RegistrationID" />
                    <asp:Parameter Name="Transition_CodeID" />
                    <asp:Parameter Name="Amount" Type="Double" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="T_Code_SQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO Fund_Transition_Code (Sent_RegistrationID, Received_RegistrationID, Amount, Transition_Code) VALUES (@Sent_RegistrationID, @Received_RegistrationID, @Amount, @Transition_Code)" SelectCommand="SELECT * FROM Fund_Transition_Code">
                <InsertParameters>
                    <asp:SessionParameter Name="Sent_RegistrationID" SessionField="RegistrationID" />
                    <asp:ControlParameter ControlID="Receiver_RegistrationID_HF" Name="Received_RegistrationID" PropertyName="Value" />
                    <asp:ControlParameter ControlID="Send_Amount_TextBox" Name="Amount" PropertyName="Text" />
                    <asp:Parameter Name="Transition_Code" />
                </InsertParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="SMS_OtherInfoSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO SMS_OtherInfo(SMS_Send_ID, MemberID, RegistrationID) VALUES (@SMS_Send_ID, @MemberID, @RegistrationID)" SelectCommand="SELECT * FROM [SMS_OtherInfo]">
                <InsertParameters>
                    <asp:SessionParameter Name="RegistrationID" SessionField="RegistrationID" Type="Int32" />
                    <asp:SessionParameter Name="MemberID" SessionField="MemberID" Type="Int32" />
                    <asp:Parameter Name="SMS_Send_ID" DbType="Guid" />
                </InsertParameters>
            </asp:SqlDataSource>
        </div>
    </div>

    <div class="clearfix"></div>
    <div class="table-responsive">
        <label>Transfer Records</label>
        <asp:GridView ID="Fund_TransitionGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="Fund_TransitionSQL" AllowPaging="True" AllowSorting="True" PageSize="50">
            <Columns>
                <asp:BoundField DataField="UserName" HeaderText="Recipient User ID" SortExpression="UserName" />
                <asp:BoundField DataField="Name" HeaderText="Recipient Name" SortExpression="Name" />
                <asp:BoundField DataField="Phone" HeaderText="Recipient Phone" SortExpression="Phone" />
                <asp:BoundField DataField="Amount" HeaderText="Sent Amount" SortExpression="Amount" />
                <asp:BoundField DataField="TransitionDate" HeaderText="Sent Date" SortExpression="TransitionDate" />
            </Columns>
            <EmptyDataTemplate>
                Empty
            </EmptyDataTemplate>
            <PagerStyle CssClass="pgr" />
        </asp:GridView>
    </div>


    <!-- Modal -->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
        aria-hidden="true">
        <div class="modal-dialog modal-notify modal-primary" role="document">
            <div class="modal-content">
                <div class="modal-header text-center">
                    <h4 class="modal-title white-text w-100 font-weight-bold py-2">Enter verification Code</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true" class="white-text">&times;</span>
                    </button>
                </div>

                <div class="modal-body">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <div class="alert alert-danger">
                                Enter verification code you have received in your mobile
                            </div>
                            <div class="form-inline">
                                <div class="form-group">
                                    <asp:TextBox ID="Code_TextBox" placeholder="Enter Code" CssClass="form-control" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="Code_TextBox" CssClass="EroorSummer" ErrorMessage="*" ValidationGroup="V"></asp:RequiredFieldValidator>
                                </div>
                                <div class="form-group">
                                    <asp:Button ID="Verify_Button" CssClass="btn btn-primary" runat="server" Text="Verify" OnClick="Verify_Button_Click" ValidationGroup="V" />
                                    <asp:Label ID="InvalidUserLabel" runat="server" CssClass="EroorStar"></asp:Label>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
    

    <script>
        //Get Member UserName
        $(function () {
            $("#Send_B").addClass('L_Active');

            $('[id*=MemberUserNameTextBox]').typeahead({
                minLength: 4,
                source: function (request, result) {
                    $.ajax({
                        url: "Send_Balance.aspx/GetCustomers",
                        data: JSON.stringify({ 'prefix': request }),
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (response) {
                            label = [];
                            map = {};
                            $.map(JSON.parse(response.d), function (item) {
                                label.push(item.Username);
                                map[item.Username] = item;
                            });
                            result(label);
                        }
                    });
                },
                updater: function (item) {
                    $("#user-info").css("display", "block");
                    $("#MemberNameLabel").text(map[item].Name);
                    $("#MemberPhoneLabel").text(map[item].Phone);
                    $("#UserCategory").text(map[item].Category);

                    $("[id$=Receiver_RegistrationID_HF]").val(map[item].RegID);
                    $("[id$=CategoryHF]").val(map[item].Category);
                    return item;
                }
            });

            //Member UserName TextBox
            $("[id*=MemberUserNameTextBox]").on('keyup', function () {
                $("#MemberNameLabel").text('');
                $("#MemberPhoneLabel").text('');
                $("#UserCategory").text('');

                $("[id$=Receiver_RegistrationID_HF]").val('');
                $("[id$=CategoryHF]").val('');
                $("#user-info").css("display", "none");
            });

            //Send_Amount_TextBox
            $("[id*=Send_Amount_TextBox]").on('keyup', function () {
                var Available = parseFloat($("[id*=AvailableBlnc_HF]").val());
                var Send = parseFloat($("[id*=Send_Amount_TextBox]").val());

                if ($("[id*=Send_Amount_TextBox]").val() != "") {
                    Available >= Send ? ($("[id*=Send_Button]").prop("disabled", !1).addClass("btn btn-primary"), $("[id*=ErorLabel]").text("")) : ($("[id*=Send_Button]").prop("disabled", !0).removeClass("btn btn-primary"), $("[id*=ErorLabel]").text("Send Amount greater than available balance"));
                }
            });
        });

        function openModal() { $('#myModal').modal('show'); }

        function isNumberKey(a) { a = a.which ? a.which : event.keyCode; return 46 != a && 31 < a && (48 > a || 57 < a) ? !1 : !0 };
    </script>
</asp:Content>
