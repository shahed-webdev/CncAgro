<%@ Page Title="Send SMS" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Send_SMS.aspx.cs" Inherits="CncAgro.AccessAdmin.SMS.Send_SMS" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
       <asp:FormView ID="SMSFormView" runat="server" DataSourceID="SMSSQL" Width="100%" CssClass="NoPrint">
      <ItemTemplate>
         <h3>Send SMS <small>(Remaining SMS: <%# Eval("SMS_Balance") %>)</small></h3>
      </ItemTemplate>
   </asp:FormView>
   <asp:SqlDataSource ID="SMSSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT SMS_Balance FROM Institution" ProviderName="<%$ ConnectionStrings:DBConnectionString.ProviderName %>">
   </asp:SqlDataSource>

    <div class="col-md-6 card">
    <div class="form-group">
        <label>Phone Number
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Required" ControlToValidate="Phone_TextBox" CssClass="EroorStar" ValidationGroup="1"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="Phone_TextBox" CssClass="EroorStar" ErrorMessage="Invalid Mobile No. " ValidationExpression="(88)?((011)|(015)|(016)|(017)|(018)|(019))\d{8,8}" ValidationGroup="1"></asp:RegularExpressionValidator>
        </label>
        <asp:TextBox ID="Phone_TextBox" CssClass="form-control" runat="server"></asp:TextBox>
    </div>
    <div class="form-group">
         <label>SMS Text<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Required" ControlToValidate="Text_TextBox" CssClass="EroorStar" ValidationGroup="1"></asp:RequiredFieldValidator>
         </label>
        &nbsp;<asp:TextBox ID="Text_TextBox" CssClass="form-control" runat="server" TextMode="MultiLine"></asp:TextBox>
    </div>
    <div class="form-group">
        <asp:Button ID="SendButton" CssClass="btn btn-primary" runat="server" Text="Send SMS" OnClick="SendButton_Click" ValidationGroup="1" />
            <asp:SqlDataSource ID="SMS_OtherInfoSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO SMS_OtherInfo(SMS_Send_ID, RegistrationID) VALUES (@SMS_Send_ID, @RegistrationID)" SelectCommand="SELECT * FROM [SMS_OtherInfo]">
                <InsertParameters>
                    <asp:SessionParameter Name="RegistrationID" SessionField="RegistrationID" Type="Int32" />
                    <asp:Parameter Name="SMS_Send_ID" DbType="Guid" />
                </InsertParameters>
            </asp:SqlDataSource>
    </div></div>
</asp:Content>
