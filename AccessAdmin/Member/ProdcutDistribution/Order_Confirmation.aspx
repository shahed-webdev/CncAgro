<%@ Page Title="Order Confirmation" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Order_Confirmation.aspx.cs" Inherits="CncAgro.AccessAdmin.Member.ProductDistribution.Order_Confirmation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Order Confirmation</h3>

    <div class="card card-body">
        <div class="table-responsive">
            <asp:GridView ID="OrderGridView" runat="server" AllowSorting="True" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="ConfirmSQL" DataKeyNames="Product_DistributionID">
                <Columns>
                    <asp:HyperLinkField SortExpression="Distribution_SN" DataTextField="Distribution_SN" DataNavigateUrlFields="Product_DistributionID" DataNavigateUrlFormatString="Order_Details.aspx?DistributionID={0}" HeaderText="Receipt No." />
                    <asp:BoundField DataField="UserName" HeaderText="User Name" SortExpression="UserName" />
                    <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                    <asp:BoundField DataField="Product_Total_Amount" DataFormatString="{0:N}" HeaderText="Total Price" SortExpression="Product_Total_Amount" />
                    <asp:BoundField DataField="InsertDate" DataFormatString="{0:d MMM yyyy}" HeaderText="Order Date" SortExpression="InsertDate" />
                </Columns>
                <EmptyDataTemplate>
                    no pending record
                </EmptyDataTemplate>
            </asp:GridView>
            <asp:SqlDataSource ID="ConfirmSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_Distribution.Product_Total_Point, Product_Distribution.Distribution_SN, Registration.UserName, Registration.Name, Product_Distribution.Product_Total_Amount, Product_Distribution.Product_DistributionID, Product_Distribution.InsertDate FROM Product_Distribution INNER JOIN Member ON Product_Distribution.MemberID = Member.MemberID INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE (Product_Distribution.Is_Confirmed = 0)"></asp:SqlDataSource>
        </div>
    </div>
</asp:Content>
