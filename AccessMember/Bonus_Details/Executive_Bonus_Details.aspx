<%@ Page Title="Executive Bonus" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Executive_Bonus_Details.aspx.cs" Inherits="CncAgro.AccessMember.Bonus_Details.Executive_Bonus_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Executive Bonus</h3>
    <asp:GridView ID="EBGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="EBSQL">
        <Columns>
            <asp:BoundField DataField="Month" DataFormatString="{0:y}" HeaderText="Month" SortExpression="Month" />
            <asp:BoundField DataField="Designation" HeaderText="Designation" SortExpression="Designation" />
            <asp:BoundField DataField="DesignationBouns_Amount" HeaderText="Amount" SortExpression="DesignationBouns_Amount" />
            <asp:BoundField DataField="DesignationBouns_Tax_Service_Charge" HeaderText="Tax &amp; Service" SortExpression="DesignationBouns_Tax_Service_Charge" />
            <asp:BoundField DataField="Net_Amount" HeaderText="Net Amount" ReadOnly="True" SortExpression="Net_Amount" />
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="EBSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT        Member_Bouns_Records_Executive_Details.MemberID, Member_Bouns_Records_Executive_Details.Month, Registration.UserName, Member_Designation.Designation, 
                         Member_Bouns_Records_Executive_Details.DesignationBouns_Amount, Member_Bouns_Records_Executive_Details.DesignationBouns_Tax_Service_Charge, 
                         Member_Bouns_Records_Executive_Details.Net_Amount
FROM            Member_Bouns_Records_Executive_Details INNER JOIN
                         Member ON Member_Bouns_Records_Executive_Details.MemberID = Member.MemberID INNER JOIN
                         Registration ON Member.MemberRegistrationID = Registration.RegistrationID INNER JOIN
                         Member_Designation ON Member_Bouns_Records_Executive_Details.Designation_SN = Member_Designation.Designation_SN
WHERE        (Member_Bouns_Records_Executive_Details.MemberID = @MemberID)">
        <SelectParameters>
            <asp:SessionParameter Name="MemberID" SessionField="MemberID" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
