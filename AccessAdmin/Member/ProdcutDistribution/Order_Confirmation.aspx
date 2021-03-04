<%@ Page Title="Order Confirmation" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Order_Confirmation.aspx.cs" Inherits="CncAgro.AccessAdmin.Member.ProductDistribution.Order_Confirmation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Order Confirmation</h3>

    <div class="table-responsive">
        <asp:GridView ID="OrderGridView" runat="server" AllowSorting="True" AutoGenerateColumns="False" CssClass="mGrid" DataSourceID="ConfirmSQL" DataKeyNames="Product_DistributionID">
            <Columns>
               <asp:HyperLinkField SortExpression="Distribution_SN" DataTextField="Distribution_SN" DataNavigateUrlFields="Product_DistributionID" DataNavigateUrlFormatString="Order_Details.aspx?DistributionID={0}" HeaderText="Receipt No." />
                <asp:BoundField DataField="UserName" HeaderText="User Name" SortExpression="UserName" />
                <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                <asp:BoundField DataField="Product_Total_Amount" DataFormatString="{0:N}" HeaderText="Total Price" SortExpression="Product_Total_Amount" />
                <asp:BoundField DataField="Product_Total_Point" DataFormatString="{0:N}" HeaderText="Total Point" SortExpression="Product_Total_Point" />
                <asp:BoundField DataField="Commission_Amount" DataFormatString="{0:N}" HeaderText="Total Commi." SortExpression="Commission_Amount" />
                <asp:BoundField DataField="Net_Amount" DataFormatString="{0:N}" HeaderText="Net" ReadOnly="True" SortExpression="Net_Amount" />
                <asp:BoundField DataField="Product_Distribution_Date" DataFormatString="{0:d MMM yyyy}" HeaderText="Order Date" SortExpression="Product_Distribution_Date" />
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="ConfirmSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_Distribution.Product_Total_Point, Product_Distribution.Product_Distribution_Date, Product_Distribution.Distribution_SN, Product_Distribution.Commission_Amount, Product_Distribution.Net_Amount, Registration.UserName, Registration.Name, Product_Distribution.Product_Total_Amount, Product_Distribution.Product_DistributionID FROM Product_Distribution INNER JOIN Seller ON Product_Distribution.SellerID = Seller.SellerID INNER JOIN Registration ON Seller.SellerRegistrationID = Registration.RegistrationID WHERE (Product_Distribution.Is_Confirmed = 0)">
        </asp:SqlDataSource>
    </div>
    
    <script>
        $("[id*=AllCheckBox]").on("click", function () {
            var a = $(this), b = $(this).closest("table");
            $("input[type=checkbox]", b).each(function () {
                a.is(":checked") ? ($(this).attr("checked", "checked"), $("td", $(this).closest("tr")).addClass("selected")) : ($(this).removeAttr("checked"), $("td", $(this).closest("tr")).removeClass("selected"));
            });
        });

        //Add or Remove CheckBox Selected Color
        $("[id*=ConfirmCheckBox]").on("click", function () {
            $(this).is(":checked") ? ($("td", $(this).closest("tr")).addClass("selected")) : ($("td", $(this).closest("tr")).removeClass("selected"), $($(this).closest("tr")).removeClass("selected"));
        });
    </script>
</asp:Content>
