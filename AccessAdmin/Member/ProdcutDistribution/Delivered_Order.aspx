<%@ Page Title="Delivered Order" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Delivered_Order.aspx.cs" Inherits="DnbBD.AccessAdmin.Member.ProdcutDistribution.Delivered_Order" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Delivered Order List</h3>

    <div class="card card-body mb-3">
        <div class="table-responsive">
            <asp:GridView ID="OrderGridView" runat="server" AllowSorting="True" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="DeliverySQL" DataKeyNames="Product_DistributionID,MemberID">
                <Columns>
                    <asp:HyperLinkField SortExpression="Distribution_SN" DataTextField="Distribution_SN" DataNavigateUrlFields="Product_DistributionID" DataNavigateUrlFormatString="Delivery_Details.aspx?DistributionID={0}" HeaderText="Receipt No." />
                    <asp:BoundField DataField="UserName" HeaderText="User Name" SortExpression="UserName" />
                    <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                    <asp:BoundField DataField="Product_Total_Amount" DataFormatString="{0:N}" HeaderText="Total Price" SortExpression="Product_Total_Amount" />
                    <asp:BoundField DataField="Delivery_Date" DataFormatString="{0:d MMM yyyy}" HeaderText="Delivery Date" SortExpression="Delivery_Date" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="DeliverySQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_Distribution.Product_Total_Point, Product_Distribution.Distribution_SN, Registration.UserName, Registration.Name, Product_Distribution.Product_Total_Amount, Product_Distribution.Product_DistributionID, Product_Distribution.MemberID, Product_Distribution.Confirm_Date, Product_Distribution.Delivery_Date FROM Product_Distribution INNER JOIN Member ON Product_Distribution.MemberID = Member.MemberID INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE (Product_Distribution.Is_Confirmed = 1) AND (Product_Distribution.Is_Delivered = 1)" UpdateCommand="UPDATE Product_Distribution SET Is_Delivered = 1, Delivery_Date = GETDATE(), Delivered_RegistrationID = @Delivered_RegistrationID WHERE (Product_DistributionID = @Product_DistributionID)">
                <UpdateParameters>
                    <asp:SessionParameter Name="Delivered_RegistrationID" SessionField="RegistrationID" />
                    <asp:Parameter Name="Product_DistributionID" />
                </UpdateParameters>
            </asp:SqlDataSource>

            <br />
        </div>
    </div>
</asp:Content>
