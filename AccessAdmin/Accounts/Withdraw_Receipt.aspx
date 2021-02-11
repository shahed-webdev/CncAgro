<%@ Page Title="Withdraw Receipt" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Withdraw_Receipt.aspx.cs" Inherits="CncAgro.AccessAdmin.Accounts.Withdraw_Receipt" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .userinfo ul { margin: 19px 0 0; padding: 0; }
        .userinfo ul li { border-bottom: 1px solid #ddd; font-size: 16px; list-style: outside none none; padding: 10px 0; text-align: center; }
        .userinfo ul li:last-child { border-bottom:none; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3 class="NoPrint">Enter verification Code</h3>
    
    <%if (M_detailsFormView.DataItemCount < 1 || Seller_detailsFormView.DataItemCount < 1)
   {%>
    <div class="alert alert-danger NoPrint">
        Enter verification code you have received in your mobile
    </div>
    <div class="form-inline NoPrint">
        <div class="form-group">
            <asp:TextBox ID="Code_TextBox" placeholder="Enter Code" CssClass="form-control" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="Code_TextBox" CssClass="EroorSummer" ErrorMessage="*" ValidationGroup="V"></asp:RequiredFieldValidator>
        </div>
        <div class="form-group">
            <asp:Button ID="Verify_Button" CssClass="btn btn-primary" runat="server" Text="Verify" OnClick="Verify_Button_Click" ValidationGroup="V" />
            <asp:Label ID="InvalidUserLabel" runat="server" CssClass="EroorStar"></asp:Label>
            <asp:SqlDataSource ID="Fund_WithdrawSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="Add_Admin_Withdraw" SelectCommand="SELECT Registration.UserName, Registration.Name, Registration.Phone, Member.Available_Balance, Fund_Withdraw_Code.Amount, Fund_Withdraw_Code.Insert_Date, Registration.RegistrationID FROM Fund_Withdraw_Code INNER JOIN Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID ON Fund_Withdraw_Code.Withdraw_RegistrationID = Registration.RegistrationID WHERE (Fund_Withdraw_Code.Withdraw_CodeID = @Withdraw_CodeID) AND (Fund_Withdraw_Code.IS_Used = 0)" UpdateCommand="UPDATE Fund_Withdraw_Code SET IS_Used = 1 WHERE (Withdraw_CodeID = @Withdraw_CodeID)" InsertCommandType="StoredProcedure">
                <InsertParameters>
                    <asp:Parameter Name="Withdraw_CodeID" />
                    <asp:SessionParameter Name="Admin_RegistrationID" SessionField="RegistrationID" Type="Int32" />
                </InsertParameters>
                <SelectParameters>
                    <asp:QueryStringParameter Name="Withdraw_CodeID" QueryStringField="Withdraw_CodeID" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="Withdraw_CodeID" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="Seller_SQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.UserName, Registration.Name, Registration.Phone, Seller.Available_Balance, Fund_Withdraw_Code.Amount, Fund_Withdraw_Code.Insert_Date FROM Registration INNER JOIN Seller ON Registration.RegistrationID = Seller.SellerRegistrationID INNER JOIN Fund_Withdraw_Code ON Registration.RegistrationID = Fund_Withdraw_Code.Withdraw_RegistrationID WHERE (Fund_Withdraw_Code.Withdraw_CodeID = @Withdraw_CodeID) AND (Fund_Withdraw_Code.IS_Used = 0)">
                <SelectParameters>
                    <asp:QueryStringParameter Name="Withdraw_CodeID" QueryStringField="Withdraw_CodeID" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
    </div>
    <%} %>

    <asp:FormView ID="M_detailsFormView" runat="server" DataSourceID="Fund_WithdrawSQL" Width="100%">
        <ItemTemplate>
            <div class="card userinfo">
                <h4 class="alert alert-success text-center">Withdrawal Details</h4>
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
                        Withdraw Amount: <%#Eval("Amount") %> TK.
                    </li>
                    <li>
                        <i class="fa fa-money" aria-hidden="true"></i>
                        Available Balance: <%#Eval("Available_Balance") %> TK.
                    </li>

                    <li>
                        <i class="fa fa-calendar" aria-hidden="true"></i>
                        Requested Date: <%#Eval("Insert_Date","{0:d MMM yyyy}") %>
                    </li>
                </ul>

                <br />
                <button type="button" value="Print" onclick="window.print()" class="btn btn-danger NoPrint">Print</button>
            </div>
        </ItemTemplate>
    </asp:FormView>

    <asp:FormView ID="Seller_detailsFormView" runat="server" DataSourceID="Seller_SQL" Width="100%">
        <ItemTemplate>
            <div class="card userinfo">
                <h4 class="alert alert-success text-center">Withdrawal Details</h4>
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
                        Available Balance: <%#Eval("Available_Balance") %> TK.
                    </li>
                    <li>
                        <i class="fa fa-money" aria-hidden="true"></i>
                        Withdraw Amount: <%#Eval("Amount") %> TK.
                    </li>
                    <li>
                        <i class="fa fa-calendar" aria-hidden="true"></i>
                        Withdraw Date: <%#Eval("Insert_Date","{0:d MMM yyyy}") %>
                    </li>
                </ul>

                <br />
                <button type="button" value="Print" onclick="window.print()" class="btn btn-danger NoPrint">Print</button>
            </div>
        </ItemTemplate>
    </asp:FormView>

    <%if (M_detailsFormView.DataItemCount > 0 || Seller_detailsFormView.DataItemCount > 0)
   {%>
    <div class="form-inline">
        <div class="form-group">
            <asp:Button ID="Withdraw_Button" runat="server" Text="Withdraw" CssClass="btn btn-primary" OnClick="Withdraw_Button_Click" />
        </div>
    </div>
    <%} %>
</asp:Content>
