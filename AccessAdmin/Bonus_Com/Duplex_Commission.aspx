<%@ Page Title="Duplex Commission" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Duplex_Commission.aspx.cs" Inherits="CncAgro.AccessAdmin.Bonus_Com.Duplex_Commission" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .Archivers { margin-bottom: 2px; font-size: 18px; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>DUPLEX COMMISSION</h3>
    <div class="panel panel-primary">
        <div class="card-header">
            <ul class="nav panel-tabs">
                <li class="active"><a data-toggle="tab" href="#Flash_Matching">Duplex Commission</a></li>
                <li><a data-toggle="tab" href="#Matching_Achievers">Commission Achievers</a></li>
            </ul>
        </div>
        <div class="card-body">
            <div class="tab-content">
                <div id="Flash_Matching" class="tab-pane active">
                    <asp:GridView ID="FlashGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataKeyNames="MemberID" DataSourceID="Flash_ListSQL">
                        <Columns>
                            <asp:BoundField DataField="UserName" HeaderText="User Name" SortExpression="UserName" />
                            <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                            <asp:BoundField DataField="Left_Carry_Point" HeaderText="L.P." SortExpression="Left_Carry_Point" />
                            <asp:BoundField DataField="Right_Carry_Point" HeaderText="R.P." SortExpression="Right_Carry_Point" />
                        </Columns>
                        <EmptyDataTemplate>
                            No Record
                        </EmptyDataTemplate>
                    </asp:GridView>
                    <asp:SqlDataSource ID="Flash_ListSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Member.MemberID, Registration.UserName, Registration.Name, Member.Left_Carry_Point, Member.Right_Carry_Point
FROM  Member INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID
WHERE (Member.Is_Identified = 1)  AND (Member.Member_Package_Serial&gt; 0) AND
(Member.Left_Carry_Point &gt;= 1000 AND Member.Right_Carry_Point &gt;= 1000)
ORDER BY Member.Left_Carry_Point + Member.Right_Carry_Point DESC"></asp:SqlDataSource>

                </div>

                <div id="Matching_Achievers" class="tab-pane">
                    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                        <ContentTemplate>
                            <div class="table-responsive">
                                <asp:GridView ID="DateGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataKeyNames="Date" DataSourceID="DateSQL">
                                    <Columns>
                                        <asp:CommandField ShowSelectButton="True" HeaderText="Select" SelectText="Details" />
                                        <asp:BoundField DataField="Date" DataFormatString="{0:d MMM yyyy}" HeaderText="Date" ReadOnly="True" SortExpression="Date" />
                                        <asp:BoundField DataField="Matching_Point" HeaderText="Matching Point" ReadOnly="True" SortExpression="Matching_Point" />
                                        <asp:BoundField DataField="Amount" HeaderText="Amount" ReadOnly="True" SortExpression="Amount" />
                                        <asp:BoundField DataField="Tax_Service_Charge" HeaderText="Tax/S Charge" ReadOnly="True" SortExpression="Tax_Service_Charge" />
                                        <asp:BoundField DataField="Net_Amount" HeaderText="Net Amount" ReadOnly="True" SortExpression="Net_Amount" />
                                    </Columns>
                                    <SelectedRowStyle CssClass="Selected" />
                                </asp:GridView>
                                <asp:SqlDataSource ID="DateSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT        CONVERT(date, Insert_Date) AS Date, SUM(Matching_Point) AS Matching_Point, SUM(Amount) AS Amount, SUM(Tax_Service_Charge) AS Tax_Service_Charge, SUM(Net_Amount) AS Net_Amount FROM Member_Bouns_Records_Infinity_Matching GROUP BY CONVERT(date, Insert_Date) ORDER BY Date DESC"></asp:SqlDataSource>

                                <h4 class="Archivers">Achievers Customers</h4>
                                <asp:GridView ID="Bouns_AchieversGridView" runat="server" AllowSorting="True" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="Bouns_AchieversSQL" AllowPaging="True" PageSize="60">
                                    <Columns>
                                        <asp:BoundField DataField="UserName" HeaderText="Username" SortExpression="UserName" />
                                        <asp:BoundField DataField="Matching_Point" HeaderText="Matching Point" SortExpression="Matching_Point" />
                                        <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" />
                                        <asp:BoundField DataField="Tax_Service_Charge" HeaderText="Tax and Service Charge" SortExpression="Tax_Service_Charge" />
                                        <asp:BoundField DataField="Net_Amount" HeaderText="Net Amount" ReadOnly="True" SortExpression="Net_Amount" />
                                    </Columns>
                                    <EmptyDataTemplate>
                                        Select Details
                                    </EmptyDataTemplate>
                                    <PagerStyle CssClass="pgr" />
                                </asp:GridView>
                                <asp:SqlDataSource ID="Bouns_AchieversSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Member_Bouns_Records_Infinity_Matching.Matching_Point, Member_Bouns_Records_Infinity_Matching.Flash_Point, Member_Bouns_Records_Infinity_Matching.Carry_Point, Member_Bouns_Records_Infinity_Matching.Weak_Side, Member_Bouns_Records_Infinity_Matching.Amount, Member_Bouns_Records_Infinity_Matching.Tax_Service_Charge, Member_Bouns_Records_Infinity_Matching.Net_Amount, Member_Bouns_Records_Infinity_Matching.Insert_Date, Registration.UserName FROM Member_Bouns_Records_Infinity_Matching INNER JOIN Member ON Member_Bouns_Records_Infinity_Matching.MemberID = Member.MemberID INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE (CONVERT (date, Member_Bouns_Records_Infinity_Matching.Insert_Date) = @Date) ORDER BY Member_Bouns_Records_Infinity_Matching.Net_Amount DESC">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="DateGridView" Name="Date" PropertyName="SelectedValue" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>

    <asp:UpdateProgress ID="UpdateProgress" runat="server">
        <ProgressTemplate>
            <div id="progress_BG"></div>
            <div id="progress">
                <img src="/CSS/Image/loading.gif" alt="Loading..." />
                <br />
                <b>Loading...</b>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>

</asp:Content>
