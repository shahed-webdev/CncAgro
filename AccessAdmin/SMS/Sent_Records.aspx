<%@ Page Title="Sent Record" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Sent_Records.aspx.cs" Inherits="CncAgro.AccessAdmin.SMS.Sent_Records" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
     <asp:FormView ID="SMSFormView" runat="server" DataSourceID="SMSSQL" Width="100%" CssClass="NoPrint">
      <ItemTemplate>
         <h3>Sent SMS Records <small>(Remaining SMS: <%# Eval("SMS_Balance") %>)</small></h3>
      </ItemTemplate>
   </asp:FormView>
   <asp:SqlDataSource ID="SMSSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT SMS_Balance FROM Institution" ProviderName="<%$ ConnectionStrings:DBConnectionString.ProviderName %>">
   </asp:SqlDataSource>

    <div class="form-inline">
        <div class="form-group">
            <asp:TextBox ID="FromDateTextBox" CssClass="form-control Datetime" placeholder="From Date" runat="server"></asp:TextBox>
        </div>
         <div class="form-group">
            <asp:TextBox ID="ToDateTextBox" CssClass="form-control Datetime" placeholder="To Date" runat="server"></asp:TextBox>
        </div>
         <div class="form-group">
             <asp:Button ID="FindButton" runat="server" Text="Find" CssClass="btn btn-primary" />
        </div>
    </div>
    <asp:GridView ID="SentGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataKeyNames="SMS_Send_ID" DataSourceID="Sent_RecordSQL" AllowPaging="True" PageSize="50">
        <Columns>
            <asp:BoundField DataField="PhoneNumber" HeaderText="Phone Number" SortExpression="PhoneNumber" />
            <asp:BoundField DataField="TextSMS" HeaderText="Text" SortExpression="TextSMS" />
            <asp:BoundField DataField="TextCount" HeaderText="Text Count" SortExpression="TextCount" />
            <asp:BoundField DataField="SMSCount" HeaderText="SMS Count" SortExpression="SMSCount" />
            <asp:BoundField DataField="PurposeOfSMS" HeaderText="Purpose" SortExpression="PurposeOfSMS" />
            <asp:BoundField DataField="Date" HeaderText="Date" SortExpression="Date" />
        </Columns>
        <EmptyDataTemplate>
            No Record
        </EmptyDataTemplate>
        <PagerStyle CssClass="pgr" />
    </asp:GridView>
    <asp:SqlDataSource ID="Sent_RecordSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM [SMS_Send_Record] Where  (CAST(SMS_Send_Record.Date AS DATE) BETWEEN ISNULL(@From_Date, '1-1-1000') AND ISNULL(@To_Date, '1-1-3000'))ORDER BY SMS_Send_Record.Date DESC" CancelSelectOnNullParameter="False">
        <SelectParameters>
            <asp:ControlParameter ControlID="FromDateTextBox" Name="From_Date" PropertyName="Text" />
            <asp:ControlParameter ControlID="ToDateTextBox" Name="To_Date" PropertyName="Text" />
        </SelectParameters>
     </asp:SqlDataSource>

   
   <script>
      $(function () {
         $('.Datetime').datepicker({
             format: 'dd M yyyy',
             todayBtn: "linked",
             todayHighlight: true,
             autoclose: true
         });

         //get date in label
         var from = $("[id*=FromDateTextBox]").val();
         var To = $("[id*=ToDateTextBox]").val();

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
   </script>
</asp:Content>
