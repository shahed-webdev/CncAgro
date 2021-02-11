<%@ Page Title="" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Received_Details.aspx.cs" Inherits="CncAgro.AccessMember.Bonus_Details.Received_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
   <h3>Balance Received Details</h3>
   <a class="Sub_Link" href="../MemberProfile.aspx"><< Back To Previous</a>
   <asp:GridView ID="ReceivedGridView" runat="server" CssClass="mGrid" AutoGenerateColumns="False" DataSourceID="ReceivedSQL" AllowPaging="True" PageSize="50">
      <Columns>
         <asp:BoundField DataField="UserName" HeaderText="Sender Username" SortExpression="UserName" />
         <asp:BoundField DataField="Name" HeaderText="Sender Name" SortExpression="Name" />
         <asp:BoundField DataField="Phone" HeaderText="Sender Phone" SortExpression="Phone" />
         <asp:BoundField DataField="Amount" HeaderText="Received Amount" SortExpression="Amount" />
         <asp:BoundField DataField="Transition_Details" HeaderText="Transition Details" SortExpression="Transition_Details" />
         <asp:BoundField DataField="TransitionDate" HeaderText="Received Date" SortExpression="TransitionDate" />
      </Columns>
      <PagerStyle CssClass="pgr" />
      <EmptyDataTemplate>
         Empty
      </EmptyDataTemplate>
   </asp:GridView>
   <asp:SqlDataSource ID="ReceivedSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Fund_Transition.TransitionDate, Fund_Transition.Transition_Details, Fund_Transition.Amount, Registration.UserName, Registration.Name, Registration.Phone FROM Fund_Transition INNER JOIN Registration ON Fund_Transition.Sent_RegistrationID = Registration.RegistrationID WHERE (Fund_Transition.Received_RegistrationID = @Received_RegistrationID)">
      <SelectParameters>
         <asp:SessionParameter Name="Received_RegistrationID" SessionField="RegistrationID" />
      </SelectParameters>
   </asp:SqlDataSource>
</asp:Content>
