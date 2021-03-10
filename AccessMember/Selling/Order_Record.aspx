<%@ Page Title="Order Record" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Order_Record.aspx.cs" Inherits="CncAgro.AccessMember.Selling.Order_Record" %>

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
            </ul>
        </div>
        <div class="card-body">
            <div class="tab-content">
                <div id="Pending" class="tab-pane active">
                    <div class="table-responsive">
                        <asp:GridView ID="PendingGridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataKeyNames="Product_DistributionID,MemberID" AllowSorting="True" DataSourceID="PendingSQL">
                            <Columns>
                                <asp:HyperLinkField SortExpression="Distribution_SN" DataTextField="Distribution_SN" DataNavigateUrlFields="Product_DistributionID" DataNavigateUrlFormatString="Order_Details.aspx?id={0}" HeaderText="Details" />
                                <asp:BoundField DataField="Product_Total_Amount" DataFormatString="{0:N}" HeaderText="Total Amount" SortExpression="Product_Total_Amount" />
                                <asp:BoundField DataField="InsertDate" DataFormatString="{0:d MMM yyyy}" HeaderText="Order Date" SortExpression="InsertDate" />
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
                        <asp:SqlDataSource ID="PendingSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM [Product_Distribution] WHERE (MemberID = @MemberID AND Is_Confirmed = 0) AND (Is_Delivered = 0)" DeleteCommand="DELETE FROM Product_Distribution_Records WHERE (Product_DistributionID = @Product_DistributionID)
DELETE FROM Product_Distribution WHERE (Product_DistributionID = @Product_DistributionID)">
                            <DeleteParameters>
                                <asp:Parameter Name="Product_DistributionID" />
                            </DeleteParameters>
                            <SelectParameters>
                                <asp:SessionParameter Name="MemberID" SessionField="MemberID" />
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
                                <asp:BoundField DataField="Product_Distribution_Date" DataFormatString="{0:d MMM yyyy}" HeaderText="Order Date" SortExpression="Product_Distribution_Date" />
                            </Columns>
                            <EmptyDataTemplate>
                                No Confirm Record
                            </EmptyDataTemplate>
                        </asp:GridView>
                        <asp:SqlDataSource ID="ConfirmSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM [Product_Distribution] WHERE (MemberID = @MemberID AND Is_Confirmed = 1) AND (Is_Delivered = 0)">
                            <SelectParameters>
                                <asp:SessionParameter Name="MemberID" SessionField="MemberID" />
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
                                <asp:BoundField DataField="Product_Distribution_Date" DataFormatString="{0:d MMM yyyy}" HeaderText="Order Date" SortExpression="Product_Distribution_Date" />
                            </Columns>
                            <EmptyDataTemplate>
                                No received Record
                            </EmptyDataTemplate>
                        </asp:GridView>
                        <asp:SqlDataSource ID="InStockSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM [Product_Distribution] WHERE (MemberID = @MemberID AND Is_Confirmed = 1 AND Is_Delivered = 1)">
                            <SelectParameters>
                                <asp:SessionParameter Name="MemberID" SessionField="MemberID" />
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
