<%@ Page Title="" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Send_Details.aspx.cs" Inherits="CncAgro.AccessMember.Bonus_Details.Send_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
   <h3>Balance Transfer Details</h3>
   <a class="Sub_Link" href="../MemberProfile.aspx"><< Back To Previous</a>
   <asp:GridView ID="TransferGridView" runat="server" CssClass="mGrid" AutoGenerateColumns="False" DataSourceID="SendSQL" AllowPaging="True" PageSize="50">
      <Columns>
         <asp:BoundField DataField="UserName" HeaderText="Recipient Username" SortExpression="UserName" />
         <asp:BoundField DataField="Name" HeaderText="Recipient Name" SortExpression="Name" />
         <asp:BoundField DataField="Phone" HeaderText="Recipient Phone" SortExpression="Phone" />
         <asp:BoundField DataField="Amount" HeaderText="Sent Amount" SortExpression="Amount" />
         <asp:BoundField DataField="Transition_Details" HeaderText="Transition Details" SortExpression="Transition_Details" />
         <asp:BoundField DataField="TransitionDate" HeaderText="Sent Date" SortExpression="TransitionDate" />
      </Columns>
      <PagerStyle CssClass="pgr" />
      <EmptyDataTemplate>
         Empty
      </EmptyDataTemplate>
   </asp:GridView>
   <asp:SqlDataSource ID="SendSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Fund_Transition.TransitionDate, Fund_Transition.Transition_Details, Fund_Transition.Amount, Registration.UserName, Registration.Name, Registration.Phone FROM Fund_Transition INNER JOIN Registration ON Fund_Transition.Received_RegistrationID = Registration.RegistrationID WHERE (Fund_Transition.Sent_RegistrationID = @Sent_RegistrationID)">
      <SelectParameters>
         <asp:SessionParameter Name="Sent_RegistrationID" SessionField="RegistrationID" Type="Int32" />
      </SelectParameters>
   </asp:SqlDataSource>
</asp:Content>
