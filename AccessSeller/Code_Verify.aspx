<%@ Page Title="Code Verify" Language="C#" MasterPageFile="~/Seller.Master" AutoEventWireup="true" CodeBehind="Code_Verify.aspx.cs" Inherits="CncAgro.AccessSeller.Code_Verify" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .userinfo ul { margin: 19px 0 0; padding: 0; }
            .userinfo ul li { border-bottom: 1px solid #ddd; font-size: 16px; list-style: outside none none; padding: 10px 0; text-align: center; }
            .userinfo ul li:last-child { border-bottom:none; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Code Verify</h3>
    <asp:FormView ID="M_detailsFormView" runat="server" DataSourceID="Fund_WithdrawSQL" Width="100%" DataKeyNames="Transition_CodeID,Transition_Code,Available_Balance,Sent_RegistrationID,Amount,Phone">
        <ItemTemplate>
            <div class="card userinfo">
                <h4 class="alert alert-success text-center">Send Details</h4>
                <ul>
                    <li>
                        <i class="fa fa-id-card" aria-hidden="true"></i>
                        Userid: <%#Eval("UserName") %>
                    </li>
                    <li>
                        <i class="fa fa-user-circle" aria-hidden="true"></i>
                        <%#Eval("Name") %>
                    </li>
                    <li>
                        <i class="fa fa-phone" aria-hidden="true"></i>
                        <%#Eval("Phone") %>
                    </li>
                    <li>
                        <i class="fa fa-money" aria-hidden="true"></i>
                        Send Amount: <%#Eval("Amount") %> TK.
                    </li>
                    <li>
                        <i class="fa fa-calendar" aria-hidden="true"></i>
                        Send Date: <%#Eval("Insert_Date","{0:d MMM yyyy}") %>
                    </li>
                </ul>
            </div>
        </ItemTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="Fund_WithdrawSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Fund_Transition_Code.Transition_CodeID, Registration.UserName, Registration.Name, Registration.Phone, Fund_Transition_Code.Amount, Fund_Transition_Code.Transition_Code, Fund_Transition_Code.Insert_Date, Member.Available_Balance, Fund_Transition_Code.Sent_RegistrationID, Fund_Transition_Code.Received_RegistrationID FROM Fund_Transition_Code INNER JOIN Registration ON Fund_Transition_Code.Sent_RegistrationID = Registration.RegistrationID INNER JOIN Member ON Registration.RegistrationID = Member.MemberRegistrationID WHERE (Fund_Transition_Code.IS_Used = 0) AND (Fund_Transition_Code.Transition_CodeID = @Transition_CodeID) AND (Fund_Transition_Code.Received_RegistrationID = @Received_RegistrationID)">
        <SelectParameters>
            <asp:QueryStringParameter Name="Transition_CodeID" QueryStringField="id" />
            <asp:SessionParameter Name="Received_RegistrationID" SessionField="RegistrationID" />
        </SelectParameters>
    </asp:SqlDataSource>

    <div class="form-inline">
        <div class="form-group">
            <asp:TextBox ID="CodeTextBox" autocomplete="off" placeholder="Enter code" CssClass="form-control" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ControlToValidate="CodeTextBox" ValidationGroup="1" CssClass="EroorStar" ID="R1" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
        </div>
        <div class="form-group">
            <asp:Label ID="InvalidUserLabel" runat="server" CssClass="EroorStar"></asp:Label>
            <asp:Button ID="ReceiveButton" runat="server" CssClass="btn btn-primary" Text="Receive" ValidationGroup="1" OnClick="ReceiveButton_Click" />
        <asp:SqlDataSource ID="Fund_TransitionSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO Fund_Transition(Sent_RegistrationID, Received_RegistrationID, Amount, Transition_CodeID) VALUES (@Sent_RegistrationID, @Received_RegistrationID, @Amount, @Transition_CodeID)" SelectCommand="SELECT Registration.UserName, Registration.Name, Registration.Phone, Fund_Transition.Amount, Fund_Transition.TransitionDate FROM Fund_Transition INNER JOIN Registration ON Fund_Transition.Received_RegistrationID = Registration.RegistrationID WHERE (Fund_Transition.Sent_RegistrationID = @Sent_RegistrationID) ORDER BY Fund_Transition.TransitionDate DESC" UpdateCommand="UPDATE  Seller SET Received__Balance =Received__Balance + @Amount  WHERE (SellerRegistrationID = @Received_RegistrationID)
UPDATE Member SET Send_Balance = Send_Balance + @Amount  WHERE (MemberRegistrationID = @Sent_RegistrationID)
UPDATE  Fund_Transition_Code SET IS_Used = 1 WHERE (Transition_CodeID = @Transition_CodeID)">
                <InsertParameters>
                    <asp:Parameter Name="Sent_RegistrationID" Type="Int32" />
                    <asp:SessionParameter Name="Received_RegistrationID" SessionField="RegistrationID" Type="Int32" />
                    <asp:Parameter Name="Amount" Type="Double" />
                    <asp:Parameter Name="Transition_CodeID" />
                </InsertParameters>
                <SelectParameters>
                    <asp:SessionParameter Name="Sent_RegistrationID" SessionField="RegistrationID" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="Amount" Type="Double" />
                    <asp:SessionParameter Name="Received_RegistrationID" SessionField="RegistrationID" />
                    <asp:Parameter Name="Sent_RegistrationID" />
                    <asp:Parameter Name="Transition_CodeID" />
                </UpdateParameters>
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
</asp:Content>
