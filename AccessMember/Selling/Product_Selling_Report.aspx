<%@ Page Title="Customer Selling Report" Language="C#" MasterPageFile="~/Member.Master" AutoEventWireup="true" CodeBehind="Product_Selling_Report.aspx.cs" Inherits="CncAgro.AccessMember.Selling.Product_Selling_Report" %>

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
        <div class="form-group mx-2">
            <asp:TextBox ID="TO_TextBox" placeholder="To Date" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" runat="server" CssClass="form-control datepicker"></asp:TextBox>
        </div>
        <div class="form-group">
            <asp:Button ID="FindButton" runat="server" CssClass="btn btn-primary" Text="Find" />
        </div>
    </div>

    <div class="card card-body mt-3">
        <asp:FormView ID="Total_FormView" runat="server" DataSourceID="TotalSQL" Width="100%">
            <ItemTemplate>
                <h5>
                    <label class="Date"></label>
                    Total: <%#Eval("Total","{0:N}") %>
                Tk.
                </h5>
            </ItemTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="TotalSQL" runat="server" CancelSelectOnNullParameter="False" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT SUM(ShoppingAmount) AS Total FROM Shopping WHERE (CAST(ShoppingDate AS DATE) BETWEEN ISNULL(@From_Date, '1-1-1000') AND ISNULL(@To_Date, '1-1-3000')) AND (Seller_RegistrationID = @RegistrationID)">
            <SelectParameters>
                <asp:ControlParameter ControlID="From_TextBox" Name="From_Date" PropertyName="Text" />
                <asp:ControlParameter ControlID="TO_TextBox" Name="To_Date" PropertyName="Text" />
                <asp:SessionParameter Name="RegistrationID" SessionField="RegistrationID" />
            </SelectParameters>
        </asp:SqlDataSource>

        <div class="table-responsive">
            <asp:GridView ID="Sellingeport_GridView" runat="server" AutoGenerateColumns="False" CssClass="mGrid table-bordered" DataKeyNames="ShoppingID" DataSourceID="SellingeportSQL" AllowPaging="True" PageSize="50">
                <Columns>
                    <asp:HyperLinkField SortExpression="Shopping_SN" DataTextField="Shopping_SN" DataNavigateUrlFields="ShoppingID" DataNavigateUrlFormatString="Receipt.aspx?ShoppingID={0}" HeaderText="Receipt No" />
                    <asp:BoundField DataField="UserName" HeaderText="User ID" SortExpression="UserName" />
                    <asp:TemplateField HeaderText="Details">
                        <ItemTemplate>
                            <asp:Repeater ID="RecordsRepeater" runat="server" DataSourceID="Selling_RecordsSQL">
                                <ItemTemplate>
                                    <p class="mb-0"><strong><%# Eval("Product_Name") %></strong></p>
                                    <span>৳<%# Eval("SellingUnitPrice") %> x<%# Eval("SellingQuantity") %></span>
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
            <asp:SqlDataSource ID="SellingeportSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Shopping.Shopping_SN, Shopping.ShoppingAmount, Shopping.ShoppingPoint, Shopping.ShoppingDate, Registration.UserName, Shopping.ShoppingID, Shopping.Seller_RegistrationID FROM Shopping INNER JOIN Member ON Shopping.MemberID = Member.MemberID INNER JOIN Registration ON Member.MemberRegistrationID = Registration.RegistrationID WHERE (CAST(Shopping.ShoppingDate AS DATE) BETWEEN ISNULL(@From_Date, '1-1-1000') AND ISNULL(@To_Date, '1-1-3000')) AND (Shopping.Seller_RegistrationID = @RegistrationID)" CancelSelectOnNullParameter="False">
                <SelectParameters>
                    <asp:ControlParameter ControlID="From_TextBox" Name="From_Date" PropertyName="Text" />
                    <asp:ControlParameter ControlID="TO_TextBox" Name="To_Date" PropertyName="Text" />
                    <asp:SessionParameter Name="RegistrationID" SessionField="RegistrationID" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
    </div>
    

    <script type="text/javascript">
        $(function () {
            $('.datepicker').datepicker({
                format: 'dd M yyyy',
                todayBtn: "linked",
                todayHighlight: true,
                autoclose: true
            });

            $("#selling-record").addClass('L_Active');

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
