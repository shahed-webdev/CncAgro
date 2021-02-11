<%@ Page Title="Withdraw" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Withdraw_Balance.aspx.cs" Inherits="CncAgro.AccessMember.Withdraw_Balance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <asp:FormView ID="ABFormView" runat="server" DataSourceID="AvilAbleBalanceSQL" DataKeyNames="Available_Balance,Is_Identified,Phone" OnDataBound="ABFormView_DataBound" Width="100%">
        <ItemTemplate>
            <h3>
                <i class="fa fa-paper-plane-o" aria-hidden="true"></i>
                Withdraw Request<br />
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
    
    <div class="alert alert-info">You'll get a text message with your verification code.</div>
    <div class="form-inline">
        <div class="form-group">
            <asp:TextBox ID="Amount_TextBox" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" CssClass="form-control" placeholder="Withdraw Amount" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*" ControlToValidate="Amount_TextBox" CssClass="EroorStar" ValidationGroup="1"></asp:RequiredFieldValidator>
        </div>
        <div class="form-group">
            <asp:Button ID="Withdraw_Button" CssClass="btn btn-primary" runat="server" Text="Withdraw" OnClick="Withdraw_Button_Click" ValidationGroup="1" />
            <asp:SqlDataSource ID="W_Code_SQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO Fund_Withdraw_Code( Withdraw_RegistrationID, Transition_Code, Amount) VALUES (@Withdraw_RegistrationID, @Transition_Code, @Amount)" SelectCommand="SELECT * FROM Fund_Withdraw_Code">
                <InsertParameters>
                    <asp:SessionParameter Name="Withdraw_RegistrationID" SessionField="RegistrationID" />
                    <asp:ControlParameter ControlID="Amount_TextBox" Name="Amount" PropertyName="Text" />
                    <asp:Parameter Name="Transition_Code" />
                </InsertParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="SMS_OtherInfoSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO SMS_OtherInfo(SMS_Send_ID, RegistrationID, SMS_NumberID) VALUES (@SMS_Send_ID, @RegistrationID, @SMS_NumberID)" SelectCommand="SELECT * FROM [SMS_OtherInfo]">
                <InsertParameters>
                    <asp:SessionParameter Name="RegistrationID" SessionField="RegistrationID" Type="Int32" />
                    <asp:SessionParameter Name="MemberID" SessionField="MemberID" Type="Int32" />
                    <asp:SessionParameter Name="SMS_NumberID" SessionField="RegistrationID" />
                    <asp:Parameter Name="SMS_Send_ID" />
                </InsertParameters>
            </asp:SqlDataSource>
            <asp:Label ID="ErorLabel" runat="server" CssClass="EroorStar"></asp:Label>
        </div>
    </div>

    <script>
        $(function () {
            $("#Withdraw").addClass('L_Active');

            //Send_Amount_TextBox
            $("[id*=Amount_TextBox]").on('keyup', function () {
                var Available = parseFloat($("[id*=AvailableBlnc_HF]").val());
                var Send = parseFloat($("[id*=Amount_TextBox]").val().trim());

                if (Send != "" && send != 0) {
                    Available >= Send ? ($("[id*=Withdraw_Button]").prop("disabled", !1), $("[id*=ErorLabel]").text("")) : ($("[id*=Withdraw_Button]").prop("disabled", !0), $("[id*=ErorLabel]").text("Withdraw Amount greater than available balance and requested amount"));
                }
            });
        });
        function isNumberKey(a) { a = a.which ? a.which : event.keyCode; return 46 != a && 31 < a && (48 > a || 57 < a) ? !1 : !0 };
    </script>
</asp:Content>
