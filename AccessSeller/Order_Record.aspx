<%@ Page Title="Order Record" Language="C#" MasterPageFile="~/Seller.Master" AutoEventWireup="true" CodeBehind="Order_Record.aspx.cs" Inherits="CncAgro.AccessSeller.Order_Record" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .SellerBuy { display: none; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Buying Record</h3>

    <div class="panel panel-primary">
        <div class="card-header">
            <ul class="nav panel-tabs">
                <li class="active"><a data-toggle="tab" href="#Pending">Pending Order</a></li>
                <li><a data-toggle="tab" href="#Confirm">Confirm Order</a></li>
                <li><a data-toggle="tab" href="#InStock">Received Product</a></li>
                <%if (DistributorGridView.Rows.Count > 0)
                    { %>
                <li><a data-toggle="tab" href="#SellerBuy">Buying From Distributor</a></li>
                <%} %>
            </ul>
        </div>
        <div class="card-body">
            <div class="tab-content">
                <div id="Pending" class="tab-pane active">
                    <div class="table-responsive">
                        <asp:GridView ID="PendingGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataKeyNames="Product_DistributionID,Net_Amount,SellerID" DataSourceID="PendingSQL" AllowSorting="True">
                            <Columns>
                                <asp:HyperLinkField SortExpression="Distribution_SN" DataTextField="Distribution_SN" DataNavigateUrlFields="Product_DistributionID" DataNavigateUrlFormatString="Order_Details.aspx?DistributionID={0}" HeaderText="Details" />
                                <asp:BoundField DataField="Product_Total_Amount" DataFormatString="{0:N}" HeaderText="Total Amount" SortExpression="Product_Total_Amount" />
                                <asp:BoundField DataField="Product_Total_Point" HeaderText="Total Point" SortExpression="Product_Total_Point" />
                                <asp:BoundField DataField="Commission_Amount" DataFormatString="{0:N}" HeaderText="Commission" SortExpression="Commission_Amount" />
                                <asp:BoundField DataField="Net_Amount" DataFormatString="{0:N}" HeaderText="Net" ReadOnly="True" SortExpression="Net_Amount" />
                                <asp:BoundField DataField="Product_Distribution_Date" DataFormatString="{0:d MMM yyyy}" HeaderText="Order Date" SortExpression="Product_Distribution_Date" />
                                <asp:TemplateField HeaderText="Order Process">
                                    <ItemTemplate>
                                        <input class="Ck_order" type="hidden" value="<%# Eval("Is_Seller_Order") %>" />
                                        <label class="Is_Seller_Order"></label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Delete" ShowHeader="False">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete" OnClientClick="return confirm('This order will delete permanently and your balance will return.\n Are you sure want to delete?')"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                No pending Record
                            </EmptyDataTemplate>
                        </asp:GridView>
                        <asp:SqlDataSource ID="PendingSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM [Product_Distribution] WHERE (SellerID = @SellerID AND Is_Confirmed = 0) AND (Is_Delivered = 0)" DeleteCommand="DELETE FROM Product_Distribution_Records WHERE (Product_DistributionID = @Product_DistributionID)
DELETE FROM Product_Distribution WHERE (Product_DistributionID = @Product_DistributionID)
UPDATE Seller SET Buying_Amount = Buying_Amount - @Net_Amount WHERE (SellerID = @SellerID)">
                            <DeleteParameters>
                                <asp:Parameter Name="Product_DistributionID" />
                                <asp:Parameter Name="Net_Amount" />
                                <asp:Parameter Name="SellerID" />
                            </DeleteParameters>
                            <SelectParameters>
                                <asp:SessionParameter Name="SellerID" SessionField="SellerID" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                </div>
                <div id="Confirm" class="tab-pane">
                    <div class="table-responsive">
                        <asp:GridView ID="ConfirmGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataKeyNames="Product_DistributionID" DataSourceID="ConfirmSQL" AllowSorting="True">
                            <Columns>
                                <asp:HyperLinkField SortExpression="Distribution_SN" DataTextField="Distribution_SN" DataNavigateUrlFields="Product_DistributionID" DataNavigateUrlFormatString="Order_Details.aspx?DistributionID={0}" HeaderText="Details" />
                                <asp:BoundField DataField="Product_Total_Amount" DataFormatString="{0:N}" HeaderText="Total Amount" SortExpression="Product_Total_Amount" />
                                <asp:BoundField DataField="Product_Total_Point" HeaderText="Total Point" SortExpression="Product_Total_Point" />
                                <asp:BoundField DataField="Commission_Amount" DataFormatString="{0:N}" HeaderText="Commission" SortExpression="Commission_Amount" />
                                <asp:BoundField DataField="Net_Amount" DataFormatString="{0:N}" HeaderText="Net" ReadOnly="True" SortExpression="Net_Amount" />
                                <asp:BoundField DataField="Product_Distribution_Date" DataFormatString="{0:d MMM yyyy}" HeaderText="Order Date" SortExpression="Product_Distribution_Date" />
                                <asp:TemplateField HeaderText="Order Process">
                                    <ItemTemplate>
                                        <input class="Ck_order" type="hidden" value="<%# Eval("Is_Seller_Order") %>" />
                                        <label class="Is_Seller_Order"></label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                No Confirm Record
                            </EmptyDataTemplate>
                        </asp:GridView>
                        <asp:SqlDataSource ID="ConfirmSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM [Product_Distribution] WHERE (SellerID = @SellerID AND Is_Confirmed = 1) AND (Is_Delivered = 0)">
                            <SelectParameters>
                                <asp:SessionParameter Name="SellerID" SessionField="SellerID" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                </div>
                <div id="InStock" class="tab-pane">
                    <div class="table-responsive">
                        <asp:GridView ID="InstockGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataKeyNames="Product_DistributionID" DataSourceID="InStockSQL" AllowSorting="True">
                            <Columns>
                                <asp:HyperLinkField SortExpression="Distribution_SN" DataTextField="Distribution_SN" DataNavigateUrlFields="Product_DistributionID" DataNavigateUrlFormatString="Order_Details.aspx?DistributionID={0}" HeaderText="Details" />
                                <asp:BoundField DataField="Product_Total_Amount" DataFormatString="{0:N}" HeaderText="Total Amount" SortExpression="Product_Total_Amount" />
                                <asp:BoundField DataField="Product_Total_Point" HeaderText="Total Point" SortExpression="Product_Total_Point" />
                                <asp:BoundField DataField="Commission_Amount" DataFormatString="{0:N}" HeaderText="Commission" SortExpression="Commission_Amount" />
                                <asp:BoundField DataField="Net_Amount" DataFormatString="{0:N}" HeaderText="Net" ReadOnly="True" SortExpression="Net_Amount" />
                                <asp:BoundField DataField="Product_Distribution_Date" DataFormatString="{0:d MMM yyyy}" HeaderText="Order Date" SortExpression="Product_Distribution_Date" />
                                <asp:TemplateField HeaderText="Order Process">
                                    <ItemTemplate>
                                        <input class="Ck_order" type="hidden" value="<%# Eval("Is_Seller_Order") %>" />
                                        <label class="Is_Seller_Order"></label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                No received Record
                            </EmptyDataTemplate>
                        </asp:GridView>
                        <asp:SqlDataSource ID="InStockSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM [Product_Distribution] WHERE (SellerID = @SellerID AND Is_Confirmed = 1 AND Is_Delivered = 1)">
                            <SelectParameters>
                                <asp:SessionParameter Name="SellerID" SessionField="SellerID" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                </div>
                <div id="SellerBuy" class="tab-pane">
                    <div class="table-responsive">
                        <asp:GridView ID="DistributorGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataKeyNames="DistributorShoppingID" DataSourceID="DistributorSQL" AllowSorting="True">
                            <Columns>
                                <asp:HyperLinkField SortExpression="DistributorShopping_SN" DataTextField="DistributorShopping_SN" DataNavigateUrlFields="DistributorShoppingID" DataNavigateUrlFormatString="Buying_Details.aspx?ShoppingID={0}" HeaderText="Details" />
                                <asp:BoundField DataField="UserName" HeaderText="Username" SortExpression="UserName" />
                                <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                                <asp:BoundField DataField="Phone" HeaderText="Phone" SortExpression="Phone" />
                                <asp:BoundField DataField="Product_Total_Amount" HeaderText="Total Amount" SortExpression="Product_Total_Amount" />
                                <asp:BoundField DataField="ShoppingPoint" HeaderText="Total Point" SortExpression="ShoppingPoint" />
                                <asp:BoundField DataField="Commission_Amount" HeaderText="Commission" SortExpression="Commission_Amount" />
                                <asp:BoundField DataField="Net_Amount" HeaderText="Net" ReadOnly="True" SortExpression="Net_Amount" />
                                <asp:BoundField DataField="ShoppingDate" HeaderText="Date" SortExpression="ShoppingDate" DataFormatString="{0:d MMM yyyy}" />
                            </Columns>
                        </asp:GridView>

                        <asp:SqlDataSource ID="DistributorSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Shopping_Distributor.DistributorShoppingID, Shopping_Distributor.SellerID, Shopping_Distributor.BuyingSellerID, Shopping_Distributor.ShoppingPoint, Shopping_Distributor.Product_Total_Amount, Shopping_Distributor.Commission_Amount, Shopping_Distributor.DistributorShopping_SN, Shopping_Distributor.Net_Amount, Shopping_Distributor.ShoppingDate, Registration.UserName, Registration.Name, Registration.Phone FROM Shopping_Distributor INNER JOIN Seller ON Shopping_Distributor.SellerID = Seller.SellerID INNER JOIN Registration ON Seller.SellerRegistrationID = Registration.RegistrationID WHERE (Shopping_Distributor.BuyingSellerID = @SellerID)">
                            <SelectParameters>
                                <asp:SessionParameter Name="SellerID" SessionField="SellerID" />
                            </SelectParameters>
                        </asp:SqlDataSource>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        $(function () {
            $("#Order_Record").addClass('L_Active');

            $(".Ck_order").each(function () {
                if ($(this).val() === 'False') {
                    $(this).next(".Is_Seller_Order").text("Authority");
                }
                else {
                    $(this).next(".Is_Seller_Order").text("My order");
                }
            });
        });
    </script>
</asp:Content>
