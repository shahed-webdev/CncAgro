<%@ Page Title="Customer Selling Report" Language="C#" MasterPageFile="~/Seller.Master" AutoEventWireup="true" CodeBehind="Product_Selling_Report.aspx.cs" Inherits="CncAgro.AccessSeller.Product_Selling_Report" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .Amount_Summery { font-size: 20px; }
        .mGrid td table td { text-align: right; border: none !important; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Customer Selling Report</h3>
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
    <asp:SqlDataSource ID="TotalSQL" runat="server" CancelSelectOnNullParameter="False" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT SUM(ShoppingAmount) AS Total FROM  Shopping WHERE  (SellerID = @SellerID) AND  (CAST(ShoppingDate AS DATE) BETWEEN ISNULL(@From_Date, '1-1-1000') AND ISNULL(@To_Date, '1-1-3000'))">
        <SelectParameters>
            <asp:ControlParameter ControlID="From_TextBox" Name="From_Date" PropertyName="Text" />
            <asp:ControlParameter ControlID="TO_TextBox" Name="To_Date" PropertyName="Text" />
            <asp:SessionParameter Name="SellerID" SessionField="SellerID" />
        </SelectParameters>
    </asp:SqlDataSource>

    <div class="table-responsive">
        <asp:GridView ID="Sellingeport_GridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid" DataKeyNames="ShoppingID" DataSourceID="SellingeportSQL" AllowPaging="True" PageSize="50">
            <Columns>
                <asp:BoundField DataField="Shopping_SN" HeaderText="Receipt No" InsertVisible="False" ReadOnly="True" SortExpression="Shopping_SN" />
                <asp:BoundField DataField="UserName" HeaderText="User ID" SortExpression="UserName" />
                <asp:TemplateField HeaderText="Details" ItemStyle-HorizontalAlign="Right">
                    <ItemTemplate>
                         <asp:Repeater ID="RecordsRepeater" runat="server" DataSourceID="Selling_RecordsSQL">
                            <ItemTemplate>
                                <span style="color: #009933; font-weight: bold;"><%# Eval("Product_Name") %></span>
                                <br />
                                Quantity:<%# Eval("SellingQuantity") %>
                                <br />
                                Unit Price:<%# Eval("SellingUnitPrice") %>
                                <br />
                                Unit Point:<%# Eval("SellingUnitPoint") %>
                                <br />
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:HiddenField ID="ShoppingID_HF" runat="server" Value='<%# Eval("ShoppingID") %>' />
                        <asp:SqlDataSource ID="Selling_RecordsSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Product_Selling_Records.SellingQuantity, Product_Selling_Records.SellingUnitPrice, Product_Selling_Records.SellingUnitPoint, Product_Point_Code.Product_Name, Product_Point_Code.Product_Code FROM Product_Selling_Records INNER JOIN Product_Point_Code ON Product_Selling_Records.ProductID = Product_Point_Code.Product_PointID WHERE (Product_Selling_Records.ShoppingID = @ShoppingID)">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="ShoppingID_HF" Name="ShoppingID" PropertyName="Value" Type="Int32" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="ShoppingAmount" HeaderText="Total Amount" SortExpression="ShoppingAmount" />
                <asp:BoundField DataField="ShoppingPoint" HeaderText="Total Point" SortExpression="ShoppingPoint" />
                <asp:BoundField DataField="ShoppingDate" HeaderText="Date" SortExpression="ShoppingDate" DataFormatString="{0:d MMM yyyy}" />
            </Columns>
            <EmptyDataTemplate>
                No Records
            </EmptyDataTemplate>
            <PagerStyle CssClass="pgr" />
        </asp:GridView>
        <asp:SqlDataSource ID="SellingeportSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Shopping.Shopping_SN, Shopping.ShoppingAmount, Shopping.ShoppingPoint, Shopping.ShoppingDate, Registration.UserName, Shopping.ShoppingID FROM Shopping INNER JOIN Member ON Shopping.MemberID = Member.MemberID INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE  ( Shopping.SellerID = @SellerID) AND  (CAST(Shopping.ShoppingDate AS DATE) BETWEEN ISNULL(@From_Date, '1-1-1000') AND ISNULL(@To_Date, '1-1-3000'))" CancelSelectOnNullParameter="False">
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
    <button type="button" class="btn btn-primary hidden-print" onclick="window.print();"><span class="glyphicon glyphicon-print"></span>Print</button>
    <%} %>


    <script type="text/javascript">
        $(function () {
            $('.datepicker').datepicker({
                format: 'dd M yyyy',
                todayBtn: "linked",
                todayHighlight: true,
                autoclose: true
            });

            $("#Sell_Record").addClass('L_Active');

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
