<%@ Page Title="Distributor Selling Report" Language="C#" MasterPageFile="~/Seller.Master" AutoEventWireup="true" CodeBehind="Distributor_Selling_Report.aspx.cs" Inherits="CncAgro.AccessSeller.Distributor_Selling_Report" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .Amount_Summery { font-size: 20px; }
        .mGrid td table td { text-align: right; border: none !important; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Distributor Selling Report</h3>

    <div class="NoPrint form-inline">
        <div class="form-group">
            <asp:TextBox ID="From_TextBox" placeholder="From Date" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" runat="server" CssClass="form-control datepicker"></asp:TextBox>
        </div>
        <div class="form-group">
            <asp:TextBox ID="TO_TextBox" placeholder="To Date" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" runat="server" CssClass="form-control datepicker"></asp:TextBox>
        </div>
        <div class="form-group">
            <asp:Button ID="FindButton" runat="server" CssClass="btn btn-primary" Text="Find" />
        </div>
    </div>

    <asp:FormView ID="Total_FormView" runat="server" DataSourceID="TotalSQL" Width="100%">
        <ItemTemplate>
            <div class="Amount_Summery alert alert-success">
                <label class="Date"></label>
                Total: <%#Eval("Total","{0:N}") %>
                Tk.
            </div>
        </ItemTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="TotalSQL" runat="server" CancelSelectOnNullParameter="False" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT SUM(Product_Total_Amount) AS Total FROM  Shopping_Distributor WHERE  (SellerID = @SellerID) AND  (CAST(ShoppingDate AS DATE) BETWEEN ISNULL(@From_Date, '1-1-1000') AND ISNULL(@To_Date, '1-1-3000'))">
        <SelectParameters>
            <asp:ControlParameter ControlID="From_TextBox" Name="From_Date" PropertyName="Text" />
            <asp:ControlParameter ControlID="TO_TextBox" Name="To_Date" PropertyName="Text" />
            <asp:SessionParameter Name="SellerID" SessionField="SellerID" />
        </SelectParameters>
    </asp:SqlDataSource>

    <div class="table-responsive">
        <asp:GridView ID="Sellingeport_GridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataKeyNames="DistributorShoppingID" DataSourceID="SellingeportSQL" AllowPaging="True" PageSize="50" AllowSorting="True">
            <Columns>
                <asp:BoundField DataField="DistributorShopping_SN" HeaderText="Receipt No" SortExpression="Shopping_SN" />
                <asp:BoundField DataField="UserName" HeaderText="User ID" SortExpression="UserName" />
                <asp:TemplateField HeaderText="Details" ItemStyle-HorizontalAlign="Right">
                    <ItemTemplate>
                        <asp:Repeater ID="RecordsRepeater" runat="server" DataSourceID="Selling_RecordsSQL">
                            <ItemTemplate>
                                <span style="color: #009933; font-weight: bold;"><%# Eval("Product_Name") %></span>
                                <br />
                                Quantity:<%# Eval("SellingQuantity") %><br />Unit Price:<%# Eval("SellingUnitPrice") %><br />Unit Point:<%# Eval("SellingUnitPoint") %><br />Unit Commission: <%# Eval("SellingUnit_Commission") %><br />
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:HiddenField ID="ShoppingID_HF" runat="server" Value='<%# Eval("DistributorShoppingID") %>' />
                        <asp:SqlDataSource ID="Selling_RecordsSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_Point_Code.Product_Name, Product_Point_Code.Product_Code, Shopping_Distributor_Record.SellingQuantity, Shopping_Distributor_Record.SellingUnitPrice, Shopping_Distributor_Record.SellingUnitPoint, Shopping_Distributor_Record.SellingUnit_Commission FROM Product_Point_Code INNER JOIN Shopping_Distributor_Record ON Product_Point_Code.Product_PointID = Shopping_Distributor_Record.ProductID WHERE (Shopping_Distributor_Record.DistributorShoppingID = @DistributorShoppingID)">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="ShoppingID_HF" Name="DistributorShoppingID" PropertyName="Value" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Product_Total_Amount" HeaderText="Total Amount" SortExpression="Product_Total_Amount" />
                <asp:BoundField DataField="ShoppingPoint" HeaderText="Total Point" SortExpression="ShoppingPoint" />
                <asp:BoundField DataField="Commission_Amount" HeaderText="Total Comm." SortExpression="Commission_Amount" />  
                <asp:BoundField DataField="ShoppingDate" HeaderText="Date" SortExpression="ShoppingDate" DataFormatString="{0:d MMM yyyy}" />
            </Columns>
            <EmptyDataTemplate>
                No Records
            </EmptyDataTemplate>
            <PagerStyle CssClass="pgr" />
        </asp:GridView>
        <asp:SqlDataSource ID="SellingeportSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Shopping_Distributor.DistributorShopping_SN, Shopping_Distributor.Product_Total_Amount, Shopping_Distributor.ShoppingPoint, Shopping_Distributor.ShoppingDate, Registration.UserName, Shopping_Distributor.DistributorShoppingID, Shopping_Distributor.Commission_Amount FROM Registration INNER JOIN Seller ON Registration.RegistrationID = Seller.SellerRegistrationID INNER JOIN Shopping_Distributor ON Seller.SellerID = Shopping_Distributor.BuyingSellerID WHERE (Shopping_Distributor.SellerID = @SellerID) AND (CAST(Shopping_Distributor.ShoppingDate AS DATE) BETWEEN ISNULL(@From_Date, '1-1-1000') AND ISNULL(@To_Date, '1-1-3000'))" CancelSelectOnNullParameter="False">
            <SelectParameters>
                <asp:ControlParameter ControlID="From_TextBox" Name="From_Date" PropertyName="Text" />
                <asp:ControlParameter ControlID="TO_TextBox" Name="To_Date" PropertyName="Text" />
                <asp:SessionParameter Name="SellerID" SessionField="SellerID" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>


    <%if (Sellingeport_GridView.Rows.Count > 0)
        { %>
    <br />
    <button type="button" class="btn btn-primary hidden-print" onclick="window.print();"><span class="glyphicon glyphicon-print"></span> Print</button>
    <%} %>


    <script type="text/javascript">
        $(function () {
            $('.datepicker').datepicker({
                format: 'dd M yyyy',
                todayBtn: "linked",
                todayHighlight: true,
                autoclose: true
            });

            $("#Distributor_Record").addClass('L_Active');

            //get date in label
            var from = $("[id*=From_TextBox]").val();
            var To = $("[id*=TO_TextBox]").val();

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


        function isNumberKey(a) { a = a.which ? a.which : event.keyCode; return 46 != a && 31 < a && (48 > a || 57 < a) ? !1 : !0 };

    </script>
</asp:Content>
